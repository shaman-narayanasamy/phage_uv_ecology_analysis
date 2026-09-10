# Figure 4 publication-size replacement

This visual-only revision preserves the descriptive recurrence analysis. It
does not refit expression models, alter thresholds, reselect candidates or
support a causal DNA-damage claim. One membrane per condition remains the
binding design limitation.

## Master and checks

- Master: `derived/recurrence_figure_publication_2026-09-09-v2/figures/recurrent-gene-structure.pdf`.
- Size: 180 x 200 mm; 41,136 bytes.
- SHA256: `9e3a9da283773351638633e352e60c16829062e79ac79a9860e428e97b08d122`.
- Embedded Helvetica fonts, minimum 6.5 pt ordinary text, vector-only content.
- Version 1 is an intermediate with misaligned upper panels and a raster
  colour scale. Version 2 isolates the upper layout and draws the scale as
  vector rectangles. The final PNG was visually inspected at 1063 pixels wide.
- All four frozen recurrence tables are byte-identical: selection funnel,
  direction concordance, selected genes and six-cell effects. Input hashes,
  notebook hash and output checksums are recorded. Tests pass.

Reproduce from the repository root, using a new destination:

```sh
bash scripts/run_qmd.sh scripts/build_recurrent_gene_candidate.qmd NEW_OUTPUT_DIRECTORY --publication-size
```

The default historical builder is preserved. Publication mode refuses an
existing destination and does not modify the baseline candidate registry.

## Live replacement

The 2160 x 2400 preview is
`derived/manuscript_author_review_2026-09-08/figure_previews/recurrence-publication-v2.png`:
401,250 bytes, SHA256
`8b6535bed93ed280c4f870574c6b0656de87830244c6858441945d1395195f37`.
Drive ID `1x7ZHSEygfFPfIOd-7dSr81MXplNuuJdj`; server MD5
`96690fef50e3e0cb8217046b96321187`, bytes and Figure previews parent were verified.
Sharing was not changed. Receipt is `recurrence_publication_preview_upload_receipt.json`
under the author-review root. Earlier files remain intact.

Only the existing Figure 4 image was replaced in native Suggesting mode, then
reset to remove inherited cropping. Immediate read-only baseline
`api_review_verification_20260909T164254Z` was compared with
`api_review_verification_20260909T164651Z`. All checks pass: 15 image IDs/order
preserved; 14 other images' stable properties unchanged; Figure 4 source, crop,
aspect ratio and caption position verified. Complete manuscript prose is
byte-identical. There remain 216 suggested text runs and ten original Zotero
metadata names. No suggestions or author comments were accepted/rejected.

## Delivery queue

All four author requests are explicit unchecked gates in
`docs/manuscript_figure_plan.md`: Zotero-managed live citations/bibliography,
verified visible review line numbers, final-size main/supplementary figures,
and a separate versioned companion adapted after journal choice. Figures 1-4
pass the provisional size check; this does not complete the whole figure suite
or the manuscript quality goal. Next is Figure 5, then S1-S10 and the companion.
