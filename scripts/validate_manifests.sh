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
require_file "metadata/16s_ena_run_manifest.tsv"
require_file "metadata/16s_ena_fastq_manifest.tsv"
require_file "resources/uv_resistance_signatures.tsv"
require_file "manifests/data_manifest.tsv"
require_file "manifests/code_manifest.tsv"
require_file "manuscript/upstream_software_provenance.tsv"
require_file "manuscript/upstream_repository_provenance.tsv"

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

printf '\nChecking delegated 16S input contract...\n'
Rscript tests/test_16s_handoff.R || failures=$((failures + 1))

printf '\nChecking Quarto analysis entrypoints...\n'
Rscript tests/test_quarto_entrypoints.R || failures=$((failures + 1))

printf '\nChecking manuscript bibliography...\n'
Rscript tests/test_references.R || failures=$((failures + 1))

printf '\nChecking manuscript structure and editorial boundaries...\n'
Rscript tests/test_manuscript_structure.R || failures=$((failures + 1))

printf '\nChecking upstream software provenance...\n'
Rscript tests/test_upstream_software_provenance.R || failures=$((failures + 1))

printf '\nChecking upstream repository provenance...\n'
Rscript tests/test_upstream_repository_provenance.R || failures=$((failures + 1))

printf '\nChecking journal review package...\n'
Rscript tests/test_journal_review_package.R || failures=$((failures + 1))

printf '\nChecking ISME submission-review manuscript...\n'
python3 scripts/build_isme_submission_review.py || failures=$((failures + 1))
Rscript tests/test_isme_submission_review.R || failures=$((failures + 1))

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
while IFS= read -r path; do
  if [[ "$path" == *[\*\?\[]* ]]; then
    if compgen -G "$path" > /dev/null; then
      printf 'OK available path pattern: %s\n' "$path"
    else
      printf 'MISSING available path pattern: %s\n' "$path" >&2
      failures=$((failures + 1))
    fi
  elif [[ -e "$path" ]]; then
    printf 'OK available path: %s\n' "$path"
  else
    printf 'MISSING available path: %s\n' "$path" >&2
    failures=$((failures + 1))
  fi
done < <(
  awk -F '\t' '
    NR == 1 { next }
    $2 == "available" { print $4 }
  ' manifests/data_manifest.tsv
)

printf '\nChecking HPC Conda-prefix policy...\n'
scratch_conda_pattern='(CONDA_PREFIX_DIR|--conda-prefix|conda create|mamba create).*scratch/users/snarayanasamy/phage_uv_treatment'
scratch_search_status=0
grep -R -n -E \
  --include='*.sh' --include='*.yml' --include='*.yaml' \
  -- "${scratch_conda_pattern}" launchers config || scratch_search_status=$?
if [[ "${scratch_search_status}" -eq 0 ]]; then
  printf 'PROHIBITED: Conda environment or prefix under project scratch.\n' >&2
  failures=$((failures + 1))
elif [[ "${scratch_search_status}" -eq 1 ]]; then
  printf 'OK: no project-scratch Conda prefixes in launchers or config\n'
else
  printf 'ERROR: unable to search launchers and config for project-scratch Conda prefixes.\n' >&2
  failures=$((failures + 1))
fi

expected_conda_prefix='CONDA_PREFIX_DIR="/work/projects/bioinformatics_platform/cache/conda"'
for launcher in \
  launchers/sbatch_mg_preprocessing.sh \
  launchers/sbatch_mt_preprocessing.sh
do
  if grep -Fqx "${expected_conda_prefix}" "${launcher}"; then
    printf 'OK shared Conda prefix: %s\n' "${launcher}"
  else
    printf 'INVALID shared Conda prefix: %s\n' "${launcher}" >&2
    failures=$((failures + 1))
  fi
done

notemp_search_status=0
grep -R -n -F -- '--notemp' launchers || notemp_search_status=$?
if [[ "${notemp_search_status}" -eq 0 ]]; then
  printf 'PROHIBITED: routine launcher disables Snakemake temp cleanup.\n' >&2
  failures=$((failures + 1))
elif [[ "${notemp_search_status}" -eq 1 ]]; then
  printf 'OK: Snakemake temp cleanup is not disabled\n'
else
  printf 'ERROR: unable to search launchers for disabled Snakemake temp cleanup.\n' >&2
  failures=$((failures + 1))
fi

if [[ "$failures" -ne 0 ]]; then
  printf '\nValidation failed with %s failure group(s).\n' "$failures" >&2
  exit 1
fi

printf '\nManifest smoke validation completed.\n'
