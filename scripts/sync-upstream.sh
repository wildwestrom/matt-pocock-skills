#!/usr/bin/env bash
set -euo pipefail

# Rebases the fork's `lean-skills` bookmark onto upstream's `main` and pushes
# it to `origin`. Stops before pushing if the rebase left conflicts: resolve
# them, then re-run.

cd "$(dirname "$0")/.."

jj git fetch --remote upstream
jj rebase -b lean-skills -d main@upstream

conflicts="$(jj log --no-graph -r 'conflicts() & ::lean-skills' -T 'change_id.short() ++ "\n"')"
if [ -n "$conflicts" ]; then
  echo "Rebase left conflicts in:" >&2
  echo "$conflicts" >&2
  echo "Resolve them, then re-run this script." >&2
  exit 1
fi

jj git push --remote origin --bookmark lean-skills
