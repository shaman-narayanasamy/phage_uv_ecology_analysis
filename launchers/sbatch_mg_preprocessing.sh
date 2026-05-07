#!/bin/bash -l

# ARGS:
#   1: --dry-run, --touch, --unlock, or empty for execution

set -euo pipefail

PROJECT_REPO="/mnt/aiongpfs/users/snarayanasamy/repositories/phage_uv_ecology_analysis"
PIPELINE_REPO="/mnt/aiongpfs/users/snarayanasamy/repositories/multiomics_pipeline"
PROJECT_DIR="/scratch/users/snarayanasamy/phage_uv_treatment"

SMK_FILE="workflows/metagenomics/preprocessing.smk"
SMK_CONFIG="${PROJECT_REPO}/config/PRJEB79569_ulhpc_config.yml"
SMK_JOBS=32
CONDA_PREFIX_DIR="/work/projects/bioinformatics_platform/cache/conda"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/snakemake9_common.sh"
