#!/usr/bin/env bash
# Download and checksum-verify the taxonomic reference databases declared in
# metadata/16s_reference_manifest.tsv. Re-running is safe: verified files are
# skipped and partial downloads resume.
set -euo pipefail

manifest="${1:-metadata/16s_reference_manifest.tsv}"
destination="${2:-${PHAGE_UV_16S_REFERENCE_DIR:-}}"

if [[ -z "${destination}" ]]; then
  printf 'Usage: %s [reference_manifest.tsv] DESTINATION_DIRECTORY\n' "$0" >&2
  printf 'Or source config/16s_analysis_paths.sh first.\n' >&2
  exit 2
fi
if [[ ! -f "${manifest}" ]]; then
  printf 'Manifest not found: %s\n' "${manifest}" >&2
  exit 2
fi

mkdir -p "${destination}"

calculate_md5() {
  local file="$1"
  if command -v md5sum >/dev/null 2>&1; then
    md5sum "${file}" | awk '{print $1}'
  elif command -v md5 >/dev/null 2>&1; then
    md5 -q "${file}"
  else
    printf 'Neither md5sum nor md5 is available\n' >&2
    return 127
  fi
}

while IFS=$'\t' read -r name role filename url md5 bytes record citation; do
  [[ "${name}" == "reference_set" ]] && continue
  [[ -z "${name}" ]] && continue
  final_path="${destination%/}/${filename}"
  partial_path="${final_path}.part"

  if [[ -f "${final_path}" ]] && [[ "$(calculate_md5 "${final_path}")" == "${md5}" ]]; then
    printf 'VERIFIED existing: %s (%s)\n' "${final_path}" "${role}"
    continue
  fi

  printf 'Downloading %s -> %s (%s bytes)\n' "${name}" "${filename}" "${bytes}"
  curl -fL --retry 5 --retry-all-errors --continue-at - \
    --output "${partial_path}" "${url}"

  if [[ "$(calculate_md5 "${partial_path}")" != "${md5}" ]]; then
    printf 'CHECKSUM FAILED: %s\n' "${partial_path}" >&2
    exit 1
  fi
  mv "${partial_path}" "${final_path}"
  printf 'VERIFIED downloaded: %s\n' "${final_path}"
done < "${manifest}"

printf 'All reference databases present and checksum-verified in %s\n' "${destination}"
