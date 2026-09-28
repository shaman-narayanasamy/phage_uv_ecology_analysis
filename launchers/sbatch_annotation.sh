#!/bin/bash -l

# ARGS:
#   1: --dry-run, --touch, --unlock, or empty for execution

set -euo pipefail

PROJECT_REPO="/mnt/aiongpfs/users/snarayanasamy/repositories/phage_uv_ecology_analysis"
PIPELINE_REPO="/mnt/aiongpfs/users/snarayanasamy/repositories/multiomics_pipeline"
PROJECT_DIR="/scratch/users/snarayanasamy/phage_uv_treatment"

SMK_FILE="workflows/annotation.smk"
SMK_CONFIG="${PROJECT_REPO}/config/PRJEB79569_annotation_ulhpc_config.yml"
SMK_JOBS=24
CONDA_PREFIX_DIR="/scratch/users/snarayanasamy/phage_uv_treatment/conda"
BAKTA_DB="/mnt/isilon/projects/bioinformatics_platform/projects/shared_references/bakta/db"
export HPC_SITE="${HPC_SITE:-iris}"
SMK_ARG="${1:-}"

python "${PROJECT_REPO}/scripts/prepare_annotation_genome_table.py" \
    --genomes-dir "${PROJECT_DIR}/output/PRJEB79569/binning/dereplication/dereplicated_genomes" \
    --output "${PROJECT_DIR}/metadata/PRJEB79569_annotation_genomes.tsv"

if [[ "${SMK_ARG}" != "--dry-run" && "${SMK_ARG}" != "--unlock" && ! -d "${BAKTA_DB}" ]]; then
    echo "Error: Bakta database directory not found at ${BAKTA_DB}" >&2
    echo "Update bakta.db_path in ${SMK_CONFIG} before launching annotation." >&2
    exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/snakemake9_common.sh"
