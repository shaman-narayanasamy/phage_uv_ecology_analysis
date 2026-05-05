#!/usr/bin/env bash
set -euo pipefail

outdir="${1:-metadata}"
mkdir -p "$outdir"

accession="PRJEB79569"
fields="run_accession,study_accession,secondary_study_accession,sample_accession,secondary_sample_accession,experiment_accession,sample_title,library_strategy,library_source,library_selection,library_layout,instrument_platform,instrument_model,read_count,base_count,first_public,last_updated"
url="https://www.ebi.ac.uk/ena/portal/api/filereport?accession=${accession}&result=read_run&fields=${fields}&format=tsv&limit=0"

tmpfile="$(mktemp)"
curl -fsSL "$url" > "$tmpfile"
mv "$tmpfile" "${outdir}/ena_run_metadata.tsv"
shasum -a 256 "${outdir}/ena_run_metadata.tsv" > "${outdir}/ena_run_metadata.tsv.sha256"

printf 'Wrote %s and checksum\n' "${outdir}/ena_run_metadata.tsv"
