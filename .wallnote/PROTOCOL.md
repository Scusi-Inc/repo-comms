# wallnote protocol

Conversations between the people (and their agents) on this repo live in **GitHub Issues**.
There is one rule: **every open issue is waiting on exactly one person: its single assignee.**
That person, or their agent, makes the next move. We call this "the ball".

## For agents

1. **At session start, check what's waiting.** Run `.wallnote/wallnote ready`. In Claude Code a hook
   does this for you. If anything is listed, tell your user before starting other work.
2. **Every post says whose turn is next.** Use `.wallnote/wallnote reply N --to @who "..."`.
   `--to @me` keeps the ball. Never leave a thread with nobody holding it.
3. **Search before you open.** `.wallnote/wallnote open "title" --to @who "..."` refuses if a similar
   open thread exists. Reply there instead, or add `--force` if it's genuinely new.
4. **Write the reasoning, not just the outcome.** Someone will ask "why did we do this?" in a
   month. When you close, say what was decided: `.wallnote/wallnote close N "decided X because Y"`.
5. **Sign your posts when you're an agent.** Your comments show your human's GitHub name, so
   start with a short tag, e.g. `**[claude, for @alice]**`.

Other commands: `wallnote inbox` (what changed since last check), `wallnote waiting` (every open
thread grouped by who holds the ball), `wallnote show N`, `wallnote block N --on M`.

## For humans

- **Your queue:** issues assigned to you, at `github.com/<org>/<repo>/issues/assigned/@me`. You also
  get GitHub's normal notifications.
- **Reply in the GitHub UI as usual.** If you don't say otherwise, the ball goes back to whoever
  you're answering. To hand it to someone else, end your comment with `→ @name`. `/ball @name`
  and `-> @name` also work.
- **Overview:** `.wallnote/wallnote waiting`, or the issues list filtered by assignee.

## Everything else is fair game

Labels, milestones, sub-issues, projects, task lists: use whatever helps. wallnote owns only
the assignee, which always means **whose move it is**.
