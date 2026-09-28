#!/usr/bin/env bash
# Step 2: remove the 515F/907R primers from the deposited FASTQs.
#
# The deposited reads retain their primers (about 95% of R1 and 94% of R2 carry
# an exact degenerate-primer prefix). DADA2 requires primer-free input: residual
# primer bases are low-diversity, break the error model, and inflate the ASV
# count. Primers are removed as anchored 5' adapters, and read pairs without a
# primer on both mates are discarded rather than silently kept.
set -euo pipefail

manifest="${1:-metadata/16s_ena_fastq_manifest.tsv}"
raw_dir="${2:-${PHAGE_UV_16S_RAW_DIR:-}}"
out_dir="${3:-${PHAGE_UV_16S_TRIMMED_DIR:-}}"

fwd_primer="${PHAGE_UV_16S_PRIMER_FWD:-GTGYCAGCMGCCGCGGTAA}"
rev_primer="${PHAGE_UV_16S_PRIMER_REV:-CCCCGYCAATTCMTTTRAGT}"
threads="${PHAGE_UV_16S_THREADS:-4}"
error_rate="${PHAGE_UV_16S_PRIMER_ERROR_RATE:-0.15}"
min_length="${PHAGE_UV_16S_PRIMER_MIN_LENGTH:-50}"

if [[ -z "${raw_dir}" || -z "${out_dir}" ]]; then
  printf 'Usage: %s [fastq_manifest.tsv] RAW_DIR OUT_DIR\n' "$0" >&2
  printf 'Or source config/16s_analysis_paths.sh first.\n' >&2
  exit 2
fi
if [[ ! -f "${manifest}" ]]; then
  printf 'Manifest not found: %s\n' "${manifest}" >&2
  exit 2
fi
if ! command -v cutadapt >/dev/null 2>&1; then
  printf 'cutadapt not found. Install it (conda install -c bioconda cutadapt) and retry.\n' >&2
  exit 127
fi

mkdir -p "${out_dir}" "${out_dir}/logs"
report="${out_dir}/16s_primer_removal_report.tsv"
printf 'sample_title\tinput_pairs\toutput_pairs\tretained_fraction\tcutadapt_log\n' > "${report}"

samples="$(awk -F'\t' 'NR > 1 && $1 != "" {print $1}' "${manifest}" | sort -u)"

for sample in ${samples}; do
  r1_in="${raw_dir%/}/${sample}_R1.fastq.gz"
  r2_in="${raw_dir%/}/${sample}_R2.fastq.gz"
  if [[ ! -f "${r1_in}" || ! -f "${r2_in}" ]]; then
    printf 'Missing raw FASTQ pair for %s in %s\n' "${sample}" "${raw_dir}" >&2
    exit 1
  fi

  r1_out="${out_dir%/}/${sample}_R1.trimmed.fastq.gz"
  r2_out="${out_dir%/}/${sample}_R2.trimmed.fastq.gz"
  log="${out_dir%/}/logs/${sample}.cutadapt.log"

  cutadapt \
    -g "^${fwd_primer}" \
    -G "^${rev_primer}" \
    --error-rate "${error_rate}" \
    --discard-untrimmed \
    --pair-filter=any \
    --minimum-length "${min_length}" \
    --cores "${threads}" \
    -o "${r1_out}" -p "${r2_out}" \
    "${r1_in}" "${r2_in}" > "${log}" 2>&1

  input_pairs="$(awk -F': *' '/Total read pairs processed/ {gsub(/[^0-9]/, "", $2); print $2}' "${log}")"
  output_pairs="$(awk -F': *' '/Pairs written \(passing filters\)/ {split($2, a, " "); gsub(/[^0-9]/, "", a[1]); print a[1]}' "${log}")"
  fraction="$(awk -v i="${input_pairs}" -v o="${output_pairs}" 'BEGIN {if (i > 0) printf "%.4f", o / i; else print "NA"}')"

  printf '%s\t%s\t%s\t%s\t%s\n' "${sample}" "${input_pairs}" "${output_pairs}" "${fraction}" "${log}" >> "${report}"
  printf 'Trimmed %s: %s -> %s pairs (%s retained)\n' "${sample}" "${input_pairs}" "${output_pairs}" "${fraction}"
done

printf '\nPrimer-removal report: %s\n' "${report}"
printf 'QC gate: investigate any sample retaining less than 0.80 of its input pairs.\n'
