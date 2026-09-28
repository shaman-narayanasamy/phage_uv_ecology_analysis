#!/bin/bash -l

# ARGS:
#   1: --dry-run, --touch, --unlock, or empty for execution

set -euo pipefail

PROJECT_REPO="/mnt/aiongpfs/users/snarayanasamy/repositories/phage_uv_ecology_analysis"
PIPELINE_REPO="/mnt/aiongpfs/users/snarayanasamy/repositories/viromics_pipeline"
PROJECT_DIR="/scratch/users/snarayanasamy/phage_uv_treatment"

SMK_FILE="workflows/identification.smk"
SMK_CONFIG="${PROJECT_REPO}/config/PRJEB79569_viromics_ulhpc_config.yml"
SMK_JOBS=24
CONDA_PREFIX_DIR="${PROJECT_DIR}/conda"
SMK_ARG="${1:-}"

# ViraLM needs a CPU PyTorch build from defaults while other dependencies come
# from conda-forge; strict priority excludes the required mixed solution.
export CONDA_CHANNEL_PRIORITY=flexible

CONTIG_TABLE="${PROJECT_DIR}/metadata/PRJEB79569_viromics_contigs.tsv"
GENOMAD_DB="/mnt/isilon/projects/bioinformatics_platform/projects/shared_references/viromics_pipeline/genomad"
VIRSORTER2_DB="/mnt/isilon/projects/bioinformatics_platform/projects/shared_references/viromics_pipeline/virsorter2"
VIRALM_SCRIPT="/mnt/aiongpfs/users/snarayanasamy/repositories/viromics_pipeline/scripts/viralm_tmpcache.py"
VIRALM_DB="/mnt/isilon/projects/bioinformatics_platform/projects/shared_references/viromics_pipeline/viralm/model"

python "${PIPELINE_REPO}/scripts/prepare_multiomics_contig_table.py" \
    --metadata "${PROJECT_DIR}/metadata/PRJEB79569_multiomics_samples.tsv" \
    --multiomics-output-dir "${PROJECT_DIR}/output/PRJEB79569" \
    --output "${CONTIG_TABLE}" \
    --require-existing

if [[ "${SMK_ARG}" != "--dry-run" && "${SMK_ARG}" != "--unlock" ]]; then
    for path in "${GENOMAD_DB}" "${VIRSORTER2_DB}" "${VIRALM_DB}"; do
        if [[ ! -d "${path}" ]]; then
            echo "Error: viromics database directory not found at ${path}" >&2
            echo "Update database paths in ${SMK_CONFIG} before launching identification." >&2
            exit 2
        fi
    done

    if [[ ! -f "${VIRALM_SCRIPT}" ]]; then
        echo "Error: ViralM script not found at ${VIRALM_SCRIPT}" >&2
        echo "Update viralm.script in ${SMK_CONFIG} before launching identification." >&2
        exit 2
    fi
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/snakemake9_common.sh"
