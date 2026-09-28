#!/bin/bash -l

# ARGS:
#   1: --dry-run, --touch, --unlock, or empty for execution

set -euo pipefail

PROJECT_REPO="/mnt/aiongpfs/users/snarayanasamy/repositories/phage_uv_ecology_analysis"
PIPELINE_REPO="/mnt/aiongpfs/users/snarayanasamy/repositories/multiomics_pipeline"
PROJECT_DIR="/scratch/users/snarayanasamy/phage_uv_treatment"

SMK_FILE="workflows/binning.smk"
SMK_CONFIG="${PROJECT_REPO}/config/PRJEB79569_binning_ulhpc_config.yml"
SMK_JOBS=24
CONDA_PREFIX_DIR="/scratch/users/snarayanasamy/phage_uv_treatment/conda"
MAGSCOT_DIR="/home/users/snarayanasamy/repositories/MAGScoT"
SMK_ARG="${1:-}"

python "${PROJECT_REPO}/scripts/prepare_binning_input.py" \
    --metadata "${PROJECT_DIR}/metadata/PRJEB79569_multiomics_samples.tsv" \
    --mg-preprocessing-dir "${PROJECT_DIR}/output/PRJEB79569/metagenomics/preprocessing" \
    --coassembly-dir "${PROJECT_DIR}/output/PRJEB79569/coassembly" \
    --output "${PROJECT_DIR}/metadata/PRJEB79569_binning_input.tsv"

if [[ "${SMK_ARG}" != "--dry-run" && "${SMK_ARG}" != "--unlock" && ! -f "${MAGSCOT_DIR}/MAGScoT.R" ]]; then
    echo "Error: MAGScoT.R not found at ${MAGSCOT_DIR}/MAGScoT.R" >&2
    echo "Update magscot.folder in ${SMK_CONFIG} before launching binning." >&2
    exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/snakemake9_common.sh"
