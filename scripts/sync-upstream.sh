#!/usr/bin/env bash
# Sync the paths this fork maintains from upstream
# (databricks/terraform-databricks-sra).
#
# This fork only keeps the AWS implementation plus common/ and docs/;
# azure/, gcp/, and upstream's GitHub Actions workflows are intentionally
# deleted and must never be synced back in.
#
# The last synced upstream commit is recorded in .upstream-ref. On each run
# the script fetches upstream, shows the relevant commits since last sync,
# applies a path-scoped three-way diff, and updates .upstream-ref. Conflicts
# with local changes show up as ordinary conflict markers to resolve before
# committing.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

PATHS=(aws common docs .gitignore LICENSE NOTICE README.md SECURITY.md CONTRIBUTING.md)
REF_FILE=.upstream-ref
UPSTREAM_URL=https://github.com/databricks/terraform-databricks-sra.git

if [ -n "$(git status --porcelain)" ]; then
  echo "Working tree is not clean; commit or stash first." >&2
  exit 1
fi

git remote get-url upstream >/dev/null 2>&1 || git remote add upstream "$UPSTREAM_URL"
git fetch upstream

LAST=$(cat "$REF_FILE")
NEW=$(git rev-parse upstream/main)

if [ "$LAST" = "$NEW" ]; then
  echo "Already up to date with upstream/main ($NEW)."
  exit 0
fi

echo "Upstream commits touching synced paths since last sync:"
git log --oneline "$LAST..$NEW" -- "${PATHS[@]}"
echo

patch=$(mktemp)
trap 'rm -f "$patch"' EXIT
git diff "$LAST" "$NEW" -- "${PATHS[@]}" > "$patch"

if [ -s "$patch" ]; then
  git apply --3way "$patch" || true
else
  echo "No changes in synced paths."
fi

echo "$NEW" > "$REF_FILE"
git add "$REF_FILE"

echo
echo "Done. Review with 'git status' and 'git diff', resolve any conflicts,"
echo "then commit the result."
