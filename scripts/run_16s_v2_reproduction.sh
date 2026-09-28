#!/usr/bin/env bash
# Reproduce the accepted 12-sample v1 result inside the isolated 16S_v2
# workspace, using the v1 notebooks unchanged and the EXECUTED v1 parameters
# pinned in config/16s_v2_paths.sh (279/200, pool = FALSE, nbases = 5e7,
# 150,000-pair seeded subsample before denoising).
#
#   bash scripts/run_16s_v2_reproduction.sh            # every step
#   bash scripts/run_16s_v2_reproduction.sh 4 5 6      # only these steps
#
# Differences from scripts/run_16s_pipeline.sh, both deliberate:
#   - step 3b (subsampling) is part of the reproduction, and step 4 denoises
#     the SUBSAMPLED reads, which is what the accepted run did;
#   - the environment is the rebuilt ~/mamba/envs/p16s_v2 prefix.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${repo_root}"
export PHAGE_UV_REPO_ROOT="${repo_root}"
# shellcheck source=config/16s_v2_paths.sh
source config/16s_v2_paths.sh

env_prefix="${PHAGE_UV_16S_V2_ENV:-${HOME}/mamba/envs/p16s_v2}"
if [[ ! -x "${env_prefix}/bin/Rscript" ]]; then
  printf 'Rebuilt environment not found at %s\n' "${env_prefix}" >&2
  exit 2
fi
export PATH="${env_prefix}/bin:${PATH}"
export LANG="${LANG:-en_US.UTF-8}"
mkdir -p "${PHAGE_UV_16S_V2_LOGS}"

run_step() {
  local number="$1"; shift
  local label="$1"; shift
  local log="${PHAGE_UV_16S_V2_LOGS}/reproduction_step${number}_$(date -u +%Y%m%dT%H%M%SZ).log"
  printf '\n=== Step %s: %s (log: %s) ===\n' "${number}" "${label}" "${log}"
  "$@" 2>&1 | tee "${log}"
}

step_0() { run_step 0 "environment and provenance" \
  bash scripts/run_qmd.sh scripts/check_16s_environment.qmd "${PHAGE_UV_16S_DERIVED}"; }
