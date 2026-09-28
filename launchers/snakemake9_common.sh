#!/bin/bash

set -euo pipefail

SMK_ARG="${1:-}"
SMK_SITE="${HPC_SITE:-iris}"
case "${SMK_SITE}" in
    iris|aion) ;;
    *)
        echo "Error: unsupported HPC_SITE '${SMK_SITE}' (expected iris or aion)" >&2
        exit 2
        ;;
esac

SMK_PROFILE="${SMK_PROFILE:-${PROJECT_REPO}/profiles/slurm-${SMK_SITE}}"
SMK_ENV_NAME="${SMK_ENV_NAME:-snakemake_env}"
SMK_RERUN_TRIGGERS="${SMK_RERUN_TRIGGERS:-}"

case "${SMK_ARG}" in
    "--dry-run") echo "Performing dry-run" ;;
    "--touch") echo "Touching files" ;;
    "--unlock") echo "Unlocking analysis folders" ;;
    "") echo "Launching analysis" ;;
    *) echo "Error: unexpected argument: ${SMK_ARG}"; exit 1 ;;
esac

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "${SMK_ENV_NAME}"

if ! python -c 'import importlib.util, sys; sys.exit(0 if importlib.util.find_spec("snakemake_executor_plugin_slurm") else 1)' ; then
    cat >&2 <<'EOF'
Error: snakemake_env does not include the Snakemake SLURM executor plugin.

Install it before launching cluster jobs:
  conda install -n snakemake_env -c conda-forge -c bioconda snakemake-executor-plugin-slurm
EOF
    exit 2
fi

mkdir -p "${PROJECT_DIR}/slurm" "${PROJECT_DIR}/tmp"
cd "${PIPELINE_REPO}"

echo "Using HPC site: ${SMK_SITE}"
echo "Using Snakemake profile: ${SMK_PROFILE}"

CMD=(snakemake)
if [[ -n "${SMK_ARG}" ]]; then
    CMD+=("${SMK_ARG}")
fi
CMD+=(
    --profile "${SMK_PROFILE}"
    --configfile "${SMK_CONFIG}"
    --conda-prefix "${CONDA_PREFIX_DIR}"
    --jobs "${SMK_JOBS}"
    --snakefile "${SMK_FILE}"
)

if [[ -n "${SMK_RERUN_TRIGGERS}" ]]; then
    CMD+=(--rerun-triggers "${SMK_RERUN_TRIGGERS}")
fi

if [[ "${SMK_NOLOCK:-0}" == "1" || "${SMK_NOLOCK:-false}" == "true" ]]; then
    CMD+=(--nolock)
fi

printf '%q ' "${CMD[@]}"
printf '\n'
"${CMD[@]}"
