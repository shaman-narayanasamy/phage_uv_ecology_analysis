# Publication-size figure audit

2026-09-09. This addresses the author's required publication-quality figures.
Native-size PDF inspection does not establish readability after reduction.
The current editorial screen uses 180 mm width and 6 pt minimum ordinary text;
these are provisional working targets, not a claim about journal requirements.

## Current checkpoint

The current aggregate is
`derived/figure_publication_size_audit_2026-09-09-v9/audit.json`: all 15 sources
are native 180 mm masters at minimum 6.5 pt. S10 now uses
`derived/16s_figure_publication_2026-09-09-v2/`, 180 x 265 mm; eight frozen
tables unchanged, rendered layout and native suggested preview verified.
Readback `20260909T184447Z` passes 156 checks. Companion v3 incorporates all
ten current supplementary plates, with all 14 pages visually checked and six
Drive files verified. The historical checkpoints below describe prior states;
their pending-rebuild notes are superseded by this checkpoint. Journal-specific
formatting and standalone legend completeness remain separate gates.

S8/S9 masters are under `derived/network_figure_publication_2026-09-09-v2/`
and `derived/abundance_figure_publication_2026-09-09-v2/`, respectively.
180 x 260/180 mm, embedded fonts, vector-only and verified bounds. Thirteen
frozen tables are byte-identical; all final renders inspected. Native suggested
replacements verified at `20260909T183356Z` (156 checks) with unchanged text,
captions and 13 other images. Companion v2 remains unchanged pending S10.

S6/S7 are in `derived/taxonomic_figures_publication_2026-09-09-v3/figures/` at
180 x 250/230 mm. Both are embedded-font vector masters with verified text
bounds and unchanged source tables/trees. S7 retains all 18 selected labels,
reflowed horizontally. Visual inspection and both source/PDF tests pass.
Live native replacements are verified at `20260909T182253Z` (156 checks),
preserving complete prose, captions, all IDs/order and 13 non-target images.
Companion v2 remains unchanged. Full provenance is in the S6/S7 revision note.

S1-S5 are in `derived/supplementary_figures_publication_2026-09-09-v2/figures/`.
Heights are 165, 175, 240, 170 and 245 mm, respectively. S3 uses four stacked
coefficient panels to retain readable category labels; S5 uses a two-column,
three-row layout for its five matrices. All five have embedded fonts, vector
content and in-page text. Five frozen tables are unchanged. Tests also check
the complete deterministic interaction display selections and their original
values, not just significant counts. All five v1 renders were inspected; v2
corrects S1's phase legend order, with S2-S5 rendered PNGs byte-identical to
the already inspected versions. S1 v2 was inspected separately.

Live Google Docs replacements are verified at `20260909T180753Z` (153 checks),
with unchanged complete text, captions, image IDs/order and non-target images.
The compiled companion update is still pending. The current audit overrides S1-S5 master paths without editing the
released companion's source specification. Do not conflate local master QA,
preview upload, live insertion and companion release.

Figure 5's current master is
`derived/population_figure_publication_2026-09-09-v2/figures/population-genomic-heterogeneity.pdf`.
It is 180 x 225 mm, with three vertically arranged panels, two-line MAG labels,
embedded fonts and a vector colour scale. No text lies outside the page.
The final 1063-pixel-wide render was inspected; the three source tables match
the frozen original byte-for-byte. Version 2 aligns the C panel letter with
the left edge. `tests/test_population_publication_figure.py` verifies geometry,
fonts, required labels, input hashes and output checksums. Live readback
`20260909T171509Z` verifies its source/crop/ratio and unchanged caption, prose
and 14 other images. Earlier versions remain preserved.

Figure 4's current master is
`derived/recurrence_figure_publication_2026-09-09-v2/figures/recurrent-gene-structure.pdf`.
At 180 x 200 mm it has embedded fonts, no raster objects, and no text outside
the page. Its rendered 1063-pixel-wide preview was inspected. The first build
misaligned the upper panels and rasterised the colour scale; v2 fixes both.
The four recurrence source tables remain byte-identical to the frozen baseline.
`tests/test_recurrence_publication_figure.py` also verifies provenance, required
counts and output checksums. Live readback `20260909T164651Z` confirms the new
uncropped image, unchanged caption and complete prose, and 14 unchanged images.
The old PDF and intermediate v1 are preserved, not current replacements.

## Historical baseline evidence

`manuscript/figure_publication_size_audit.qmd` inspected all 15 current source
masters and the new Figure 1 candidate. Historical baseline output is
`PRJEB79569/derived/figure_publication_size_audit_2026-09-09-v2/audit.json`.
It records each PDF's hash, dimensions, font report and text-size distribution.
V2 correctly handles 90-degree axis-label text: pdfminer's reported glyph
advance is not its font size. V1's smallest-size values are superseded.

