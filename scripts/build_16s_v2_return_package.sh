#!/usr/bin/env bash
# Assemble the checksum-addressed 16S_v2 return package from the v2 results
# tree. Copies (never moves) the deliverables listed in the return contract
# into 09_return_package/ and writes an MD5 manifest.
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${repo_root}"
export PHAGE_UV_REPO_ROOT="${repo_root}"
# shellcheck source=config/16s_v2_paths.sh
source config/16s_v2_paths.sh
src="${PHAGE_UV_16S_DERIVED}"
dst="${PHAGE_UV_16S_RETURN_DIR}"
rm -rf "${dst}"
mkdir -p "${dst}"

copy_dir() {  # copy_dir <source subdir> <package subdir> [glob...]
  local from="${src}/$1" to="${dst}/$2"; shift 2
  mkdir -p "${to}"
  for pattern in "$@"; do
    for f in "${from}"/${pattern}; do [[ -f "$f" ]] && cp -p "$f" "${to}/"; done
  done
}
# 1. Reproduction of the accepted 12-sample result and its comparison to v1.
copy_dir 03_dada2 reproduction/03_dada2 '*.tsv' '*.pdf'
copy_dir 04_taxonomy reproduction/04_taxonomy '*.tsv'
copy_dir 05_phyloseq reproduction/05_phyloseq '*.tsv' '*.fasta' '*.rds'
copy_dir 06_ecology reproduction/06_ecology '*.tsv'
copy_dir 08_figures reproduction/08_figures '*.pdf' '*.tsv'
copy_dir 13_reproduction_comparison reproduction/13_reproduction_comparison '*.tsv'
cp -p "${src}/16s_software_provenance.tsv" "${dst}/reproduction/" 2>/dev/null || true
# 2. Cycle models on the accepted table.
copy_dir 10_cycle_models cycle_models '*.tsv' '*.pdf'
# 3. Earlier cohort and common-region comparison.
copy_dir 11_earlier_cohort_primer_removal earlier_cohort '*.tsv'
copy_dir 12_common_region common_region '*.tsv' '*.pdf' '*.fasta' '*.rds'
# 4. Protected-location evidence and input checksums.
mkdir -p "${dst}/isolation_evidence"
cp -p "${PHAGE_UV_16S_V2_REPORTS}"/protected_v1_inventory_*.tsv "${dst}/isolation_evidence/"
cp -p "${PHAGE_UV_16S_V2_INPUTS}/v1_return_2026-09-03_input_checksums.tsv" "${dst}/isolation_evidence/"
(cd "${PHAGE_UV_16S_RAW_DIR}" && for f in *.fastq.gz; do printf '%s\t%s\t%s\n' "$f" "$(stat -f %z "$f")" "$(md5 -q "$f")"; done) \
  | { printf 'file\tbytes\tmd5\n'; cat; } > "${dst}/isolation_evidence/raw_reads_current_cohort_checksums.tsv"
(cd "${PHAGE_UV_16S_V2_INPUTS}/earlier_cohort_raw_reads" && for f in *.fastq.gz; do printf '%s\t%s\t%s\n' "$f" "$(stat -f %z "$f")" "$(md5 -q "$f")"; done) \
  | { printf 'file\tbytes\tmd5\n'; cat; } > "${dst}/isolation_evidence/raw_reads_earlier_cohort_checksums.tsv"
(cd "${PHAGE_UV_16S_REFERENCE_DIR}" && for f in *.gz; do printf '%s\t%s\t%s\n' "$f" "$(stat -f %z "$f")" "$(md5 -q "$f")"; done) \
  | { printf 'file\tbytes\tmd5\n'; cat; } > "${dst}/isolation_evidence/reference_database_checksums.tsv"
# 5. Code provenance.
mkdir -p "${dst}/code"
git -C "${repo_root}" log --format='%H%x09%ad%x09%s' --date=iso b6acbe5..HEAD > "${dst}/code/v2_branch_commits.tsv"
git -C "${repo_root}" rev-parse HEAD > "${dst}/code/v2_head_commit.txt"
micromamba list -p "${PHAGE_UV_16S_V2_ENV:-${HOME}/mamba/envs/p16s_v2}" --json > "${dst}/code/p16s_v2_environment.json" 2>/dev/null || true
Rscript -e 'cat(sprintf("%s\t%s\n", c("R","DESeq2","edgeR","ggplot2"), c(paste(R.version$major, R.version$minor, sep="."), as.character(packageVersion("DESeq2")), as.character(packageVersion("edgeR")), as.character(packageVersion("ggplot2")))), sep="")' > "${dst}/code/system_r_cycle_model_versions.tsv"
# Manifest.
(cd "${dst}" && find . -type f ! -name 16s_v2_return_package_manifest.tsv | sort | while read -r f; do
  printf '%s\t%s\t%s\n' "${f#./}" "$(stat -f %z "$f")" "$(md5 -q "$f")"; done) \
  | { printf 'file\tbytes\tmd5\n'; cat; } > "${dst}/16s_v2_return_package_manifest.tsv"
printf 'Return package: %s (%s files)\n' "${dst}" "$(($(wc -l < "${dst}/16s_v2_return_package_manifest.tsv") - 1))"
