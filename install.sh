#!/usr/bin/env bash
# Install wallnote into the current git repo. Needs: git, gh (logged in).
#   gh api repos/Scusi-Inc/wallnote/contents/install.sh --jq .content | base64 -d | bash
set -euo pipefail
SRC=${WALLNOTE_SRC:-Scusi-Inc/wallnote}
REF=${WALLNOTE_REF:-main}
root=$(git rev-parse --show-toplevel) || { echo "run inside a git repo" >&2; exit 1; }
gh api "repos/$SRC" --jq .full_name >/dev/null 2>&1 || { echo "wallnote: no access to $SRC — ask to be added to it" >&2; exit 1; }
cd "$root"

fetch() { # src-path dest-path
  mkdir -p "$(dirname "$2")"
  gh api "repos/$SRC/contents/$1?ref=$REF" --jq .content | base64 -d > "$2"
}

fetch .wallnote/wallnote .wallnote/wallnote && chmod +x .wallnote/wallnote
fetch .wallnote/PROTOCOL.md .wallnote/PROTOCOL.md
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
concurrency:
  group: wallnote-${{ github.event.issue.number }}
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

# AGENTS.md: replace our block if present, else append.
block=$(gh api "repos/$SRC/contents/AGENTS.md?ref=$REF" --jq .content | base64 -d)
if [[ -f AGENTS.md ]] && grep -q 'wallnote:start' AGENTS.md; then
  python3 - "$block" <<'PY'
import re,sys
p='AGENTS.md'; s=open(p).read()
s=re.sub(r'<!-- wallnote:start -->.*?<!-- wallnote:end -->', sys.argv[1].strip(), s, flags=re.S)
open(p,'w').write(s)
PY
else
  { [[ -f AGENTS.md ]] && echo; echo "$block"; } >> AGENTS.md
fi

# CLAUDE.md: make Claude Code read AGENTS.md.
if [[ ! -f CLAUDE.md ]]; then echo "@AGENTS.md" > CLAUDE.md
elif ! grep -q '@AGENTS.md' CLAUDE.md; then printf '\n@AGENTS.md\n' >> CLAUDE.md; fi

# Claude Code session-start hook.
hook='bash "$CLAUDE_PROJECT_DIR/.wallnote/wallnote" hook'
mkdir -p .claude
python3 - "$hook" <<'PY'
import json,os,sys
p='.claude/settings.json'; hook=sys.argv[1]
s=json.load(open(p)) if os.path.exists(p) else {}
ss=s.setdefault('hooks',{}).setdefault('SessionStart',[])
if not any(h.get('command')==hook for g in ss for h in g.get('hooks',[])):
    ss.append({'hooks':[{'type':'command','command':hook,'timeout':15}]})
json.dump(s,open(p,'w'),indent=2); open(p,'a').write('\n')
PY

echo "wallnote installed. Commit these and push:"
git status --short .wallnote .github/workflows/wallnote.yml AGENTS.md CLAUDE.md .claude/settings.json
