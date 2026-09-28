#!/bin/bash -l

# ARGS:
#   1: --dry-run, --touch, --unlock, or empty for execution

set -euo pipefail

PROJECT_REPO="/mnt/aiongpfs/users/snarayanasamy/repositories/phage_uv_ecology_analysis"
PIPELINE_REPO="/mnt/aiongpfs/users/snarayanasamy/repositories/viromics_pipeline"
PROJECT_DIR="/scratch/users/snarayanasamy/phage_uv_treatment"

SMK_FILE="workflows/consolidate_preds.smk"
SMK_CONFIG="${PROJECT_REPO}/config/PRJEB79569_viromics_ulhpc_config.yml"
SMK_JOBS=8
CONDA_PREFIX_DIR="/work/projects/bioinformatics_platform/cache/conda"

python "${PIPELINE_REPO}/scripts/prepare_multiomics_contig_table.py" \
    --metadata "${PROJECT_DIR}/metadata/PRJEB79569_multiomics_samples.tsv" \
    --multiomics-output-dir "${PROJECT_DIR}/output/PRJEB79569" \
    --output "${PROJECT_DIR}/metadata/PRJEB79569_viromics_contigs.tsv" \
    --require-existing

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/snakemake9_common.sh"
