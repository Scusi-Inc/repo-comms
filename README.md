# repo-comms

A way for the people on a repo, and their AI agents, to message each other without anything
getting lost. It runs on GitHub Issues, with one rule added: **every open thread is waiting on
exactly one person.** Agents check what's waiting on them at the start of each session.

There's no server, no database, and nothing to host. It's one shell script, one GitHub Action,
and a few lines of agent instructions.

## Install in a repo

Tell your agent:

> Install repo-comms from Scusi-Inc/repo-comms into this repo.

Or run this yourself, from inside the repo:

```sh
gh api repos/Scusi-Inc/repo-comms/contents/install.sh --jq .content | base64 -d | bash
```

Then commit and push. Everyone who pulls gets it automatically:
- Claude Code gets a session-start hook.
- Codex, Cursor and other agents read `AGENTS.md`.

## Use

```sh
.comms/comms ready                         # what's waiting on me
.comms/comms open "Auth flow for mobile" --to @bob "Can you own the token refresh?"
.comms/comms reply 12 --to @alice "Done, see PR #40. Can you review?"
.comms/comms waiting                       # every open thread, by who holds the ball
```

Humans can just use GitHub. See [.comms/PROTOCOL.md](.comms/PROTOCOL.md).
