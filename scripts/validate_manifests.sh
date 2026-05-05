#!/usr/bin/env bash
set -euo pipefail

failures=0

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    printf 'MISSING: %s\n' "$path" >&2
    failures=$((failures + 1))
  else
    printf 'OK: %s\n' "$path"
  fi
}

require_file "metadata/sample_metadata.tsv"
require_file "resources/uv_resistance_signatures.tsv"
require_file "manifests/data_manifest.tsv"
require_file "manifests/code_manifest.tsv"

printf '\nChecking sample metadata grouping...\n'
awk -F '\t' '
  NR == 1 { next }
  /^[[:space:]]*$/ { next }
  { rows++ }
  NF < 15 { bad_rows++; print "Bad sample_metadata row fields:", NR > "/dev/stderr" }
  $2 !~ /^(control|treatment)$/ { bad_condition++; print "Bad condition:", NR, $2 > "/dev/stderr" }
  $3 !~ /^(initial|backflush)$/ { bad_phase++; print "Bad phase:", NR, $3 > "/dev/stderr" }
  $4 !~ /^[123]$/ { bad_cycle++; print "Bad cycle:", NR, $4 > "/dev/stderr" }
  $5 != $2 "_cycle" $4 { bad_group++; print "Bad analysis_group:", NR, $5 > "/dev/stderr" }
  END {
    print "sample_rows=" rows
    if (bad_rows + bad_condition + bad_phase + bad_cycle + bad_group > 0) exit 1
  }
' metadata/sample_metadata.tsv || failures=$((failures + 1))

printf '\nChecking UV signature table...\n'
awk -F '\t' '
  NR == 1 { next }
  /^[[:space:]]*$/ { next }
  { rows++ }
  NF < 7 { bad_rows++; print "Bad uv_signature row fields:", NR > "/dev/stderr" }
  $1 !~ /^[123]$/ { bad_tier++; print "Bad UV tier:", NR, $1 > "/dev/stderr" }
  END {
    print "uv_signature_rows=" rows
    if (bad_rows + bad_tier > 0) exit 1
  }
' resources/uv_resistance_signatures.tsv || failures=$((failures + 1))

printf '\nChecking available manifest paths...\n'
awk -F '\t' '
  NR == 1 { next }
  $2 == "available" { print $4 }
' manifests/data_manifest.tsv | while IFS= read -r path; do
  [[ -f "$path" ]] && printf 'OK available path: %s\n' "$path" || printf 'MISSING available path: %s\n' "$path" >&2
done

if [[ "$failures" -ne 0 ]]; then
  printf '\nValidation failed with %s failure group(s).\n' "$failures" >&2
  exit 1
fi

printf '\nManifest smoke validation completed.\n'
