# Handoff: PRJEB79569 Scientific Continuation

Status: superseded by `notes/handoff-2026-08-10-full-de-interpretation.md`.
Retain this file only for scientific boundary provenance.

Date: 2026-08-04

> Superseded for expression analysis and immediate next steps by
> `notes/handoff-2026-08-10-full-transcriptome-de-reset.md`. All subset-first
> expression results described below are quarantined quick checks under
> `docs/expression_quarantine.md`; do not carry their numbers or conclusions
> into the manuscript.

This is the controlling handoff for the next session. Stay entirely within the
`PRJEB79569` phage-UV manuscript analysis. Where older handoffs conflict with
this one, this one wins.

## Next-Session Objective

Inspect the existing candidate figures and staged results to determine what is
scientifically interesting. Build the manuscript argument from supported
ecological and transcriptional patterns. Do not assign figure numbers or decide
main versus supplementary placement yet.

## Scientific Frame

The paper concerns repeated phage-UV treatment of anaerobic membrane biofilms,
with emphasis on:

- community ecology;
- transcriptional ecology across cycles and phases;
- organism-resolved MAG/rMAG patterns;
- qualitative population-genomic stability or turnover where coverage permits.

Do not recenter it as an engineering-performance paper. There is no supported
DNA-damage story. SOS transcription is not a damage assay, and inStrain is not
a mutation or lesion assay.

## Experimental-Limit Boundary

There is one control membrane and one phage-UV-treated membrane, followed across
three cycles. Initial and backflush samples are within-cycle phases; multiple
sequencing runs from the same sample are technical replicates. Condition is
therefore confounded with membrane identity. Cycles are repeated longitudinal
observations, not independent biological treatment replicates.

Statistical models may describe this system and test technical/model contrasts,
but they do not establish population-level causal treatment effects.

## Historical Quick-Check Results — Quarantined

The subset-derived expression bullets below are retained only to document what
was checked. They are not established manuscript results, including when they
are null. Do not use them to prioritize the global DE analysis.

- No supported monotonic temporal SOS or core-response trend.
- The exploratory SOS direction does not survive the predefined BH family.
- No condition-by-cycle SOS gene survived FDR correction.
- No stable organism trajectory clusters: zero of 60 predefined configurations
  passed the silhouette and stability requirements.
- No individual MAG temporal slope survived BH correction.
- Host-phage links are sparse and should remain deferred unless they clarify a
  stronger supported result.
- The former inferential inStrain analysis is retired. Five coverage-qualified
  MAGs may be shown qualitatively as heterogeneous stability or turnover; no
  condition, cycle, phase, damage, adaptation, or mutagenesis inference.

These nulls are results, not problems to analyse around.

## Figure State And Visual Rules

Candidate figures are unnumbered and unallocated under:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/manuscript_candidates/`

Use `docs/figure_visual_grammar.md` and `R/figure_style.R` for every main and
supplementary figure:

- phage-UV treatment: violet `#7E57C2`;
- control: pastel green `#8FCB8A`;
- phase: shape;
- cycle: ordered position;
- taxonomy: stable phylum strip/swatch, with rare phyla grouped as `Other`;
- do not make condition and taxonomy compete for colour in the same marks.

No embedded figure titles; vector PDF is primary; captions remain descriptive.

Reproducible candidate builders:

- `scripts/build_candidate_ecology_figures.qmd`
- `scripts/build_uv_activity_candidates.qmd`
- `scripts/build_sos_activity_candidates.qmd`
- `scripts/build_temporal_response_analysis.qmd`
- `scripts/evaluate_temporal_cluster_stability.qmd`
- `scripts/run_sos_edger_sensitivity.qmd`
- `scripts/build_population_genomics_descriptive.qmd`

The UV/SOS/DNA-repair subset builders in this list are quarantined quick-check
workflows. See `docs/expression_quarantine.md` for the binding scope.

## Immediate Scientific Work

1. Inventory the rendered candidate figures and their source tables.
2. Rank panels by biological information, interpretability, and robustness—not
   by whether they support the abandoned hypothesis.
3. Identify the smallest coherent ecological/transcriptional story and its
   honest nulls.
4. Revise or build figures using the fixed visual grammar, while leaving all
   panels unnumbered and unallocated.
5. Draft manuscript prose only after the figure-level argument is selected.

## Workstream Boundary

The 16S analysis is owned by a separate high-competence collaborator and their
agents. It is not a blocker for this session. Integrate it when results return;
do not restart, audit, or manage that workstream.

## Authoritative Scientific References

- Statistical scope and exact results: `docs/temporal_analysis_rigor.md`
- Qualitative DNA boundary: `docs/population_genomics_descriptive.md`
- Figure mappings: `docs/figure_visual_grammar.md`
- Data registry: `manifests/data_manifest.tsv`
- Detailed staged-data paths: `notes/handoff-2026-07-25-project-continuation.md`
- Delegated 16S boundary: `notes/handoff-2026-07-25-16s-analysis.md`

## Explicitly Out Of Scope

Storage cleanup, transfers, scratch quotas, Conda environments, KB maintenance,
GitHub issue administration, and unrelated projects are resolved operational
history. Do not inspect or discuss them unless the user explicitly reopens one.

## Suggested Skills

- `mattpocock-skills:diagnose` only for a concrete data or analysis failure.
- `spreadsheets:Spreadsheets` for compact TSV/table audits.
- `mattpocock-skills:review` before merging figure or manuscript changes.
- `mattpocock-skills:handoff` before the next deliberate context transition.
