# Hand-authored figure sources

Vector sources for the schematic figures that are drawn, not computed. Each SVG is the
single source of truth for its figure: a human edits it in Illustrator or Inkscape (group
ids appear as layer names), an agent edits it as text. Rendering to PDF and PNG is done by
`manuscript/build_schematic_figures.qmd`, which also writes checksums.

| File | Figure | Status |
|---|---|---|
| `workflow_metro.svg` | Integrated multi-omics workflow (metro map) | v21, 2026-09-24: author's own Inkscape edit of v20 (Inkscape-saved SVG; `workflow_metro-SN.svg` is the identical file as saved by the author). v20 and earlier: author markups v15 to v18 applied, legend in the lower-left triangle, map stretched 1.25x, junction faults fixed, cross-assay merge relaid at the metagenome level; record in `notes/handoff-2026-09-24-metro-v14-corrected-return.md`. Content as v12 per `notes/handoff-2026-09-16-subway-votu-crispr-update.md` plus the modelling and candidate-suppression branches |
| `experimental_setup_reactor.svg` | Setup panel: AnMBR, two membranes in parallel, fouling trigger | v2, 2026-09-10 |
| `experimental_setup_cleaning-event.svg` | Setup panel: one cleaning event, Initial and Backflush fractions | v2, 2026-09-10 |
| `experimental_setup_sampling-design.svg` | Setup panel: 2 x 3 x 2 design, three measurements per sample | v2, 2026-09-10 |
| `experimental_setup_sampling-tmp.svg` | Setup panel: sampling design aligned on the day axis above the TMP plot, with the sequencing runs produced per sample (circle = initial, triangle = backflush) | v1, 2026-09-10; candidate replacement for the separate sampling-design and TMP panels |
| `experimental_setup_tmp.svg` | Setup panel: TMP over the three sampled cycles (poster Fig. 2C, recoloured raster) | v2, 2026-09-10; vector redraw pending TMP data |
| `experimental_setup_panel_d_poster_fig2c.png` | Source raster for panel D (poster Fig. 2C, Myshkevych et al.) | placeholder until the TMP series is exported from the Google Sheet and panel D is redrawn as vector |

The four setup panels carry no panel letters or titles, on purpose: the plan is to compose them
with `workflow_metro.svg` into one figure spanning the wet lab and the analysis workflow, with
letters and titles assigned at composition. Their coordinates are kept from the v1 combined
drawing, so they re-assemble by translation. The v1 combined drawing is retained only as
history in `PRJEB79569/derived/experimental_setup_v1/`.

## Print size and Inkscape

`workflow_metro.svg` declares its own physical size, 247 x 126.8 mm, i.e. a full-page
**landscape** figure. `build_schematic_figures.qmd` reads that and gives the exported PDF a
page box of exactly that size, so the vector PDF drops into the manuscript at its intended
scale. Panels that declare no mm size still export at a pixel-derived page, unchanged.

At 247 mm the smallest labels print at about 5.3 pt, station names about 5.9 pt and endpoint
names about 6.5 pt. Printing narrower than about 200 mm pushes the small labels below 5 pt;
cut label text before cutting width.

The file opens directly in Inkscape. Structural groups are declared as Inkscape layers
(Drawing, Routes, Stations, Labels, Viral tools card, Cleaning-score input, Legend, Origin).
Text is live text, never outlines. Colours and type sizes live once in the `<style>` block, so
editing a value there restyles every element of that class; restyling one object in the
Inkscape GUI writes an inline style that overrides the class for that object only.

Drawing conventions: `~/Work/knowledgebase/sops/workflow-metro-schematic.md`. Route colours,
condition colours and typography are shared between the two SVGs; condition colours come
from `R/figure_style.R`.
