#!/bin/bash -l
#SBATCH --job-name=host_phage_full
#SBATCH --partition=bigmem
#SBATCH --cpus-per-task=40
#SBATCH --mem=240G
#SBATCH --time=48:00:00
#SBATCH --output=/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/host_phage_linking/logs/%x_%j.out
#SBATCH --error=/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/host_phage_linking/logs/%x_%j.err

set -euo pipefail

PROJECT_ROOT="/scratch/users/snarayanasamy/phage_uv_treatment"
REPO="${PROJECT_ROOT}/repositories/host_phage_linking"
CONFIG="${PROJECT_ROOT}/output/PRJEB79569/host_phage_linking/config/config.full.yml"
SNAKEMAKE_CONDA_PREFIX="${PROJECT_ROOT}/conda"
LOG_DIR="${PROJECT_ROOT}/output/PRJEB79569/host_phage_linking/logs"
FULL_OUT="${PROJECT_ROOT}/output/PRJEB79569/host_phage_linking/full/crispr_links"
HOST_TABLE="${PROJECT_ROOT}/output/PRJEB79569/host_phage_linking/config/host_table.full.tsv"

mkdir -p "${LOG_DIR}"
STAMP="$(date +%Y%m%d_%H%M%S)"
SENTINEL_PREFIX="${LOG_DIR}/host_phage_full_${SLURM_JOB_ID:-manual}_${STAMP}"

{
  echo "started_at=$(date --iso-8601=seconds)"
  echo "hostname=$(hostname)"
  echo "cwd=${REPO}"
  echo "config=${CONFIG}"
  git -C "${REPO}" rev-parse --abbrev-ref HEAD
  git -C "${REPO}" rev-parse HEAD
} > "${SENTINEL_PREFIX}.started"

trap 'code=$?; echo "${code}" > "${SENTINEL_PREFIX}.exitcode"; if [[ "${code}" -eq 0 ]]; then touch "${SENTINEL_PREFIX}.PASS"; else touch "${SENTINEL_PREFIX}.FAIL"; fi' EXIT

source /home/users/snarayanasamy/miniforge3/etc/profile.d/conda.sh
conda activate snakemake_env

cd "${REPO}"

snakemake \
  -s workflows/crispr_links.smk \
  --configfile "${CONFIG}" \
  --cores 40 \
  --resources mem_mb=240000 \
  --use-conda \
  --conda-prefix "${SNAKEMAKE_CONDA_PREFIX}" \
  --rerun-incomplete \
  --latency-wait 120 \
  --printshellcmds

test -e "${FULL_OUT}/crispr_links.done"

EXPECTED_PREDICTIONS="$(($(wc -l < "${HOST_TABLE}") - 1))"
OBSERVED_PREDICTIONS="$(find "${FULL_OUT}/spacepharer" -mindepth 2 -maxdepth 2 -name predictions.tsv | wc -l)"

if [[ "${OBSERVED_PREDICTIONS}" -ne "${EXPECTED_PREDICTIONS}" ]]; then
  echo "Expected ${EXPECTED_PREDICTIONS} SpacePHARER prediction files, observed ${OBSERVED_PREDICTIONS}" >&2
  exit 1
fi

{
  echo "completed_at=$(date --iso-8601=seconds)"
  echo "full_out=${FULL_OUT}"
  echo "expected_prediction_files=${EXPECTED_PREDICTIONS}"
  echo "observed_prediction_files=${OBSERVED_PREDICTIONS}"
  find "${FULL_OUT}/spacepharer" -mindepth 2 -maxdepth 2 -name predictions.tsv -print0 \
    | xargs -0 wc -l \
    | sort -n \
    | tail -20
} > "${SENTINEL_PREFIX}.summary"
