#!/usr/bin/env bash
#SBATCH --job-name=instrain_priority20_compare
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/community_uv_response/variant_analysis/logs/instrain_priority20_compare_%j.out
#SBATCH --error=/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/community_uv_response/variant_analysis/logs/instrain_priority20_compare_%j.err

set -euo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-/scratch/users/snarayanasamy/phage_uv_treatment}"
RUN_ROOT="${RUN_ROOT:-${PROJECT_ROOT}/output/PRJEB79569/community_uv_response/variant_analysis}"
OUT_ROOT="${OUT_ROOT:-${RUN_ROOT}/instrain_priority_20}"
THREADS="${SLURM_CPUS_PER_TASK:-16}"

INSTRAIN_BIN="${INSTRAIN_BIN:-${PROJECT_ROOT}/conda/instrain_env/bin/inStrain}"
STB_FILE="${STB_FILE:-${RUN_ROOT}/instrain/priority_mag_inputs/priority_mag_scaffolds.stb}"
COMPARE_OUT="${COMPARE_OUT:-${OUT_ROOT}/compare/all_samples}"
STATUS_PREFIX="${OUT_ROOT}/logs/instrain_compare_${SLURM_JOB_ID:-manual}"

SAMPLES=(CBF1 CBF2 CBF3 CI1 CI2 CI3 TBF1 TBF2 TBF3 TI1 TI2 TI3)
REQUIRED_RAW=(covT.hd5 cumulative_scaffold_table.csv.gz cumulative_snv_table.csv.gz raw_snp_table.csv.gz scaffold_list.txt)

mkdir -p "${OUT_ROOT}/logs" "${COMPARE_OUT}"

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
  printf 'profile_root\t%s\n' "${OUT_ROOT}/profiles"
  printf 'compare_out\t%s\n' "${COMPARE_OUT}"
  printf 'stb_file\t%s\n' "${STB_FILE}"
} > "${STATUS_PREFIX}.started"

for required in "${INSTRAIN_BIN}" "${STB_FILE}"; do
  if [[ ! -e "${required}" ]]; then
    printf 'Missing required input: %s\n' "${required}" >&2
    exit 2
  fi
done

PROFILE_DIRS=()
for sample in "${SAMPLES[@]}"; do
  profile_dir="${OUT_ROOT}/profiles/${sample}"
  if [[ ! -d "${profile_dir}" ]]; then
    printf 'Missing profile directory: %s\n' "${profile_dir}" >&2
    exit 3
  fi
  for raw_file in "${REQUIRED_RAW[@]}"; do
    if [[ ! -s "${profile_dir}/raw_data/${raw_file}" ]]; then
      printf 'Profile %s missing raw_data/%s\n' "${sample}" "${raw_file}" >&2
      exit 4
    fi
  done
  PROFILE_DIRS+=("${profile_dir}")
done

"${INSTRAIN_BIN}" compare \
  -i "${PROFILE_DIRS[@]}" \
  -o "${COMPARE_OUT}" \
  -p "${THREADS}" \
  -s "${STB_FILE}" \
  --database_mode \
  --skip_plot_generation

if [[ ! -d "${COMPARE_OUT}" ]]; then
  printf 'Missing compare output directory: %s\n' "${COMPARE_OUT}" >&2
  exit 5
fi

n_outputs="$(find "${COMPARE_OUT}" -type f | wc -l)"
if [[ "${n_outputs}" -eq 0 ]]; then
  printf 'Compare output directory contains no files: %s\n' "${COMPARE_OUT}" >&2
  exit 6
fi

{
  printf 'finished_at\t%s\n' "$(date -Is)"
  printf 'compare_out\t%s\n' "${COMPARE_OUT}"
  printf 'profile_count\t%s\n' "${#PROFILE_DIRS[@]}"
  printf 'output_files\t%s\n' "${n_outputs}"
} > "${STATUS_PREFIX}.summary.tsv"
