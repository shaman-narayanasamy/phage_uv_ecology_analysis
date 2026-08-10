# Full-DE interpretation plan

Date frozen: 2026-08-10

This plan governs GitHub issue #23. It was recorded before inspecting category-
or MAG-level enrichment results. The only inferential input is the complete
tested-feature output from GitHub #22. The subset-first expression workflows in
`docs/expression_quarantine.md` remain prohibited.

## Universe and joins

- The competitive test universe is all 361,907 features retained by the
  transcriptome-wide edgeR filter.
- MAG and gene annotations come from the post-model join in #22.
- MAG taxonomy comes from the staged CAT/BAT GTDB classification table.
- UV/stress membership comes from the pre-existing signature-hit table, joined
  by `MAG_ID` and `gene_id` and de-duplicated within category.
- Unannotated, non-MAG, unmatched, and multiply assigned features remain
  visible in audits. They are not silently removed from the test universe.

## Frozen functional family

The eight categories in `resources/full_de_category_registry.tsv` are the only
functional family tested in this pass. Their definitions predate the #22
result inspection and are inherited from
`resources/uv_resistance_signatures.tsv`. Categories may overlap. Any future
functional family must be versioned separately and tested as a new family.

## Gene-set tests

- One-degree-of-freedom edgeR quasi-likelihood results are converted to signed
  statistics as `sign(logFC) * sqrt(F)`.
- Each coefficient is tested with rank-based `limma::cameraPR`, using the
  complete tested-feature universe, directional tests, and the documented
  preset inter-gene correlation of 0.01.
- The two-degree-of-freedom condition-by-cycle omnibus uses `sqrt(F)` with a
  rank-based non-directional `cameraPR` test.
- Categories require at least 10 tested features. BH adjustment is applied
  across the eight frozen categories separately for each coefficient family.
- A category is not called a mechanism. Directional enrichment means its genes
  are collectively ranked above or below the rest of this tested universe.

## Organism-resolved summaries

- MAG sets require at least 20 tested genes and median detection in at least
  six of twelve physical samples.
- Coherent MAG-level direction is assessed with the same rank-based
  competitive test, with BH correction across eligible MAGs per coefficient.
- Tables retain tested-gene counts, total counts, median mean CPM, median sample
  detection, median logFC, sign fractions, taxonomy, and annotation coverage.
- MAG ranking is descriptive for this two-membrane system and is not a causal
  treatment screen.

## Six-cell recurrence

For descriptive consistency only, TMM-normalized log2 CPM values are calculated
from the collapsed #22 raw-count matrix using its recorded effective library
sizes and a prior count of 0.5. For each feature, treatment-minus-control
differences are calculated separately for initial and backflush samples in
cycles 1, 2, and 3.

- A direction is recurrent when at least five of six cell differences share a
  sign and the absolute median cell difference is at least 1 log2 CPM.
- Initial/backflush phase concordance is counted across the three cycles.
- Cycle concordance is recorded separately within each phase.
- These are descriptive repeatability labels, not additional hypothesis tests.
  A single membrane represents each condition.

## Candidate outputs

Figures remain unnumbered. Gene candidates require condition FDR below 0.05,
absolute condition logFC of at least 1, detection in at least six samples, a
non-empty annotation, and recurrent six-cell direction. MAG figures show the
predeclared evidence metrics rather than selecting solely on FDR. All figures
use `R/figure_style.R`, and negative or heterogeneous findings remain visible.
