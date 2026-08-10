# Handoff: PRJEB79569 full-DE interpretation

Date: 2026-08-10

This is the controlling scientific handoff. It supersedes the immediate-next-
step sections of all earlier handoffs. Do not reconstruct the project from old
chat, storage cleanup, HPC execution history, or quarantined subset analyses.

## Next objective

Execute GitHub issue #24: rebuild the manuscript workflow from the verified
#22 global differential-expression results and the completed #23
interpretation. Candidate figures remain unnumbered and unallocated until the
argument is assembled.

## Canonical verified outputs

- Full transcriptome-wide model:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/full_transcriptome_de/`
- Full-universe interpretation:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/full_de_interpretation/`
- Frozen interpretation methods: `docs/full_de_interpretation_plan.md`
- Verified result summary: `docs/full_de_interpretation_results.md`
- Binding quarantine: `docs/expression_quarantine.md`
- Fixed visual mappings: `docs/figure_visual_grammar.md`

The #23 output contains the complete tested-feature annotation/taxonomy join,
category membership audits, rank-based frozen-category enrichment, MAG
coherence, descriptive six-cell recurrence, candidate tables, three unnumbered
vector PDFs, input provenance, and a fully verified MD5 inventory.

## Scientific result to carry forward

The result is not a broad DNA-damage story.

- SOS-response genes show a modest collective upward ranking for the adjusted
  condition coefficient (FDR 0.0021; median gene logFC 0.136), but this is
  SOS-associated transcription, not direct DNA-damage evidence.
- Redox-stress genes show a cycle-2 interaction ranking (FDR 0.0095); the term
  is a change relative to cycle 1, not a standalone cycle-2 treatment effect.
- No frozen category is supported for the cycle-3 interaction or the omnibus
  interaction test, and the other adjusted-condition repair/stress categories
  are not supported.
- MAG signals are widespread and bidirectional: 175 of 340 eligible MAGs are
  supported for the adjusted condition coefficient, split 100 higher-ranked
  and 75 lower-ranked.
- The recurrence filter retains 3,334 treatment-higher and 3,651 control-higher
  genes. The defensible story is heterogeneous organism-resolved ecological and
  transcriptional restructuring, not a uniform repair program.

## Binding experimental boundary

There is one control membrane and one phage-UV-treated membrane repeatedly
sampled across three cycles and two phases. Condition is confounded with
membrane identity. All coefficients and candidate figures describe this
two-membrane longitudinal system and do not establish a population-level
causal treatment effect.

## Manuscript-rebuild rules

- Start only from #22 and #23 canonical outputs.
- Retain negative and heterogeneous category results.
- Do not quote or re-use quarantined SOS/UV subset-first statistics.
- Keep population genomics descriptive and coverage-qualified.
- Use host-phage links only if they clarify a stronger global result; do not
  force them into the story.
- Keep 16S outside this agent's scope; it is owned by a separate collaborator.
- Apply the fixed condition, phase, cycle, and taxonomy mappings to main and
  supplementary figures.
- Do not assign figure numbers or main/supplement status prematurely.

## Active GitHub queue

Only #24 should remain open after #23 is closed. Old roadmap, staging, cleanup,
MGnify, vOTU, host-phage, and subset-integration tickets were reconciled as
completed or superseded; they are not pending scientific work.
