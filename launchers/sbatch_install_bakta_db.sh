#!/bin/bash -l
#SBATCH --job-name=install_bakta_db
#SBATCH --partition=batch
#SBATCH --qos=iris-batch-long
#SBATCH --account=michael.heneka
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=48G
#SBATCH --time=72:00:00
#SBATCH --output=/scratch/users/snarayanasamy/phage_uv_treatment/slurm/install_bakta_db_%j.out
#SBATCH --error=/scratch/users/snarayanasamy/phage_uv_treatment/slurm/install_bakta_db_%j.err

set -euo pipefail

PIPELINE_REPO="/mnt/aiongpfs/users/snarayanasamy/repositories/multiomics_pipeline"
CONDA_PREFIX="/scratch/users/snarayanasamy/phage_uv_treatment/conda/bakta_db_tools"
BAKTA_PARENT="/mnt/isilon/projects/bioinformatics_platform/projects/shared_references/bakta"
BAKTA_DB_LINK="${BAKTA_PARENT}/db"
TMP_DIR="/scratch/users/snarayanasamy/phage_uv_treatment/tmp/bakta_db"

mkdir -p "${BAKTA_PARENT}" "${TMP_DIR}" /scratch/users/snarayanasamy/phage_uv_treatment/slurm

source "$(conda info --base)/etc/profile.d/conda.sh"

if [[ ! -x "${CONDA_PREFIX}/bin/bakta_db" ]]; then
    conda env create --prefix "${CONDA_PREFIX}" --file "${PIPELINE_REPO}/envs/bakta_env.yml"
fi

conda activate "${CONDA_PREFIX}"

bakta_db download --output "${BAKTA_PARENT}" --type full

if [[ -d "${BAKTA_PARENT}/db-full" ]]; then
    ln -sfn "${BAKTA_PARENT}/db-full" "${BAKTA_DB_LINK}"
elif [[ -d "${BAKTA_PARENT}/db-light" ]]; then
    ln -sfn "${BAKTA_PARENT}/db-light" "${BAKTA_DB_LINK}"
elif [[ ! -d "${BAKTA_DB_LINK}" ]]; then
    echo "Error: Bakta download finished, but no database directory was found under ${BAKTA_PARENT}" >&2
    find "${BAKTA_PARENT}" -maxdepth 2 -type d -print >&2
    exit 2
fi

test -d "${BAKTA_DB_LINK}"
find -L "${BAKTA_DB_LINK}" -maxdepth 1 -type f -o -maxdepth 1 -type d
