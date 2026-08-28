#!/usr/bin/env bash
set -euo pipefail

outdir="${1:-metadata}"
mkdir -p "$outdir"

bash scripts/run_qmd.sh scripts/check_mgnify_prjeb79569.qmd "$outdir"
