#!/usr/bin/env bash
# Earlier cohort (PRJEB38595, single-end): remove the anchored 515F primer,
# discard reads without it, then draw a seeded subsample to the same depth the
# current cohort was subsampled to. Reads are single-end, so only the forward
# primer applies; the 907R site lies beyond the 300 bp read (verified: 0.4% of
# reads carry its reverse complement).
set -euo pipefail

manifest="${1:-metadata/16s_v2_earlier_cohort_fastq_manifest.tsv}"
raw_dir="${2:?RAW_DIR}"
out_dir="${3:?OUT_DIR}"
depth="${4:-${PHAGE_UV_16S_SUBSAMPLE_DEPTH:-150000}}"
fwd_primer="${PHAGE_UV_16S_PRIMER_FWD:-GTGYCAGCMGCCGCGGTAA}"
threads="${PHAGE_UV_16S_THREADS:-4}"
seed="${PHAGE_UV_16S_SUBSAMPLE_SEED:-42}"
error_rate="${PHAGE_UV_16S_PRIMER_ERROR_RATE:-0.15}"
min_length="${PHAGE_UV_16S_PRIMER_MIN_LENGTH:-50}"

command -v cutadapt >/dev/null || { printf 'cutadapt not found\n' >&2; exit 127; }
command -v seqtk >/dev/null || { printf 'seqtk not found\n' >&2; exit 127; }
mkdir -p "${out_dir}/logs"
report="${out_dir}/16s_v2_earlier_cohort_primer_removal_report.tsv"
printf 'sample_title\tinput_reads\tprimer_free_reads\tretained_fraction\tsubsample_depth\toutput_reads\tseed\n' > "${report}"

awk -F'\t' 'NR > 1 && $1 != "" {print $1}' "${manifest}" | sort -u | while read -r sample; do
  in="${raw_dir%/}/${sample}_SE.fastq.gz"
  full="${out_dir%/}/${sample}_SE.primerfree.fastq.gz"
  out="${out_dir%/}/${sample}_SE.trimmed.fastq.gz"
  log="${out_dir%/}/logs/${sample}.cutadapt.log"
  [[ -f "${in}" ]] || { printf 'Missing %s\n' "${in}" >&2; exit 1; }
  cutadapt -g "^${fwd_primer}" --error-rate "${error_rate}" --discard-untrimmed \
    --minimum-length "${min_length}" --cores "${threads}" -o "${full}" "${in}" > "${log}" 2>&1
  input_reads="$(awk -F': *' '/Total reads processed/ {gsub(/[^0-9]/, "", $2); print $2}' "${log}")"
  kept="$(awk -F': *' '/Reads written \(passing filters\)/ {split($2, a, " "); gsub(/[^0-9]/, "", a[1]); print a[1]}' "${log}")"
  fraction="$(awk -v i="${input_reads}" -v o="${kept}" 'BEGIN {if (i > 0) printf "%.4f", o / i; else print "NA"}')"
  seqtk sample -s"${seed}" "${full}" "${depth}" | gzip -1 > "${out}"
  output_reads=$(( $(zcat "${out}" | wc -l) / 4 ))
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "${sample}" "${input_reads}" "${kept}" "${fraction}" "${depth}" "${output_reads}" "${seed}" >> "${report}"
  printf 'Earlier cohort %s: %s -> %s primer-free (%s), subsampled to %s\n' "${sample}" "${input_reads}" "${kept}" "${fraction}" "${output_reads}"
done
printf '\nReport: %s\n' "${report}"
