#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd "${script_dir}/.." && pwd)
cd "$repo_root"

temporary=$(mktemp -d "${TMPDIR:-/tmp}/phage-uv-static-checks.XXXXXX")
trap 'rm -rf "$temporary"' EXIT
before_status="${temporary}/git-status-before.txt"
after_status="${temporary}/git-status-after.txt"
git status --porcelain=v1 > "$before_status"

printf 'Checking shell syntax...\n'
while IFS= read -r shell_file; do
  bash -n "$shell_file"
done < <(find scripts launchers -type f -name '*.sh' -print | sort)

printf 'Checking Python syntax...\n'
export PYTHONPYCACHEPREFIX="${temporary}/pycache"
while IFS= read -r python_file; do
  python3 -m py_compile "$python_file"
done < <(find scripts hpc -type f -name '*.py' -print | sort)

printf 'Running data-independent R tests...\n'
for test_file in \
  tests/test_16s_handoff.R \
  tests/test_isme_submission_review.R \
  tests/test_journal_review_package.R \
  tests/test_manuscript_structure.R \
  tests/test_references.R \
  tests/test_upstream_repository_provenance.R \
  tests/test_upstream_software_provenance.R
do
  printf 'RUN %s\n' "$test_file"
  Rscript "$test_file"
done

printf 'Checking whitespace and generated-artifact hygiene...\n'
git diff --check
git status --porcelain=v1 > "$after_status"
if ! cmp -s "$before_status" "$after_status"; then
  printf 'Static checks changed the worktree:\n' >&2
  diff -u "$before_status" "$after_status" >&2 || true
  exit 1
fi

printf 'Repository static checks passed.\n'
