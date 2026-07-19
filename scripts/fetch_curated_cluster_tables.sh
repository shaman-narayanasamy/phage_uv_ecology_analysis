#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
MANIFEST="${MANIFEST:-${REPO_ROOT}/manifests/cluster_curated_table_manifest.tsv}"
SSH_ALIAS="${SSH_ALIAS:-iris-cluster}"
LOCAL_DATA_ROOT="${LOCAL_DATA_ROOT:-/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569}"

if [[ ! -s "${MANIFEST}" ]]; then
  echo "Manifest not found: ${MANIFEST}" >&2
  exit 2
fi

mkdir -p "${LOCAL_DATA_ROOT}"

tail -n +2 "${MANIFEST}" |
while IFS=$'\t' read -r data_id fetch_now remote_path local_relative_path role remote_size_bytes notes; do
  if [[ "${fetch_now}" != "yes" ]]; then
    printf 'skip\t%s\t%s\n' "${fetch_now}" "${data_id}"
    continue
  fi

  local_path="${LOCAL_DATA_ROOT}/${local_relative_path}"
  mkdir -p "$(dirname "${local_path}")"
  printf 'fetch\t%s\t%s bytes\n' "${data_id}" "${remote_size_bytes}"
  rsync -av "${SSH_ALIAS}:${remote_path}" "${local_path}"
done
