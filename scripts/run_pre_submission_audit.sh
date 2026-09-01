#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd "${script_dir}/.." && pwd)
cd "${repo_root}"

if [[ -n "${QUARTO_BIN:-}" ]]; then
  quarto_bin="${QUARTO_BIN}"
elif command -v quarto >/dev/null 2>&1; then
  quarto_bin=$(command -v quarto)
elif [[ -x /Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto ]]; then
  quarto_bin=/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto
else
  printf 'Quarto was not found on PATH or in the RStudio application bundle.\n' >&2
  exit 1
fi

render_root=$(mktemp -d /private/tmp/phage-uv-pre-submission-audit.XXXXXX)
notebook_root="${render_root}/notebooks"
mkdir -p "${notebook_root}"

printf 'Running manifest and manuscript smoke checks...\n'
bash scripts/validate_manifests.sh

printf '\nRunning complete R test inventory...\n'
for test_file in \
  tests/test_full_de_interpretation.R \
  tests/test_full_transcriptome_edger.R \
  tests/test_host_phage_network_figure.R \
  tests/test_manuscript_figure_candidates.R \
  tests/test_manuscript_registry.R \
  tests/test_taxonomic_resolution_exploration.R \
  tests/test_taxonomic_timeseries_layouts.R
do
  printf 'RUN %s\n' "${test_file}"
  Rscript "${test_file}"
done

printf '\nStructure-rendering all canonical Quarto notebooks...\n'
"${quarto_bin}" --version
notebook_count=0
for notebook in scripts/*.qmd; do
  staged_notebook="${notebook_root}/$(basename "${notebook}")"
  cp "${notebook}" "${staged_notebook}"
  "${quarto_bin}" render "${staged_notebook}" \
    --no-execute \
    --to gfm \
    --output-dir "${render_root}"
  notebook_count=$((notebook_count + 1))
done

if [[ "${notebook_count}" -ne 21 ]]; then
  printf 'Expected 21 Quarto notebooks, found %s.\n' "${notebook_count}" >&2
  exit 1
fi

printf '\nBuilding manuscript review artifact...\n'
pandoc manuscript/manuscript_skeleton.md \
  --bibliography=manuscript/references.bib \
  -o "${render_root}/phage_uv_manuscript_review.docx"

printf '\nChecking repository hygiene...\n'
git diff --check
if [[ -e Rplots.pdf ]]; then
  printf 'Unexpected root-level Rplots.pdf was generated.\n' >&2
  exit 1
fi
if [[ -e scripts/.gitignore || -d scripts/.quarto ]] || \
    find scripts -maxdepth 1 -type d -name '*_files' -print -quit | grep -q .; then
  printf 'Quarto generated source-adjacent artifacts under scripts/.\n' >&2
  exit 1
fi

printf '\nPre-submission audit passed. Temporary renders: %s\n' "${render_root}"
