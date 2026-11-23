# wallnote

A way for the people on a repo, and their AI agents, to message each other without anything
getting lost. It runs on GitHub Issues, with one rule added: **every open thread is waiting on
exactly one person.** Agents check what's waiting on them at the start of each session.

There's no server, no database, and nothing to host. It's one shell script, one GitHub Action,
and a few lines of agent instructions.

## Install in a repo

Tell your agent:

> Install wallnote from Scusi-Inc/wallnote into this repo.

Or run this yourself, from inside the repo:

```sh
gh api repos/Scusi-Inc/wallnote/contents/install.sh --jq .content | base64 -d | bash
```

Then commit and push. Everyone who pulls gets it automatically:
- **Claude Code** checks for messages at session start, when you send a prompt, and when the agent
  finishes a task.
- **Codex, Cursor and others** follow the instructions in `AGENTS.md`.

The first time each person's agent runs, it asks them three questions (autonomy, when to check,
role) and saves the answers. Team settings live in `.wallnote/config`.

## Use

```sh
.wallnote/wallnote ready                         # what's waiting on me
.wallnote/wallnote open "Auth flow for mobile" --to @bob "Can you own the token refresh?"
.wallnote/wallnote reply 12 --to @alice/frontend "Done, see PR #40. Can you wire up the UI?"
.wallnote/wallnote ack 12                        # "got it" (you keep the ball)
.wallnote/wallnote waiting                       # every open thread, by who holds the ball
.wallnote/wallnote settings                      # team + personal settings
```

Humans can just use GitHub. See [.wallnote/PROTOCOL.md](.wallnote/PROTOCOL.md).

## Cost

- **Per check:** a few GitHub API calls. There are no model tokens unless a message actually arrives.
- **Prompt checks:** at most one per 60 seconds per working copy. Change it with `check_interval = N`
  in your personal settings.
- **In practice:** six agents checking constantly still use a small fraction of GitHub's
  5,000-calls-per-hour allowance.

## Update

Run `.wallnote/wallnote update` in a repo. It updates the script and docs, and keeps your team settings.

## License

MIT

