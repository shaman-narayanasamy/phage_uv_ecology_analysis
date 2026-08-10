# Quarantine: subset-first expression analyses

Date: 2026-08-10

## Decision

All expression analyses that began from a preselected SOS, UV-response,
DNA-repair, stress-response, or related functional subset were quick checks.
They are quarantined from manuscript inference.

The only valid differential-expression entry point is a transcriptome-wide
model built from the complete staged metatranscriptomic gene-count universe.
Functional or taxonomic subsets may be derived only after that global model is
complete, using the same tested-gene universe and its multiplicity context.

## Quarantined workflows

- `scripts/run_sos_edger_sensitivity.R`: SOS-restricted edgeR quick check;
- `scripts/build_uv_activity_candidates.R`: preselected UV-category CPM checks;
- `scripts/build_sos_activity_candidates.R`: preselected SOS-marker CPM checks;
- the DNA-repair/SOS RNA:DNA and temporal-test portions of
  `scripts/build_temporal_response_analysis.R`;
- `scripts/evaluate_temporal_cluster_stability.R` when applied to the
  preselected response modules.

The associated `uv_mt_*`, `sos_mt_*`, `sos_edger_*`,
`community_rna_dna_*`, `mag_dna_damage_*`, `mag_temporal_*`, and
`temporal_cluster_*` tables and their rendered figures are quarantined with
their builders.

## Rules for future agents

- Do not cite quarantined effect sizes, p-values, FDR counts, slopes, cluster
  results, or directional summaries as findings.
- Do not use quarantined genes, MAGs, categories, or apparent directions to
  seed or narrow the full transcriptome-wide analysis.
- Do not allocate quarantined panels to the main manuscript or supplement.
- Do not delete the artifacts yet. Preserve them as clearly labelled
  provenance and pipeline-debugging material until the replacement workflow is
  reproduced and verified.
- After the global model, subsets may be regenerated from its full result table
  under the plan in GitHub issue #23. Agreement with a quarantined quick check
  may be noted only as a validation diagnostic, not as independent evidence.

## Replacement workflow

- GitHub #22: full transcriptome-wide differential-expression analysis;
- GitHub #23: functional and MAG-resolved subsets derived from #22;
- GitHub #24: retire the SOS-first framing and rebuild manuscript materials.

## Outside quarantine

- raw metatranscriptomic gene-count tables and sample metadata;
- gene annotations, MAG taxonomy, and signature maps used only as annotations;
- general community-ecology outputs that did not prefilter an expression model;
- coverage-qualified descriptive population-genomic outputs;
- the separately owned 16S workstream.
