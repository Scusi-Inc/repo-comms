#!/usr/bin/env bash
# Install (or update) wallnote in the current git repo. Needs: git, gh (logged in), python3.
#   gh api repos/Scusi-Inc/wallnote/contents/install.sh --jq .content | base64 -d | bash
set -euo pipefail
SRC=${WALLNOTE_SRC:-Scusi-Inc/wallnote}
REF=${WALLNOTE_REF:-main}
root=$(git rev-parse --show-toplevel) || { echo "run inside a git repo" >&2; exit 1; }
gh api "repos/$SRC" --jq .full_name >/dev/null 2>&1 || { echo "wallnote: can't reach $SRC (is gh logged in?)" >&2; exit 1; }
cd "$root"

fetch() { # src-path dest-path
  # Write to a temp file, then rename. A rename swaps in a new file, so a running copy of
  # .wallnote/wallnote (e.g. the one executing `wallnote update`) keeps reading the old one intact.
  mkdir -p "$(dirname "$2")"
  local tmp="$2.tmp.$$"
  gh api "repos/$SRC/contents/$1?ref=$REF" --jq .content | base64 -d > "$tmp"
  [[ -s "$tmp" ]] || { rm -f "$tmp"; echo "wallnote: failed to download $1" >&2; exit 1; }
  [[ -f "$2" && -x "$2" ]] && chmod +x "$tmp"
  mv -f "$tmp" "$2"
}

fetch .wallnote/wallnote .wallnote/wallnote && chmod +x .wallnote/wallnote
fetch .wallnote/PROTOCOL.md .wallnote/PROTOCOL.md
# Team settings: create only if missing, never overwrite.
[[ -f .wallnote/config ]] || fetch .wallnote/config .wallnote/config
[[ -f .wallnote/rules.md ]] || fetch .wallnote/rules.md .wallnote/rules.md

mkdir -p .github/workflows
cat > .github/workflows/wallnote.yml <<'YAML'
name: wallnote
# Keeps "whose turn is it" (the single assignee) correct when people post from the GitHub UI.
on:
  issues:
    types: [opened]
  issue_comment:
    types: [created]
permissions:
  issues: write
  contents: read
# Runs queue per thread. Even if GitHub drops a pending run during rapid comments, the next run
# re-derives the ball from the thread's newest post, so no handoff is lost.
concurrency:
  group: wallnote-${{ github.event.issue.number }}
  cancel-in-progress: false
jobs:
  ball:
    if: ${{ !github.event.issue.pull_request }}
    runs-on: ubuntu-latest
    timeout-minutes: 2
    steps:
      - uses: actions/checkout@v4
        with:
          sparse-checkout: .wallnote
      - run: bash .wallnote/wallnote _action
        env:
          GH_TOKEN: ${{ github.token }}
YAML

# Agent instructions. Normally a block in AGENTS.md that CLAUDE.md imports. If this repo marks
# AGENTS.md as superseded, put the block straight into CLAUDE.md instead (no import loop).
block=$(gh api "repos/$SRC/contents/AGENTS.md?ref=$REF" --jq .content | base64 -d)
target=AGENTS.md
if [[ -f AGENTS.md ]] && sed '/<!-- wallnote:start -->/,/<!-- wallnote:end -->/d' AGENTS.md | grep -qiE 'supersede|deprecated|do not (use|edit)'; then
  target=CLAUDE.md
fi
python3 - "$block" "$target" <<'EOF_PY'
import os, re, sys
block, p = sys.argv[1].strip(), sys.argv[2]
s = open(p).read() if os.path.exists(p) else ''
pat = r'<!-- wallnote:start -->.*?<!-- wallnote:end -->'
s = re.sub(pat, lambda m: block, s, flags=re.S) if re.search(pat, s, flags=re.S) else (s.rstrip() + '\n\n' + block if s.strip() else block)
open(p, 'w').write(s.rstrip() + '\n')
EOF_PY
if [[ "$target" == AGENTS.md ]]; then
  # Make Claude Code read AGENTS.md.
  if [[ ! -f CLAUDE.md ]]; then echo "@AGENTS.md" > CLAUDE.md
  elif ! grep -q '@AGENTS.md' CLAUDE.md; then printf '\n@AGENTS.md\n' >> CLAUDE.md; fi
else
  # Clean up after earlier installs: drop our old block from AGENTS.md and the CLAUDE.md import
  # of a superseded AGENTS.md (that import is the loop we're avoiding).
  python3 - <<'EOF_PY'
import re
a = open('AGENTS.md').read()
a2 = re.sub(r'\n*<!-- wallnote:start -->.*?<!-- wallnote:end -->\n*', '\n', a, flags=re.S).rstrip() + '\n'
if a2 != a: open('AGENTS.md', 'w').write(a2)
c = open('CLAUDE.md').read()
c2 = re.sub(r'(?m)^[ \t]*@AGENTS\.md[ \t]*\n?', '', c)
if c2 != c: open('CLAUDE.md', 'w').write(c2)
EOF_PY
  echo "note: AGENTS.md is marked superseded here, so the wallnote block lives in CLAUDE.md (old copy and @AGENTS.md import removed)."
fi

# Claude Code hooks: session start, each prompt, each finished task.
mkdir -p .claude
python3 - <<'EOF_PY'
import json, os
p = '.claude/settings.json'
s = json.load(open(p)) if os.path.exists(p) else {}
hooks = s.setdefault('hooks', {})
for event, arg, t in [('SessionStart', 'session', 15), ('UserPromptSubmit', 'prompt', 10), ('Stop', 'stop', 10)]:
    cmd = 'bash "$CLAUDE_PROJECT_DIR/.wallnote/wallnote" hook ' + arg
    groups = hooks.setdefault(event, [])
    for g in groups:  # drop older wallnote hooks, then add the current one
        g['hooks'] = [h for h in g.get('hooks', []) if '.wallnote/wallnote' not in h.get('command', '')]
    groups[:] = [g for g in groups if g['hooks']]
    groups.append({'hooks': [{'type': 'command', 'command': cmd, 'timeout': t}]})
json.dump(s, open(p, 'w'), indent=2)
open(p, 'a').write('\n')
EOF_PY

echo "wallnote installed. Commit and push these. Nobody else needs to set anything up: it turns on with safe defaults at each person's next agent session."
git status --short .wallnote .github/workflows/wallnote.yml AGENTS.md CLAUDE.md .claude/settings.json
