#!/usr/bin/env bash
set -euo pipefail

if [[ "$#" -ne 2 ]]; then
  printf 'Usage: %s <approved-inventory.tsv> <output-manifest.tsv>\n' "$0" >&2
  exit 64
fi

inventory=$1
output=$2

if [[ ! -f "$inventory" ]]; then
  printf 'Inventory does not exist: %s\n' "$inventory" >&2
  exit 66
fi
if [[ -e "$output" ]]; then
  printf 'Refusing to overwrite existing output: %s\n' "$output" >&2
  exit 73
fi

expected_header=$'role\tsource_path\tsubmission_name\tapproval_status'
header=$(sed -n '1p' "$inventory")
if [[ "$header" != "$expected_header" ]]; then
  printf 'Invalid inventory header. Expected: %s\n' "$expected_header" >&2
  exit 65
fi

if awk -F '\t' '
  NR == 1 { next }
  NF != 4 || $1 == "" || $2 == "" || $3 == "" || $4 == "" { exit 1 }
  $4 != "approved_by_corresponding_author" { exit 1 }
  index($3, "/") || index($3, "\\") { exit 1 }
  seen[$3]++ { exit 1 }
  END { if (NR < 2) exit 1 }
' "$inventory"; then
  :
else
  printf 'Inventory is malformed, contains duplicate/unsafe names, or has an unapproved item.\n' >&2
  exit 65
fi

while IFS=$'\t' read -r role source_path submission_name approval_status; do
  if [[ "$role" == "role" ]]; then
    continue
  fi
  if [[ ! -f "$source_path" ]]; then
    printf 'Approved source file does not exist: %s\n' "$source_path" >&2
    exit 66
  fi
done < "$inventory"

repo_commit=$(git rev-parse HEAD)
generated_at=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
output_dir=$(dirname "$output")
mkdir -p "$output_dir"
temporary=$(mktemp "${output_dir}/.submission-release-manifest.XXXXXX")
trap 'rm -f "$temporary"' EXIT

printf 'role\tsubmission_name\tsource_path\tfile_size_bytes\tsha256\trepository_commit\tgenerated_at_utc\n' > "$temporary"
while IFS=$'\t' read -r role source_path submission_name approval_status; do
  if [[ "$role" == "role" ]]; then
    continue
  fi
  size=$(wc -c < "$source_path" | tr -d '[:space:]')
  checksum=$(shasum -a 256 "$source_path" | awk '{print $1}')
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$role" "$submission_name" "$source_path" "$size" "$checksum" \
    "$repo_commit" "$generated_at" >> "$temporary"
done < "$inventory"

mv "$temporary" "$output"
trap - EXIT
printf 'Submission release manifest written: %s\n' "$output"
