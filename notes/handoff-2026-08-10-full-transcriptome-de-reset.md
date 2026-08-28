# Handoff: PRJEB79569 full-transcriptome DE reset

Status: superseded by `notes/handoff-2026-08-10-full-de-interpretation.md`.
Retain this file as #22 completion provenance; do not use its next-step section.

Date: 2026-08-10

This was the controlling handoff for the #22-to-#23 transition. Retain it as
completion provenance and use the superseding handoff for active work.

## Next-session objective

Begin GitHub issue #23: derive functional, taxonomic, and MAG-resolved views
from the complete GitHub #22 result universe. Do not rerun or use a preselected
functional-subset model as the inferential entry point.

## GitHub #22 completion record

The transcriptome-wide workflow completed and passed its synthetic end-to-end
test and project-scale output QA on 2026-08-10.

- entry point: `scripts/run_full_transcriptome_edger.qmd`;
- test: `tests/test_full_transcriptome_edger.R`;
- canonical output:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/full_transcriptome_de/`;
- 23 headerless run tables were audited and collapsed exactly once to 12
  physical samples;
- 1,734,019 coordinate-aware input features were audited and 361,907 passed
  the predeclared full-universe expression filter;
- edgeR quasi-likelihood models covered the phase- and cycle-adjusted condition
  coefficient plus both condition-by-cycle coefficients and their two-degree-
  of-freedom omnibus test;
- primary Bakta annotations were joined only after model fitting: 342,605
  retained features matched, 27 MAG features were unmatched, and 19,275
  retained non-MAG features were explicitly unannotated;
- the complete unfiltered 1,734,019-feature by 12-physical-sample raw count
  matrix, result tables, model/filter/design/normalization/annotation audits,
  compact QC PDFs, deterministic summaries, the experimental-unit caveat, and
  an MD5 inventory are present in the canonical output.

The annotated rerun reproduced the corrected unannotated QA run's model-result
row counts and deterministic numerical summaries exactly. No biological claim
or functional subset was selected during #22 implementation.

## Binding analysis decision

The earlier SOS-, UV-response-, DNA-repair-, and stress-subset analyses were
quick directional checks only. They are quarantined, including the SOS-only
edgeR model and the subset-specific CPM, RNA:DNA, temporal, and trajectory
analyses. They are not manuscript results, not null-result evidence, and not a
gene- or MAG-prioritization substrate.

Read `docs/expression_quarantine.md` before touching expression outputs. Do not
repeat the numerical results of quarantined analyses in a continuation summary
or manuscript draft.

## Replacement order

1. GitHub #22: complete; full transcriptome-wide model and QA outputs above.
2. GitHub #23: next; map and subset the complete result universe for functional,
   taxonomic, and MAG-resolved interpretation.
3. GitHub #24: deprecate the quick checks in manuscript-facing registries and
   rebuild the manuscript workflow around verified global results.

No full DE execution occurred in the compaction turn that created this
handoff; the completion record above was added by the subsequent #22 run.

## Experimental boundary

There is one control membrane and one phage-UV-treated membrane observed over
three cycles and two within-cycle phases. Technical sequencing runs must be
collapsed to the twelve physical samples. Condition remains confounded with
membrane identity; models describe this two-membrane longitudinal system and
do not establish a population-level causal treatment effect.

## Valid expression substrate

- 23 staged run-level metatranscriptomic gene-count tables covering 12 physical
  samples;
- 11 physical samples have two technical sequencing runs and TBF3 has one;
- sample mapping: `metadata/sample_metadata.tsv`;
- registry: `manifests/data_manifest.tsv`;
- implementation requirements and acceptance criteria: GitHub #22.

Do not use the missing legacy/poster DE-table placeholder as the analysis
source. Use the verified #22 full-universe outputs for #23, and rebuild them
only through the recorded local entry point when necessary.

## Scientific context retained

- The manuscript remains an ecological and transcriptional analysis of
  repeated phage-UV treatment of anaerobic membrane biofilms.
- There is no supported DNA-damage, UV-mutagenesis, or adaptation claim.
- Coverage-qualified population genomics remains descriptive only; see
  `docs/mag_by_mag_genomic_variation.md` and
  `docs/population_genomics_descriptive.md`.
- Candidate figures remain unnumbered and unallocated, and the fixed mappings
  in `docs/figure_visual_grammar.md` apply to main and supplementary figures.
- The 16S analysis remains owned by a separate collaborator. Do not restart,
  audit, or manage it here.
- Host-phage linking remains deferred unless it clarifies a stronger result
  emerging from the global analysis.

## Compaction boundary

Resolved storage cleanup, transfers, quota/inode work, Conda cleanup, KB work,
and unrelated projects are excluded. The next session should load this file,
`docs/expression_quarantine.md`, GitHub #23, and the verified #22 outputs. Do
not reconstruct the project from old chat history.

## Suggested skills

- `spreadsheets:Spreadsheets` for count-matrix and result-table audits;
- `mattpocock-skills:diagnose` only if the full-DE workflow fails;
- `mattpocock-skills:review` before accepting the model implementation;
- `mattpocock-skills:handoff` before the next deliberate compaction.
