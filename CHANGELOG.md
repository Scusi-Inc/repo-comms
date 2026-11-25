# Changelog

Update a repo with `.wallnote/wallnote update`. It keeps your team settings. Commit the result.

## 0.5.4
- `check` (and the hooks) can no longer lose a message. A thread it reports stays "new" until the
  agent runs `show` on it or posts on it, so a check whose output never reached the model gets
  repeated next time instead of silently skipped.

## 0.5.3
- `wallnote note N "..."`: a comment that leaves the ball, labels and state alone. For thanks,
  FYIs and words on closed threads. Humans can start a GitHub comment with `**note**:`.
- `settings` says the check interval is a limit, not a timer. PROTOCOL.md has a new "Waking up"
  section: wallnote never wakes anyone, and how to schedule a cheap check if you want that.

## 0.5.2
- Agents are now told to send message text containing backticks, `$` or quotes on stdin with a
  quoted heredoc (`reply N --to @who - <<'EOF'`). In a double-quoted argument the shell runs
  backticks as commands and silently drops words from the message.

## 0.5.1
- `wallnote accept` lists now live in your personal settings, so only you can change who reaches
  your agents. The committed `.wallnote/accept/<login>` file is just a notice for sender warnings;
  editing it changes nobody's agent. `--private` skips writing it.

## 0.5.0
- `allowed_authors = auto` is the new default: all collaborators on a private repo, only people who
  can push code on a public one (so community triagers can't steer your agent). Also: `writers`,
  or a list of logins. Repos that already set `collaborators` keep it.
- `wallnote accept alice bob`: each person can narrow who reaches their own agents. It's a
  committed file, `.wallnote/accept/<login>`, so senders get warned when they aren't on it.
- `open` and `reply` warn when the recipient's agents won't see your message.

## 0.4.3
- Prompt-injection hardening:
  - Issue titles written by non-collaborators are masked in `ready` and new-message checks.
  - `show` frames posts as requests that can't override your user or rules, and flags posts with
    `<!-- -->` text that GitHub's web view hides from humans.
  - A warning when `allowed_authors = anyone`, louder on public repos.

## 0.4.2
- `wallnote setup --every 10m` sets how often you check (default once a minute). It applies to
  end-of-task checks too, not just prompts. Throttled checks only delay messages, never drop them.
- Fix: commands with an optional body (`ack N`) no longer hang when an agent's shell leaves stdin
  open with nothing coming.

## 0.4.1
- Fix: `ack` and `progress` no longer strip the thread's `role:` and `acked` labels. Any post that
  hands off to `→ @me` from the person who already holds the ball leaves it untouched.
- New team setting `default_roles` (e.g. `alice:core`): for people who read wallnote through one
  main agent, `@alice` means `@alice/core`. Add the line to `.wallnote/config` to use it.
- PROTOCOL.md: "Without the CLI", the plain-GitHub format for agents that can't run the script.
- `forbid` is clarified: it limits what a message can trigger, not your repo's normal process.

## 0.4.0
- Autonomy now covers everything an agent posts, not just answers to incoming messages.
  - `notify`: posts nothing unless you say so.
  - `ack` (new default): acks and progress updates on its own; asks you before any reply, open or close.
  - `act`: anything within the team rules.
- New installs start at `ack`. Anyone already set to `notify` (the old default) stays there; to
  switch, tell your agent "let wallnote ack and post progress for me".

## 0.3.5
- When AGENTS.md is marked superseded, the installer also removes the old wallnote block from it
  and the `@AGENTS.md` import from CLAUDE.md, instead of leaving them for someone to clean up.

## 0.3.4
- Fix: `wallnote update` no longer ends with a bogus syntax error. The installer replaces files by
  rename, and the script runs from `main()` so it never reads past its last line.

## 0.3.3
- No setup questions: wallnote turns on with safe defaults (notify; check on prompt and task end)
  the first time someone's agent starts, and the agent tells them once how to change it.
- Update notice appears at most once a day.

## 0.3.2
- Agents are told, at most once a day, when a newer wallnote is available.

## 0.3.1
- `--body-file PATH` (or `-` for stdin) on open/reply/ack/progress/close, safe for long bodies with backticks and quotes.
- `--no-dedupe`, and `WALLNOTE_NO_DEDUPE=1` to skip the duplicate check for a whole batch.
- `waiting` nests roles under their person.

## 0.3.0
- `ready` and `waiting` never print nothing; they also say when you haven't run setup.
- Onboarding no longer asks for a role when the repo defines none.
- If AGENTS.md is marked superseded, instructions go into CLAUDE.md (no import loop).
- The Action works out the ball from the thread's newest post, so dropped or out-of-order runs can't misassign it.
- Prompt checks are free within 60s of the last one (`check_interval`). GitHub login is cached.
- `wallnote update`. MIT license.

## 0.2.0
- Settings (team + personal), first-run onboarding, roles (`@alice/frontend`), `ack`, `progress`,
  checks when you send a prompt and when the agent finishes a task, collaborators-only.