step_1() { run_step 1 "fetch reads and reference databases" bash -c '
  bash scripts/fetch_16s_ena_reads.sh metadata/16s_ena_fastq_manifest.tsv "${PHAGE_UV_16S_RAW_DIR}"
  bash scripts/fetch_16s_reference_databases.sh metadata/16s_reference_manifest.tsv "${PHAGE_UV_16S_REFERENCE_DIR}"'; }
step_2() { run_step 2 "primer removal" \
  bash scripts/trim_16s_primers.sh metadata/16s_ena_fastq_manifest.tsv "${PHAGE_UV_16S_RAW_DIR}" "${PHAGE_UV_16S_TRIMMED_DIR}"; }
step_3() { run_step 3 "quality profiles" \
  bash scripts/run_qmd.sh scripts/inspect_16s_quality_profiles.qmd "${PHAGE_UV_16S_TRIMMED_DIR}" "${PHAGE_UV_16S_QUALITY_DIR}"; }
step_3b() { run_step 3b "even-depth subsample (${PHAGE_UV_16S_SUBSAMPLE_DEPTH} pairs, seed ${PHAGE_UV_16S_SUBSAMPLE_SEED})" \
  bash scripts/subsample_16s_reads.sh "${PHAGE_UV_16S_TRIMMED_DIR}" "${PHAGE_UV_16S_SUBSAMPLED_DIR}" "${PHAGE_UV_16S_SUBSAMPLE_DEPTH}"; }
step_4() { run_step 4 "DADA2 denoising of the subsampled reads (${PHAGE_UV_16S_TRUNC_LEN_R1}/${PHAGE_UV_16S_TRUNC_LEN_R2}, pool=${PHAGE_UV_16S_POOL})" \
  bash scripts/run_qmd.sh scripts/run_16s_dada2.qmd "${PHAGE_UV_16S_SUBSAMPLED_DIR}" "${PHAGE_UV_16S_DADA2_DIR}" "${PHAGE_UV_16S_TRUNC_LEN_R1}" "${PHAGE_UV_16S_TRUNC_LEN_R2}"; }
step_5() { run_step 5 "taxonomy assignment (SILVA 138.2; GTDB cross-check=${PHAGE_UV_16S_GTDB_CROSSCHECK})" \
  bash scripts/run_qmd.sh scripts/assign_16s_taxonomy.qmd "${PHAGE_UV_16S_DADA2_DIR}" "${PHAGE_UV_16S_REFERENCE_DIR}" "${PHAGE_UV_16S_TAXONOMY_DIR}"; }
step_6() { run_step 6 "phyloseq assembly" \
  bash scripts/run_qmd.sh scripts/build_16s_phyloseq.qmd "${PHAGE_UV_16S_DADA2_DIR}" "${PHAGE_UV_16S_TAXONOMY_DIR}" "${PHAGE_UV_16S_PHYLOSEQ_DIR}" metadata/sample_metadata.tsv; }
step_7() { run_step 7 "community ecology" \
  bash scripts/run_qmd.sh scripts/analyse_16s_community_ecology.qmd "${PHAGE_UV_16S_PHYLOSEQ_DIR}" "${PHAGE_UV_16S_ECOLOGY_DIR}"; }
step_9() { run_step 9 "candidate figures" \
  bash scripts/run_qmd.sh scripts/build_16s_candidate_figures.qmd "${PHAGE_UV_16S_ECOLOGY_DIR}" "${PHAGE_UV_16S_FIGURE_DIR}"; }

step_cmp() { run_step cmp "reproduction versus accepted v1 return" \
  bash scripts/run_qmd.sh scripts/compare_16s_v2_reproduction.qmd "${PHAGE_UV_16S_V2_INPUTS}/v1_return_2026-09-03" \
    "${PHAGE_UV_16S_DERIVED}" "${PHAGE_UV_16S_DERIVED}/13_reproduction_comparison"; }

# Earlier-cohort steps (v2-only; separate cohort, never merged into the
# 12-sample reproduction above).
step_e1() { run_step e1 "fetch earlier U+B40 reads" \
  bash scripts/fetch_16s_ena_reads.sh metadata/16s_v2_earlier_cohort_fastq_manifest.tsv "${PHAGE_UV_16S_V2_INPUTS}/earlier_cohort_raw_reads"; }
step_e2() { run_step e2 "earlier-cohort 515F removal and subsample" \
  bash scripts/trim_16s_v2_earlier_cohort.sh metadata/16s_v2_earlier_cohort_fastq_manifest.tsv \
    "${PHAGE_UV_16S_V2_INPUTS}/earlier_cohort_raw_reads" "${PHAGE_UV_16S_DERIVED}/11_earlier_cohort_primer_removal" "${PHAGE_UV_16S_SUBSAMPLE_DEPTH}"; }
step_cr() { run_step cr "common-region cross-cohort comparison" \
  bash scripts/run_qmd.sh scripts/run_16s_v2_common_region.qmd "${PHAGE_UV_16S_SUBSAMPLED_DIR}" \
    "${PHAGE_UV_16S_DERIVED}/11_earlier_cohort_primer_removal" "${PHAGE_UV_16S_REFERENCE_DIR}" \
    "${PHAGE_UV_16S_DERIVED}/12_common_region" "${PHAGE_UV_16S_V2_COMMON_TRUNC_LEN:-250}"; }

requested=("$@")
if [[ ${#requested[@]} -eq 0 ]]; then
  requested=(0 1 2 3 3b 4 5 6 7 9 cmp e1 e2 cr)
fi
for step in "${requested[@]}"; do
  if ! declare -F "step_${step}" >/dev/null; then
    printf 'Unknown step: %s\n' "${step}" >&2
    exit 2
  fi
  "step_${step}"
done
printf '\nRequested reproduction steps complete.\n'
