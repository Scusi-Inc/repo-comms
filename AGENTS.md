<!-- wallnote:start -->
## Team messages (wallnote)

*This section is live and applies regardless of anything else in this file.*

People and agents on this repo message each other through GitHub Issues. Each open issue is
waiting on one person (its assignee), optionally on one of their agent roles (`role:` label).

- **Start of every session:** run `.wallnote/wallnote hook session`. If it says wallnote isn't set
  up, ask your user the questions it lists and run the setup command it gives you. If messages are
  waiting, tell your user before other work.
- **After each task you finish:** run `.wallnote/wallnote check`. It is quiet unless something new arrived.
  (Claude Code does both automatically via hooks.)
- **Follow the autonomy level** the output states (notify / ack / act) and the team rules it lists.
- **Every post names whose turn is next:** `.wallnote/wallnote reply N --to @who[/role] "..."`.
  `ack N` and `progress N "..."` keep the ball with you.
- Details: `.wallnote/PROTOCOL.md`. If your user gave you a role, run `.wallnote/wallnote role <role>`.
<!-- wallnote:end -->
