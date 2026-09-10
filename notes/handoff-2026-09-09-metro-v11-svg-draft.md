# Workflow metro figure: SVG restyle draft (v11)

## What happened

On 2026-09-09 the author asked for the accepted `workflow_metro_v10` figure to be redrawn
in the visual grammar of his cGAS-STING pipeline schematic
(`~/Documents/Projects/cGAS-STING-working/figures/pipeline_schematic_draft_v3.svg`).
A separate session produced a hand-authored SVG, not a change to the R builder.
The author reviewed three iterations in the same session and directed the colour
changes listed below. He said more changes are coming; treat v11 as a live draft.

Output: `PRJEB79569/derived/workflow_metro_v11_svg_draft/` (SVG source, vector PDF, PNG,
README). The data folder is outside git. Nothing in this checkout was committed; this note
is untracked.

## Content

Identical to v10: every station, route, count and caveat in the accepted legend
(`manuscript/figure_legends.md`) is present. The legend text does not need to change,
with one exception noted under open items (coassembly as a route).

## Style

Follows the reference: no baked-in title or stage bands, 7 px continuous routes with
45-degree bends, pill stations (tall pill = shared station), rotated labels on the top
line, one dashed resource card (viral discovery tools), bottom legend block.

One deliberate crossing remains: the MT read bypass passes under the host-link route at
x=1280 (white casing marks the underpass). The same crossing existed in v10.

## Author-directed colour decisions (2026-09-09, in order)

1. 16S amplicons light blue; metagenomes the darker blue previously used for
   metatranscriptomes.
2. Metatranscriptomes a warm "activity" colour, distinct from the viral route. Session
   chose orange-red #DF6A2C; the author has not yet confirmed or rejected it (he asked to
   hold that question while further changes arrive).
3. Viral sequences purple. Session chose #7B4FA6, one step away from the Phage-UV
   condition purple #7E57C2 so the two meanings stay apart. Author has not commented.
4. Coassembly as its own route in teal #159A9C: MG and MT read routes end at the shared
   coassembly station; the teal route carries bins, dereplicated MAGs and the catalogue
   entry, plus the MAG spur into the MAG-only mapping station.

## Editing the figure

The SVG is the single editable source for both humans and agents:

- `id` attributes name every layer and element (`route-metagenome`, `st-catalogue`,
  `lbl-mapping`). Illustrator and Inkscape show them as layer names.
- Colours live once in the `<style>` block and propagate to routes, bypass labels and
  legend swatches.
- Drawing rules (45-degree bends, pill geometry, 130 px headroom offset) are in the
  comment block at the top of the file.

Render check and export (no `rsvg-convert`; `pdftocairo` exists but Chrome keeps live text):

```sh
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
# wrap.html: <img src="study-analysis-workflow.svg"> sized 1960x1130, zero margin
"$CHROME" --headless=new --disable-gpu --hide-scrollbars --window-size=1960,1130 \
  --screenshot=study-analysis-workflow.png "file://$PWD/wrap.html"
# wrap_pdf.html: same, plus @page { size: 1960px 1130px; margin: 0 }
"$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
  --print-to-pdf=study-analysis-workflow.pdf "file://$PWD/wrap_pdf.html"
```

## Open items for the next agent

1. Await the author's remaining changes; keep iterating on the SVG in place (new folder
   per accepted version, as with v1 to v10).
2. Confirm or replace the two unconfirmed colours (MT orange-red, viral purple).
3. Decide whether the SVG becomes the source of truth for this figure or whether
   `scripts/build_workflow_metro.qmd` is ported. The author polishes winning drafts in
   Illustrator, so the SVG is the practical source; the R builder would then be
   superseded and the Quarto-entrypoint test adjusted.
4. If accepted: add the folder to `manuscript/accepted_figure_inventory.tsv`; note the
   absence of a baked-in title in the figure plan; regenerate
   `output_checksums.md5.tsv`; copy `workflow_nodes.tsv` and `workflow_edges.tsv` from
   v10 (graph unchanged). Consider one legend sentence saying coassembly products are
   drawn as their own route.
5. Google Doc and manuscript prose untouched.

## Experimental setup figure (added 2026-09-10)

