# Changelog

Update a repo with `.wallnote/wallnote update`. It keeps your team settings. Commit the result.

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
