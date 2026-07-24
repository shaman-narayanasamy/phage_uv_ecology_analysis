#!/usr/bin/env bash
#SBATCH --job-name=instrain_priority20_smoke
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/community_uv_response/variant_analysis/logs/instrain_priority20_smoke_%j.out
#SBATCH --error=/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/community_uv_response/variant_analysis/logs/instrain_priority20_smoke_%j.err

set -euo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-/scratch/users/snarayanasamy/phage_uv_treatment}"
RUN_ROOT="${RUN_ROOT:-${PROJECT_ROOT}/output/PRJEB79569/community_uv_response/variant_analysis}"
OUT_ROOT="${OUT_ROOT:-${RUN_ROOT}/instrain_priority_20}"
SAMPLE_ID="${SAMPLE_ID:-CBF2}"
THREADS="${SLURM_CPUS_PER_TASK:-24}"

INSTRAIN_BIN="${INSTRAIN_BIN:-${PROJECT_ROOT}/conda/instrain_env/bin/inStrain}"
REFERENCE_FASTA="${REFERENCE_FASTA:-${PROJECT_ROOT}/output/PRJEB79569/catalogues/mags_votu.fasta}"
BAM_MANIFEST="${BAM_MANIFEST:-${RUN_ROOT}/mags_votu_metagenomic_bams.tsv}"
SCAFFOLDS_TO_PROFILE="${SCAFFOLDS_TO_PROFILE:-${RUN_ROOT}/instrain/priority_mag_inputs/priority_mag_scaffolds.txt}"
STB_FILE="${STB_FILE:-${RUN_ROOT}/instrain/priority_mag_inputs/priority_mag_scaffolds.stb}"

mkdir -p "${OUT_ROOT}/profiles" "${OUT_ROOT}/logs"

STATUS_PREFIX="${OUT_ROOT}/logs/${SAMPLE_ID}_profile_smoke_${SLURM_JOB_ID:-manual}"
PROFILE_OUT="${OUT_ROOT}/profiles/${SAMPLE_ID}"

finish() {
  code=$?
  printf '%s\n' "$code" > "${STATUS_PREFIX}.exitcode"
  if [[ "$code" -eq 0 ]]; then
    touch "${STATUS_PREFIX}.PASS"
  else
    touch "${STATUS_PREFIX}.FAIL"
  fi
}
trap finish EXIT

{
  printf 'started_at\t%s\n' "$(date -Is)"
  printf 'hostname\t%s\n' "$(hostname)"
  printf 'cwd\t%s\n' "$(pwd)"
  printf 'sample_id\t%s\n' "${SAMPLE_ID}"
  printf 'reference_fasta\t%s\n' "${REFERENCE_FASTA}"
  printf 'scaffolds_to_profile\t%s\n' "${SCAFFOLDS_TO_PROFILE}"
  printf 'stb_file\t%s\n' "${STB_FILE}"
  printf 'profile_out\t%s\n' "${PROFILE_OUT}"
} > "${STATUS_PREFIX}.started"

BAM_PATH="$(
  awk -F '\t' -v sample="${SAMPLE_ID}" '
    NR == 1 {
      for (i = 1; i <= NF; i++) {
        if ($i == "sample_id") sample_col = i
        if ($i == "bam_path") bam_col = i
      }
      next
    }
    $sample_col == sample { print $bam_col; exit }
  ' "${BAM_MANIFEST}"
)"

if [[ -z "${BAM_PATH}" ]]; then
  printf 'No BAM path found for sample_id=%s in %s\n' "${SAMPLE_ID}" "${BAM_MANIFEST}" >&2
  exit 2
fi

for required in "${INSTRAIN_BIN}" "${REFERENCE_FASTA}" "${BAM_PATH}" "${SCAFFOLDS_TO_PROFILE}" "${STB_FILE}"; do
  if [[ ! -e "${required}" ]]; then
    printf 'Missing required input: %s\n' "${required}" >&2
    exit 3
  fi
done

if [[ ! -e "${BAM_PATH}.bai" && ! -e "${BAM_PATH%.bam}.bai" ]]; then
  if command -v samtools >/dev/null 2>&1; then
    samtools index -@ 4 "${BAM_PATH}"
  else
    printf 'BAM index is missing and samtools is not available: %s\n' "${BAM_PATH}" >&2
    exit 4
  fi
fi

"${INSTRAIN_BIN}" profile \
  "${BAM_PATH}" \
  "${REFERENCE_FASTA}" \
  -o "${PROFILE_OUT}" \
  -p "${THREADS}" \
  -s "${STB_FILE}" \
  --scaffolds_to_profile "${SCAFFOLDS_TO_PROFILE}" \
  --database_mode \
  --skip_plot_generation

for expected in \
  "${PROFILE_OUT}/raw_data/covT.hd5" \
  "${PROFILE_OUT}/raw_data/cumulative_scaffold_table.csv.gz" \
  "${PROFILE_OUT}/raw_data/cumulative_snv_table.csv.gz" \
  "${PROFILE_OUT}/raw_data/raw_snp_table.csv.gz" \
  "${PROFILE_OUT}/raw_data/scaffold_list.txt"; do
  if [[ ! -s "${expected}" ]]; then
    printf 'Expected output missing or empty: %s\n' "${expected}" >&2
    exit 5
  fi
done

{
  printf 'finished_at\t%s\n' "$(date -Is)"
  printf 'sample_id\t%s\n' "${SAMPLE_ID}"
  printf 'profile_out\t%s\n' "${PROFILE_OUT}"
  printf 'raw_data_files\t%s\n' "$(find "${PROFILE_OUT}/raw_data" -maxdepth 1 -type f | wc -l)"
  printf 'scaffolds_profiled\t%s\n' "$(wc -l < "${PROFILE_OUT}/raw_data/scaffold_list.txt")"
} > "${STATUS_PREFIX}.summary.tsv"
