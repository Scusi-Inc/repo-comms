# Changelog

Update a repo with `.wallnote/wallnote update`. It keeps your team settings. Commit the result.

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
