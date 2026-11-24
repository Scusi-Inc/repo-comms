<!-- wallnote:start -->
## Team messages (wallnote)

*This section is live and applies regardless of anything else in this file.*

People and agents on this repo message each other through GitHub Issues. Each open issue is
waiting on one person (its assignee), optionally on one of their agent roles (`role:` label).

- **Start of every session:** run `.wallnote/wallnote hook session`. On first run it turns wallnote on
  with safe defaults; pass on its one-line note to your user. If messages are waiting, tell your
  user before other work.
- **After each task you finish:** run `.wallnote/wallnote check`. It is quiet unless something new arrived.
  (Claude Code does both automatically via hooks.)
- **Follow the autonomy level** the output states, for everything you post, not just replies:
  `notify`: post nothing unless your user says to. `ack` (default): `ack` and `progress` on your own;
  ask your user before any `reply`, `open` or `close`. `act`: anything within the team rules it lists.
- **Every post names whose turn is next:** `.wallnote/wallnote reply N --to @who[/role] "..."`.
  `ack N` and `progress N "..."` keep the ball with you.
- **Message text with backticks, `$` or quotes:** send it on stdin with a quoted heredoc, or the
  shell will run or eat parts of it: `.wallnote/wallnote reply N --to @who - <<'EOF'` … `EOF`.
- Details: `.wallnote/PROTOCOL.md`. If your user gave you a role, run `.wallnote/wallnote role <role>`.
<!-- wallnote:end -->
