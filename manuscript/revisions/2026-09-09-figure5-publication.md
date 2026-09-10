# Figure 5 publication-size replacement

Visual-only revision of the same coverage-qualified five-MAG population-genomic
panel. It does not identify DNA lesions, mutagenesis, adaptation or a replicated
treatment effect. The cluster grid, distance summary and focal pairwise matrix
are byte-identical to their frozen source tables.

## Files and reproducibility

Master: `derived/population_figure_publication_2026-09-09-v2/figures/population-genomic-heterogeneity.pdf`.
180 x 225 mm, 39,187 bytes, SHA256
`88025fb2963b9df807eb1b3715db8216f400d78df953c4f2734597dcd332a25d`.
The three stacked panels allow readable two-line organism labels. Fonts are
embedded, ordinary text is at least 6.5 pt, and the colour scale is vector-only.
Version 2 aligns panel C's letter with the left edge. The final full render was
visually inspected at 1063 pixels wide. Tests verify geometry, in-page text,
fonts, required labels, all three input hashes and every output checksum.

```sh
bash scripts/run_qmd.sh scripts/build_remaining_manuscript_figures.qmd NEW_OUTPUT_DIRECTORY --population-publication
```

This mode reads only the three population inputs and refuses an existing output
directory. It does not run the five supplementary builders, modify the frozen
baseline, recompute a model or create a new environment. The default six-figure
behavior is preserved. Earlier outputs and the intermediate v1 remain intact.

## Native suggested preview

Preview: `derived/manuscript_author_review_2026-09-08/figure_previews/population-publication-v2.png`.
2160 x 2700 pixels, 247,861 bytes, SHA256
`ddcc50d54055d76da17c117421af2ebb5d1013b68a78600aefff8c0fc3aea0bd`.
Drive file `1wmuZhpRki6ZWM9PFxjYFuXU2pVvuvvwo` is in the existing Figure previews
folder. Server MD5 `5f0d1b4f61db3d65939d16d2ed04b091`, bytes and parent verified;
sharing unchanged. Receipt: `population_publication_preview_upload_receipt.json`
under the author-review root.

The existing inline image was replaced in native Suggesting mode, then reset
to remove inherited cropping. Baseline `api_review_verification_20260909T171152Z`
passed 135 checks; post-change `api_review_verification_20260909T171509Z` passes
138 checks. Inline ID `kix.14s0bq970wz6` is preserved; ratio 0.79932, empty crop.
All 15 image IDs/order and the other 14 stable image properties are unchanged.
The complete manuscript text is byte-identical, including the caption. The
caption remains immediately below the correct image in Normal text. No
suggestions or comments were accepted/rejected; 216 suggested text runs and
ten original Zotero metadata names remain.

Aggregate size audit v5 screens all 15 current masters; all five main figures
pass the provisional 180 mm/6 pt screen. S1-S10 remain flagged. This does not
complete the full publication-quality suite, Zotero integration, review line
numbering or the journal-adapted separate companion. The next legend pass also
needs explicit definitions of sample shorthand, cluster IDs and missing cells.
