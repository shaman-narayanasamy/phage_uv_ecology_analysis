# Hand-authored figure sources

Vector sources for the schematic figures that are drawn, not computed. Each SVG is the
single source of truth for its figure: a human edits it in Illustrator or Inkscape (group
ids appear as layer names), an agent edits it as text. Rendering to PDF and PNG is done by
`manuscript/build_schematic_figures.qmd`, which also writes checksums.

| File | Figure | Status |
|---|---|---|
| `workflow_metro.svg` | Integrated multi-omics workflow (metro map) | v11 draft, 2026-09-09; supersedes the R-grid builder `scripts/build_workflow_metro.qmd` for review |
| `experimental_setup_reactor.svg` | Setup panel: AnMBR, two membranes in series, fouling trigger | v2, 2026-09-10 |
| `experimental_setup_cleaning-event.svg` | Setup panel: one cleaning event, Initial and Backflush fractions | v2, 2026-09-10 |
| `experimental_setup_sampling-design.svg` | Setup panel: 2 x 3 x 2 design, three measurements per sample | v2, 2026-09-10 |
| `experimental_setup_tmp.svg` | Setup panel: TMP over the three sampled cycles (poster Fig. 2C, recoloured raster) | v2, 2026-09-10; vector redraw pending TMP data |
| `experimental_setup_panel_d_poster_fig2c.png` | Source raster for panel D (poster Fig. 2C, Myshkevych et al.) | placeholder until the TMP series is exported from the Google Sheet and panel D is redrawn as vector |

The four setup panels carry no panel letters or titles, on purpose: the plan is to compose them
with `workflow_metro.svg` into one figure spanning the wet lab and the analysis workflow, with
letters and titles assigned at composition. Their coordinates are kept from the v1 combined
drawing, so they re-assemble by translation. The v1 combined drawing is retained only as
history in `PRJEB79569/derived/experimental_setup_v1/`.

Drawing conventions: `~/Work/knowledgebase/sops/workflow-metro-schematic.md`. Route colours,
condition colours and typography are shared between the two SVGs; condition colours come
from `R/figure_style.R`.
