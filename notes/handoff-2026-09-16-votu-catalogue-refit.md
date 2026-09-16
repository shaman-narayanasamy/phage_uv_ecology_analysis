# Catalogue-aligned vOTU abundance refit

User requested this as the main task, with remaining Zotero references and Methods
integration in parallel. Figure/caption/Results reconciliation explicitly deferred.

## Completed and validated

Canonical code: `analysis/community_cycle_models.qmd`, new opt-in
`--catalogue-aligned` flag. Default remains archived 616-member scope for exact
historical reproducibility. New mode uses CheckV high-quality representatives
with viral genes, without requiring Cenote annotation, and checks exact set
equality against the 634-member composition catalogue.

Data-root-relative outputs (root is `PRJEB79569/derived/`):

- `community_cycle_models_catalogue_aligned_2026-09-16-v1/`: new models, tables,
  diagnostics, source snapshot, input/output SHA256 manifests.
- `votu_catalogue_refit_comparison_2026-09-16-v1/`: per-feature old/new comparisons,
  added-feature filter, size-factor comparison, summary and source/checksums.

All 18 previously omitted vOTUs pass the unchanged count filter: 578/634 retained,
compared with 560/616 previously. Main treatment Wald FDR<0.05: zero. Joint
treatment-by-cycle LRT FDR<0.05: the same four vOTUs. No gains or losses.

| vOTU | Updated adjusted p |
|---|---:|
| CI3_coassembly_megahit_CI3_contig_k141_1679835 | 0.03010160 |
| TBF3_coassembly_megahit_TBF3_contig_k141_2493445 | 0.000001563386 |
| TI3_coassembly_megahit_TI3_contig_k141_1734682 | 0.000008991900 |
| TI3_coassembly_megahit_TI3_contig_k141_922117 | 0.001261621 |

`tests/test_community_cycle_models.R` PASS for both communities: hashes, sample
mapping/filter, design ranks, convergence, BH, chi-square p, repeated LRT.
`analysis/votu_catalogue_refit_comparison.qmd` PASS: all shared raw viral counts
identical; MAG counts, main/joint results and size factors unchanged (1 main and
1 interaction hit). Models/design/filter/BH conventions unchanged.

## Adoption boundary

Local `manuscript/methods_complete_2026-09-16.qmd` now records 634 eligible/578
retained. Archived outputs untouched. These are the new catalogue-aligned
abundance-model outputs; downstream figures and Results still use their earlier
sources and require a later explicit reconciliation pass. Do not claim they
were refreshed. No live Google Doc integration: recorded browser policy block
must not be bypassed through another surface. No commit/push requested.

## MinCED clarification

MinCED detects CRISPR arrays in host MAG FASTAs in the separate code repository
`/Users/shaman.narayanasamy/Work/repositories/host_phage_linking/rules/minced.smk`.
`rules/spacepharer_genomes.smk` supplies MinCED and PILER-CR outputs jointly to
SpacePHARER against viral sequences. It supports host linking, not abundance
estimation or differential-expression modelling.

## Background manuscript work

See `notes/handoff-2026-09-16-complete-methods-and-zotero.md` and the background
agent's completion note for Zotero import/integration status; do not infer
completion from this refit. Keep user edits and separate assistant identity.

## Suggested skills

- `handoff` for continuation updates.
- `computer-use` for supported Zotero import, never for bypassing the Doc block.
- `edit-article` for Methods integration under the author's voice conventions.