The author asked for a companion figure of the experimental setup. Draft v1 is in
`PRJEB79569/derived/experimental_setup_v1/` (SVG source, PDF, PNG, README). Same
typography and omics colours as the metro map; condition colours from `R/figure_style.R`.
Content taken from Myshkevych et al. 2025 methods 2.1 and 2.2 and the manuscript Methods.

Open questions put to the author with the draft:
1. Cycle numbering: the 2025 paper analysed samples from its 2nd, 3rd and 4th cleaning
   rounds; the manuscript calls them cycles 1, 2, 3. The figure follows the manuscript.
   Confirm the mapping before the legend is written.
2. Whether every one of the 12 samples has 16S cDNA data (the figure assumes yes).
3. Whether reactor operating parameters (HRT, SRT, flux, COD) belong in the figure or
   only in Methods.
4. Panel D (TMP over the three cycles, poster Fig. 2C) was added on 2026-09-10 as a raster
   placeholder. The data sit in a private Google Sheet (id in the v1 README); the author
   was asked for a CSV export so the panel can be redrawn as vector in the figure palette.
   The poster's own axis (cleaning at days 1, 59, 120; cycles labelled 1 to 3) matches the
   manuscript's cycle numbering, which partly answers open question 1.

## Repository integration and Drive previews (2026-09-10)

- SVG sources now live in the repository: `manuscript/figure_sources/workflow_metro.svg`,
  `manuscript/figure_sources/experimental_setup.svg`, plus the poster raster behind panel D.
  See `manuscript/figure_sources/README.md`.
- Builder: `manuscript/build_schematic_figures.qmd` renders both SVGs to PDF and PNG through
  headless Chrome and writes `output_checksums.md5.tsv`. Verified with one real run via
  `scripts/run_qmd.sh` into a scratch directory (6 files + checksums). It sits under
  `manuscript/` rather than `scripts/` on purpose: `tests/test_quarto_entrypoints.R` pins the
  25 scripts and the "25" count in the docs, and adding a 26th there is a decision for the
  agent that owns that test.
- Nothing committed; the checkout was already dirty on
  `feature/prjeb79569-cluster-analysis-ingest`. The `~/Work/repositories/phage_uv_ecology_analysis`
  clone is a stale one-commit stub; this checkout is the live one.
- Previews uploaded to the manuscript Google Drive, folder "Figure previews", following the
  existing naming: `PRJEB79569 workflow metro v11 2026-09-10.png` and
  `PRJEB79569 experimental setup v1 2026-09-10.png`.
- Panel D of the setup figure is the poster raster recoloured to the figure palette; it still
  needs a vector redraw once the TMP sheet is exported.

## Setup figure split into panels (2026-09-10, v2)

The author asked for the setup figure as four separate panels without headers, to be
composed with the metro map into one figure covering wet lab and analysis. Sources are now
`manuscript/figure_sources/experimental_setup_{reactor,cleaning-event,sampling-design,tmp}.svg`;
the combined `experimental_setup.svg` was removed from sources (v1 history stays in
`PRJEB79569/derived/experimental_setup_v1/`). The builder renders all five schematics;
outputs for this round are in `PRJEB79569/derived/experimental_setup_v2/` (real run, with
checksums). Composition with the metro map has not been started; the metro map itself is
unchanged. Previews of the panels were not uploaded to Drive (not requested this round).

## Integrated figure (2026-09-10, v1)

The author asked to combine the four wet-lab panels with the metro map, wet lab on top.
`manuscript/build_schematic_figures.qmd` now composes `integrated-wetlab-workflow.svg`
(2000 x 2160): row 1 reactor (A) and cleaning event (B); row 2 sampling design (C) and TMP
(D); metro map (E) below. Panels are nested unchanged as inner <svg> elements and letters
are added at composition; edit the panel sources, not the composite. Output with checksums:
`PRJEB79569/derived/integrated_figure_v1/`. Not yet in the figure inventory or legends;
the TMP panel is still the recoloured poster raster.
Preview uploaded to Drive "Figure previews" as `PRJEB79569 integrated wetlab workflow v1 2026-09-10.png`
(verified after reload). Draft caption for the integrated figure was given to the author in chat
on 2026-09-10; not yet added to `manuscript/figure_legends.md`.
