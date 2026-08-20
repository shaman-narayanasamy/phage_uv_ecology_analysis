#!/usr/bin/env bash
set -euo pipefail

manifest="${1:-metadata/16s_ena_fastq_manifest.tsv}"
destination="${2:-}"

if [[ -z "${destination}" ]]; then
  printf 'Usage: %s [fastq_manifest.tsv] DESTINATION_DIRECTORY\n' "$0" >&2
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

verify_md5() {
  local file="$1"
  local expected="$2"
  [[ "$(calculate_md5 "${file}")" == "${expected}" ]]
}

while IFS=$'\t' read -r sample run direction filename url expected_md5 expected_bytes; do
  [[ "${sample}" == "sample_title" ]] && continue
  final_path="${destination%/}/${filename}"
  partial_path="${final_path}.part"

  if [[ -f "${final_path}" ]] && verify_md5 "${final_path}" "${expected_md5}"; then
    printf 'VERIFIED existing: %s\n' "${final_path}"
    continue
  fi

  printf 'Downloading %s %s (%s bytes)\n' "${run}" "${direction}" "${expected_bytes}"
  curl -fL --retry 5 --retry-all-errors --continue-at - \
    --output "${partial_path}" "${url}"

  if ! verify_md5 "${partial_path}" "${expected_md5}"; then
    printf 'CHECKSUM FAILED: %s\n' "${partial_path}" >&2
    exit 1
  fi
  mv "${partial_path}" "${final_path}"
  printf 'VERIFIED downloaded: %s\n' "${final_path}"
done < "${manifest}"

printf 'All manifest FASTQs are present and checksum-verified in %s\n' "${destination}"
