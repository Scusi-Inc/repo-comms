#!/usr/bin/env bash
# Count public repos that have wallnote installed (GitHub code search; private repos are invisible).
#   bash scripts/installs.sh
set -euo pipefail
gh api -X GET search/code -f q='path:.wallnote filename:PROTOCOL.md' \
  --jq '[.items[].repository.full_name | select(. != "Scusi-Inc/wallnote")] | unique | "\(length) public install(s)", .[]'
