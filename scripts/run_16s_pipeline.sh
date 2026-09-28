#!/usr/bin/env bash
# Ordered driver for the delegated 16S workstream.
#
#   source config/16s_analysis_paths.sh
#   bash scripts/run_16s_pipeline.sh            # every step
#   bash scripts/run_16s_pipeline.sh 4 5 6      # only these steps
#
# Steps are idempotent at the file level but not cheap. Step 4 is the long one.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${repo_root}"

if [[ -z "${PHAGE_UV_16S_DERIVED:-}" ]]; then
  # shellcheck source=/dev/null
  source config/16s_analysis_paths.sh
fi

run_step() {
  local number="$1"; shift
  local label="$1"; shift
  printf '\n=== Step %s: %s ===\n' "${number}" "${label}"
  "$@"
}

step_0() { run_step 0 "environment and provenance" \
  bash scripts/run_qmd.sh scripts/check_16s_environment.qmd "${PHAGE_UV_16S_DERIVED}"; }
step_1() { run_step 1 "fetch reads and reference databases" bash -c '
  bash scripts/fetch_16s_ena_reads.sh metadata/16s_ena_fastq_manifest.tsv "${PHAGE_UV_16S_RAW_DIR}"
  bash scripts/fetch_16s_reference_databases.sh metadata/16s_reference_manifest.tsv "${PHAGE_UV_16S_REFERENCE_DIR}"'; }
step_2() { run_step 2 "primer removal" \
  bash scripts/trim_16s_primers.sh metadata/16s_ena_fastq_manifest.tsv "${PHAGE_UV_16S_RAW_DIR}" "${PHAGE_UV_16S_TRIMMED_DIR}"; }
step_3() { run_step 3 "quality profiles and truncation planning" \
  bash scripts/run_qmd.sh scripts/inspect_16s_quality_profiles.qmd "${PHAGE_UV_16S_TRIMMED_DIR}" "${PHAGE_UV_16S_QUALITY_DIR}"; }
step_4() { run_step 4 "DADA2 denoising" \
  bash scripts/run_qmd.sh scripts/run_16s_dada2.qmd "${PHAGE_UV_16S_TRIMMED_DIR}" "${PHAGE_UV_16S_DADA2_DIR}" "${PHAGE_UV_16S_TRUNC_LEN_R1}" "${PHAGE_UV_16S_TRUNC_LEN_R2}"; }
step_5() { run_step 5 "taxonomy assignment" \
  bash scripts/run_qmd.sh scripts/assign_16s_taxonomy.qmd "${PHAGE_UV_16S_DADA2_DIR}" "${PHAGE_UV_16S_REFERENCE_DIR}" "${PHAGE_UV_16S_TAXONOMY_DIR}"; }
step_6() { run_step 6 "phyloseq assembly" \
  bash scripts/run_qmd.sh scripts/build_16s_phyloseq.qmd "${PHAGE_UV_16S_DADA2_DIR}" "${PHAGE_UV_16S_TAXONOMY_DIR}" "${PHAGE_UV_16S_PHYLOSEQ_DIR}" metadata/sample_metadata.tsv; }
step_7() { run_step 7 "community ecology" \
  bash scripts/run_qmd.sh scripts/analyse_16s_community_ecology.qmd "${PHAGE_UV_16S_PHYLOSEQ_DIR}" "${PHAGE_UV_16S_ECOLOGY_DIR}"; }
step_8() { run_step 8 "optional exploratory differential abundance" \
  bash scripts/run_qmd.sh scripts/run_16s_exploratory_differential_abundance.qmd "${PHAGE_UV_16S_PHYLOSEQ_DIR}" "${PHAGE_UV_16S_DA_DIR}"; }
step_9() { run_step 9 "candidate figures" \
  bash scripts/run_qmd.sh scripts/build_16s_candidate_figures.qmd "${PHAGE_UV_16S_ECOLOGY_DIR}" "${PHAGE_UV_16S_FIGURE_DIR}"; }
step_10() { run_step 10 "return package" \
  bash scripts/run_qmd.sh scripts/build_16s_return_package.qmd "${PHAGE_UV_16S_DERIVED}" "${PHAGE_UV_16S_RETURN_DIR}"; }

requested=("$@")
if [[ ${#requested[@]} -eq 0 ]]; then
  requested=(0 1 2 3 4 5 6 7 8 9 10)
fi

for step in "${requested[@]}"; do
  if ! declare -F "step_${step}" >/dev/null; then
    printf 'Unknown step: %s\n' "${step}" >&2
    exit 2
  fi
  "step_${step}"
done

printf '\nRequested steps complete.\n'