| Figure | Original width (mm) | Minimum text at 180 mm (pt) | Median (pt) |
|---|---:|---:|---:|
| 1 | 419.1 | 2.58 | 3.01 |
| 2 | 266.7 | 4.72 | 5.40 |
| 3 | 279.4 | 4.51 | 4.51 |
| 4 | 279.4 | 3.87 | 4.51 |
| 5 | 279.4 | 4.33 | 4.51 |
| S1 | 266.7 | 4.53 | 4.90 |
| S2 | 266.7 | 4.72 | 5.40 |
| S3 | 266.7 | 4.72 | 4.72 |
| S4 | 266.7 | 4.72 | 5.22 |
| S5 | 279.4 | 3.49 | 3.87 |
| S6 | 297.0 | 3.28 | 3.64 |
| S7 | 355.6 | 1.37 | 3.12 |
| S8 | 297.0 | 3.64 | 4.24 |
| S9 | 304.8 | 3.54 | 4.13 |
| S10 | 419.1 | 2.58 | 2.58 |
| Figure 1 candidate v4 | 180.0 | 6.50 | 6.50 |

Every prior master triggers the screen. This is not a blanket finding that
every label is unreadable: subscripts, intended publication size and the
actual layout require inspection. All remaining plates require that final-size
review and likely visual-only rebuilding. The supplementary companion's
previous native-plate review is not invalidated, but is not journal-size QA.

## Figure 1 replacement candidate

`derived/community_figure_publication_2026-09-09-v4/figures/community-structure-figure-one.pdf`
is a new 180 x 200 mm vector plate. All text is at least 6.5 pt and both fonts
are embedded. The five panels, stacked full-denominator profiles, fixed colours
and statistics are retained. The family legend spans four columns below the
MAG row, using family names without redundant phylum prefixes. Control is
above phage-UV throughout; cycle labels are dark and separated from points.
Statistics have reserved space above the ordination points. The baked-in title
and caption were removed; the full caption belongs below the figure.

At 1063 pixels wide (180 mm at 150 dpi), visual inspection found no clipped
labels or overprinted cycle numbers. It is now the live Google Docs preview
replacement as an unaccepted native suggestion, verified at `20260909T161333Z`.
Both captions match the revision payload, the image is uncropped, and all 14
other image properties are unchanged. The Doc scales previews to its body
width; publication masters remain the native 180 mm PDFs, not Google previews.
This is not an author-approved final figure.

The panel registry, numerical summary and input-provenance table are each
byte-identical to the original Figure 1 outputs. No model or composition
calculation changed. Existing Figure 1 tests and the new
`tests/test_community_publication_figure.py` pass. The latter checks physical
dimensions, font embedding, in-page text bounds, vector-only content and
unchanged statistics/source tables; it does not replace visual judgement.

Reproduce from the repository root with a new destination:

```sh
bash scripts/run_qmd.sh scripts/build_community_figure_one.qmd NEW_OUTPUT_DIRECTORY --publication-size
```

The default build remains the historical layout. The publication build uses
macOS Quartz for embedded fonts on this machine. Cairo reports availability
but fails to load missing X11 libraries; candidate v1 produced no PDF and is
not a deliverable. V2/v3 were intermediate layouts. The builder now explicitly
rejects missing/empty PDF output. Non-macOS fallback font embedding must be
verified before delivery. No dependencies were installed.

## Figures 2 and 3 completed at publication size

Current sources are in `derived/manuscript_figures_publication_2026-09-09-v2/`:
Figure 2 is 180 x 100 mm and Figure 3 is 180 x 195 mm. Both use embedded fonts
and minimum 6.5 pt text. Their full renders were inspected after correcting a
clipped FDR annotation in the first Figure 3 build. All four numerical panels
are byte-identical to the prior build; MDS was reused, not recomputed. Seven
used inputs have recorded MD5 hashes and the source notebook hash is recorded.
`tests/test_transcriptome_publication_figures.py` verifies these invariants.

Both previews are native image suggestions in Google Doc v2. Readback
`20260909T162818Z` verifies sources, uncropped ratios, all unchanged captions and
the other 13 images. Complete manuscript prose is unchanged against the
pre-change snapshot. Full provenance:
`manuscript/revisions/2026-09-09-figures2-3-publication.md`.

The aggregate size screen has been rerun as
`derived/figure_publication_size_audit_2026-09-09-v3/audit.json`, now using the
three live publication masters rather than their previous versions. Figures
1-3 pass the 6 pt screen. The table above records the historical baseline;
Figures 4-5 and S1-S10 still require publication-size review/rebuilding.

## Next actions

1. Figure 1 native replacement and both caption updates are verified; preserve
   that state while updating the remaining figures. Original Zotero metadata
   names are unchanged. Do not overwrite prior files.
2. Rebuild Figures 4-5 and S1-S10 at explicit physical sizes; preserve source
   values and labels. Dense taxonomy/network panels may need reflow, not
   simple scaling. Do not alter the separate agent's subway v11 source.
3. Version the supplementary companion after its plates are finalised.
4. Apply and verify the selected journal's actual size/font/export rules.
