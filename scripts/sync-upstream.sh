#!/usr/bin/env bash
# Sync the paths this fork maintains from upstream
# (databricks/terraform-databricks-sra).
#
# This fork only keeps the AWS implementation plus `common`.
#
# `azure`, `gcp`, `docs`, and upstream's GitHub Actions workflows are
# intentionally deleted and must never be synced back in.
#
# The last synced upstream commit is recorded in .upstream-ref. On each run
# the script fetches upstream, shows the relevant commits since last sync,
# applies a path-scoped three-way diff, and updates .upstream-ref. Conflicts
# with local changes show up as ordinary conflict markers to resolve before
# committing.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

PATHS=(aws common .gitignore LICENSE NOTICE README.md SECURITY.md CONTRIBUTING.md)
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
# `--binary` is required: without it `git apply` cannot apply changes to binary
# files (e.g. the images under `aws/img`) and rejects the patch as a whole.
git diff --binary "$LAST" "$NEW" -- "${PATHS[@]}" > "$patch"

if [ -s "$patch" ]; then
  if ! git apply --3way "$patch"; then
    # `git apply` exits non-zero both when it leaves conflict markers and when
    # it rejects the patch. A rejected patch is not applied at all, so the tree
    # is still clean; stop without recording the new ref, or the fork would
    # claim to be in sync with changes it never received.
    if [ -z "$(git status --porcelain)" ]; then
      echo "git apply rejected the patch (see errors above); nothing was applied" >&2
      echo "and $REF_FILE is unchanged." >&2
      exit 1
    fi
  fi
else
  echo "No changes in synced paths."
fi

echo "$NEW" > "$REF_FILE"
git add "$REF_FILE"

echo
echo "Done. Review with 'git status' and 'git diff', resolve any conflicts,"
echo "then commit the result."
