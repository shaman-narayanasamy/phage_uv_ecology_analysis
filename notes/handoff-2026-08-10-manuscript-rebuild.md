# Handoff: PRJEB79569 manuscript rebuild

Date: 2026-08-10

> **Superseded for continuation by
> `notes/handoff-2026-08-27-full-manuscript-draft.md`.** This file remains the
> handoff for the initial manuscript rebuild.

This is the controlling scientific handoff. GitHub issues #22, #23, and #24 are
complete. Do not reconstruct the project from chat, storage cleanup, HPC
history, the quarantined SOS-first scaffold, or subset-first expression
analyses.

## Current state

A proposed manuscript has been rebuilt from the verified complete
transcriptome-wide model and its post-model interpretation. It is a review
draft, not an approved live manuscript. Figure numbering and
main-versus-supplement placement remain deliberately unassigned.

Start with:

- proposed draft: `manuscript/manuscript_skeleton.md`;
- claim audit: `manuscript/claim_evidence_registry.tsv`;
- analysis-use boundary: `manuscript/analysis_registry.tsv`;
- executable audit surface: `analysis/phage_uv_ecology.qmd`;
- concise project context: `docs/codex_context.md`;
- verified interpretation results: `docs/full_de_interpretation_results.md`;
- fixed visual mappings: `docs/figure_visual_grammar.md`.

The old manuscript and analysis scaffolds are preserved as explicitly
quarantined provenance files. They are not evidence sources.

## Scientific result

The strongest supported result is heterogeneous, organism-resolved
transcriptional restructuring between the two repeatedly sampled membranes.

- The adjusted condition coefficient identified 7,703 features at FDR below
  0.05; 7,699 also had absolute log2 fold-change at least 1.
- SOS-response genes were collectively higher-ranked, but the median gene
  effect was modest and the other frozen repair and stress categories were not
  supported for this coefficient.
- MAG signals were widespread and bidirectional: 175 of 340 eligible MAGs,
  split between 100 higher-ranked and 75 lower-ranked.
- The descriptive recurrence filter retained 3,334 treatment-higher and 3,651
  control-higher genes.
- Coverage-qualified population-genomic structure was heterogeneous across the
  selected five-MAG set and supports no damage, mutagenesis, adaptation, or
  treatment-effect inference.

## Binding boundary

There is one membrane per condition. Condition is confounded with membrane
identity. The analysis describes this longitudinal two-membrane system and
does not establish a population-level causal treatment effect.

Every subset-first SOS, UV-response, DNA-repair, RNA:DNA, temporal-module, and
module-clustering expression workflow is provenance-only and prohibited from
the manuscript and supplement. The full tested-feature universe is the sole
DE entry point.

## Integration boundaries

- 16S is owned by a separate collaborator and remains outside this workstream;
  its verified input package is `notes/handoff-2026-08-20-16s-collaborator.md`.
- Host-phage linking is verified but deferred unless it materially clarifies a
  supported global result.
- Population genomics remains descriptive and coverage-qualified.

## Next decision

Scientific and voice review of the proposed draft is next. Select the argument
and candidate figures before assigning figure numbers or main-versus-
supplement placement. No repository-analysis issue remains open at handoff.
