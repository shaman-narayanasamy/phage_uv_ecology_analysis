# Codex context: PRJEB79569 phage-UV ecology

This is a science-first orientation for future agents. Start with
`notes/handoff-2026-08-10-manuscript-rebuild.md`. Do not reconstruct the
project from chat, storage-cleanup history, old issue descriptions, or the
quarantined subset analyses.

## Scientific question

The published experiment evaluated combined bacteriophage and UV-C cleaning
over three cycles in an anaerobic membrane bioreactor. The active analysis asks
what community-wide transcriptional structure accompanies the two repeatedly
sampled membrane systems. It does not start from a selected SOS, DNA-repair,
biofilm, taxonomic, or phage-linked subset.

## Binding experimental boundary

There is one control membrane and one treated membrane, sampled at two phases
across three cycles. Condition is confounded with membrane identity. Report
condition coefficients as longitudinal, system-specific differences between
these two membranes, never as population-level causal treatment effects.

Repeated observations improve description; they do not create independent
biological replicates.

## Current evidence

The complete transcriptome-wide edgeR model and its post-model interpretation
are verified:

- 23 sequencing runs were aggregated into 12 physical samples;
- 361,907 of 1,734,019 features passed the predeclared filter;
- 7,703 features had adjusted-condition FDR below 0.05, with 7,699 also having
  absolute log2 fold-change at least 1;
- SOS genes were collectively higher-ranked for the adjusted condition
  coefficient, but the median effect was modest and the other frozen repair
  and stress categories were not supported;
- MAG-level signals were widespread and bidirectional;
- 6,985 genes passed the predeclared descriptive recurrence criteria, split
  between 3,334 treatment-higher and 3,651 control-higher genes.

The defensible interpretation is heterogeneous organism-resolved
transcriptional restructuring. SOS-associated transcription is not direct
evidence of DNA damage, mutagenesis, or adaptation.

## Canonical paths

- Local data root:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569`
- Full transcriptome-wide output:
  `PRJEB79569/derived/full_transcriptome_de/`
- Full-universe interpretation:
  `PRJEB79569/derived/full_de_interpretation/`
- Candidate figure registry:
  `PRJEB79569/derived/manuscript_candidates/candidate_figure_manifest.tsv`
- Proposed manuscript:
  `manuscript/manuscript_skeleton.md`
- Claim audit:
  `manuscript/claim_evidence_registry.tsv`
- Analysis-use registry:
  `manuscript/analysis_registry.tsv`
- Reproducible audit report:
  `analysis/phage_uv_ecology.qmd`

## Analysis boundaries

- Every subset-first SOS, UV-response, DNA-repair, RNA:DNA, temporal-module,
  and module-clustering expression analysis is quarantined. See
  `docs/expression_quarantine.md`.
- Population genomics is descriptive, coverage-qualified, and limited to a
  selected five-MAG set. See `docs/population_genomics_descriptive.md`.
- The 16S analysis is owned by a separate collaborator. Do not manage it from
  this workstream.
- Host-phage integration is deferred. Use it only if it materially clarifies a
  supported global result.
- Candidate figures are unnumbered and unallocated. Use the fixed mappings in
  `docs/figure_visual_grammar.md` across both manuscript and supplementary
  materials once allocation is decided.

## Next decision

The draft and evidence registries are ready for scientific and voice review.
The next manuscript step is to decide the argument and select candidate
figures before assigning numbers or main-versus-supplement placement.
