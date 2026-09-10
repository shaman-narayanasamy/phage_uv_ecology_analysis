# Figures 2 and 3: publication-size replacements

Status: visually verified vector masters and verified native image suggestions
in Google Doc v2. No prose, caption, statistical result or panel allocation
changed. Author acceptance remains outstanding.

## Source and scientific preservation

Source: `scripts/build_manuscript_figure_candidates.qmd NEW_OUTPUT --publication-size`.
The historical default remains unchanged. This mode reads the existing MDS
table from `manuscript_figure_revision_2026-09-09`; it does not recompute
ordination, TMM or model fits. Seven used data inputs have recorded sizes and
MD5 hashes; layout metadata records the notebook hash and R version.

Four tables are byte-identical to the prior build: `mds_coordinates.tsv`,
`figure_summary.tsv`, `functional_condition_panel.tsv` and
`top_mag_condition_panel.tsv`. The tested-feature count (361907), FDR count
(7703), FDR-plus-effect-size count (7699), supported MAG directions (75/100),
functional categories and selected MAGs are unchanged.

## Vector masters

Directory: `derived/manuscript_figures_publication_2026-09-09-v2/figures/`.

- Figure 2: `global-transcriptome-structure.pdf`, 180 x 100 mm, 2458754 bytes,
  SHA256 `fe5cc57c34ad6d57f862791a3906d53b50cd68cb34b29d025915500d6c5e99bb`.
- Figure 3: `functional-organism-restructuring.pdf`, 180 x 195 mm, 31336 bytes,
  SHA256 `71a020b020d298d153b681145706715380e467b21b4a441ca6ad7c0421914492`.

Both are vector-only, with embedded Helvetica fonts and minimum 6.5 pt text.
Figure 2 has dark cycle labels, separate legend rows and visible colour keys.
Figure 3 has a compact signed-FDR axis label, horizontal count-panel labels,
and the exact SOS FDR printed left of its point. The first build clipped that
FDR annotation; it is preserved as an intermediate, not the current master.
The final full-page renders at 1063 pixels width show no clipped or overlapping
labels. `tests/test_transcriptome_publication_figures.py` passes source-byte,
input-hash, physical-size, font-embedding, text-boundary and content checks.
These are provisional 180 mm editorial layouts, not journal certification.

## Live replacement and verification

Readback `20260909T162818Z` passes all 131 targeted checks, with 216 suggested
text runs and ten original Zotero metadata names. The complete plain-text
accepted-suggestions preview is byte-identical to the immediate pre-change
snapshot `20260909T162353Z`. No suggestions were accepted or rejected.

- Figure 2 Drive PNG: `1bIuJV2o3RnTsTMOqvO1ZuUbWjQaCnsf5`, 429873 bytes;
  MD5 `cc583ca857c0c82174968b1d65a8e335`; SHA256
  `5b38f2fea70b0fdc30e864ddb7aa39993292e70105043727dbc0a456ef42c007`.
  Inline ID `kix.n0142ci4hhfh`, empty crop, ratio 1.79965.
- Figure 3 Drive PNG: `1pxPD5DCmfm5TkvHmLBOeASi8zC34Wzxs`, 367953 bytes;
  MD5 `088bf7d212614df2107e9877c272496b`; SHA256
  `c919262a8f059a6f5c8816197437165ca9dba45c848daee249034477fb83f71a`.
  Inline ID `kix.hvvl8d734x9c`, empty crop, ratio 0.92236.

Both uploads remain in the existing Figure previews folder
`1Ky-L8pSiLeuworOPifw-EdCRnNnz2_4J`; sharing is unchanged. Receipts are in the
author-review root under `transcriptome_publication_preview_upload_receipt.json`
and `organism_publication_preview_upload_receipt.json`. Native Reset image
removed inherited cropping. All 15 image identities/order and the stable
properties of the other 13 images are unchanged. Captions remain beneath their
images and in the separate legends, in Normal text. Old versions are preserved.
