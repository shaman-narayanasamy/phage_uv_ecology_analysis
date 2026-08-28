#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: bash scripts/run_qmd.sh scripts/analysis.qmd [arguments...]" >&2
  exit 2
fi

runner_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$runner_dir/.." && pwd)"
notebook="$1"
shift

if [[ "$notebook" != /* ]]; then
  notebook="$repo_root/$notebook"
fi

if [[ ! -f "$notebook" || "$notebook" != *.qmd ]]; then
  echo "Quarto notebook not found: $notebook" >&2
  exit 2
fi

run_tmp="$(mktemp -d "${TMPDIR:-/tmp}/phage-uv-qmd.XXXXXX")"
cleanup() {
  rm -rf "$run_tmp"
}
trap cleanup EXIT

extracted_r="$run_tmp/$(basename "${notebook%.qmd}").R"
Rscript -e '
args <- commandArgs(trailingOnly = TRUE)
if (!requireNamespace("knitr", quietly = TRUE)) {
  stop("The knitr package is required to execute Quarto notebooks", call. = FALSE)
}
invisible(knitr::purl(args[[1L]], output = args[[2L]], quiet = TRUE))
' "$notebook" "$extracted_r"

(
  cd "$repo_root"
  PHAGE_UV_NOTEBOOK_PATH="$notebook" Rscript "$extracted_r" "$@"
)
