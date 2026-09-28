#!/usr/bin/env bash
# Optional tractability step: draw an equal, seeded, paired subsample from the
# primer-removed reads before denoising.
#
# Denoising cost scales with unique sequences, not with community signal. The
# original study rarefied to 23,800 reads per sample; the default depth here is
# several times that, so the community-level result is unaffected while the run
# becomes feasible on a small machine. This step is recorded in provenance and
# is not a substitute for a full-depth run when the compute exists.
set -euo pipefail

in_dir="${1:-${PHAGE_UV_16S_TRIMMED_DIR:-}}"
out_dir="${2:-${PHAGE_UV_16S_SUBSAMPLED_DIR:-}}"
depth="${3:-${PHAGE_UV_16S_SUBSAMPLE_DEPTH:-150000}}"
seed="${PHAGE_UV_16S_SUBSAMPLE_SEED:-42}"

if [[ -z "${in_dir}" || -z "${out_dir}" ]]; then
  printf 'Usage: %s IN_DIR OUT_DIR [DEPTH]\n' "$0" >&2
  exit 2
fi
command -v seqtk >/dev/null 2>&1 || { printf 'seqtk not found\n' >&2; exit 127; }

mkdir -p "${out_dir}"
report="${out_dir}/16s_subsample_report.tsv"
printf 'sample_title\tinput_pairs\trequested_depth\toutput_pairs\tseed\n' > "${report}"

for r1 in "${in_dir%/}"/*_R1.trimmed.fastq.gz; do
  sample="$(basename "${r1}" _R1.trimmed.fastq.gz)"
  r2="${in_dir%/}/${sample}_R2.trimmed.fastq.gz"
  o1="${out_dir%/}/${sample}_R1.trimmed.fastq.gz"
  o2="${out_dir%/}/${sample}_R2.trimmed.fastq.gz"

  input_pairs=$(( $(zcat "${r1}" | wc -l) / 4 ))
  # The same seed on both mates keeps pairs synchronised.
  seqtk sample -s"${seed}" "${r1}" "${depth}" | gzip -1 > "${o1}"
  seqtk sample -s"${seed}" "${r2}" "${depth}" | gzip -1 > "${o2}"
  output_pairs=$(( $(zcat "${o1}" | wc -l) / 4 ))

  printf '%s\t%s\t%s\t%s\t%s\n' "${sample}" "${input_pairs}" "${depth}" "${output_pairs}" "${seed}" >> "${report}"
  printf 'Subsampled %s: %s -> %s pairs\n' "${sample}" "${input_pairs}" "${output_pairs}"
done

printf '\nSubsample report: %s\n' "${report}"
