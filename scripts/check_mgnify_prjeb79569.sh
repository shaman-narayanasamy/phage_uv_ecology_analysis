#!/usr/bin/env bash
set -euo pipefail

outdir="${1:-metadata}"
mkdir -p "$outdir"

Rscript scripts/check_mgnify_prjeb79569.R "$outdir"
