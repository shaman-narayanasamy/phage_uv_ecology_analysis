# Scientific review checklist for authors and coauthors

Status: unapproved review aid. This checklist points researchers to verified
evidence; it is not manuscript prose and does not record approval by itself.

For every item, a named researcher should record `agree`, `needs revision`, or
`not reviewed`, with initials and date in `author_decision_register.tsv` or the
controlled review system.

## Experimental boundary

- One control membrane and one phage-UV membrane were repeatedly sampled across
  two phases and three cycles.
- Condition is inseparable from membrane identity, position, and history.
- The 12 observations do not constitute 12 independent biological replicates.
- Condition coefficients are system-specific longitudinal comparisons, not
  population-level causal treatment effects.

Evidence: `metadata/sample_metadata.tsv`, `docs/submission_claim_audit.md`, and
claim-registry entries C15 and C16.

## Transcriptome-wide evidence

- C03-C04: filtering universe and adjusted-condition feature counts.
- C05-C06 and C18: modest SOS ranking support and unsupported remaining repair
  and stress categories.
- C08 and C19: widespread bidirectional MAG-level coherence.
- C09 and C20: predeclared descriptive recurrence structure.

Review the canonical statistics and boundaries directly in
`manuscript/claim_evidence_registry.tsv`. Do not use quarantined subset-first
expression analyses as manuscript evidence.

## Descriptive contextual layers

- C14 and C25: MAG-mapped community and taxonomy-derived MAG/vOTU context.
- C10 and C21: five-MAG coverage-qualified population-genomic description.
- C26: 86 deduplicated candidate host-phage pairs as historical CRISPR evidence
  only.
- C12 and C22: collaborator-owned 16S remains conditional and does not supply
  independent replication.

## Figure review

- Main Figures 1-4: community/transcriptome trajectory, response architecture,
  recurrence, and descriptive population-genomic heterogeneity.
- Figure 5: conditional 16S insertion only if issue #30 returns informative,
  auditable evidence.
- Supplementary Figures S1-S5: diagnostics and extended tested-universe results.
- Supplementary Figures S6-S7: taxonomy-derived MAG and vOTU context, not
  sequence phylogenies.
- Supplementary Figure S8: candidate host-phage evidence audit, not active
  infection or validated host range.

Evidence: `docs/manuscript_figure_plan.md`, `manuscript/figure_legends.md`, and
the checksum inventories referenced by `manifests/data_manifest.tsv`.

## Required cross-check after researcher writing

- Every quantitative statement maps to a verified claim-registry row.
- Every named method and ecological statement maps to the 16-record bibliography.
- Negative results and the one-membrane-per-condition limitation remain visible.
- No prohibited subset analysis enters text, tables, figures, or supplement.
- Title, abstract, legends, declarations, and cover letter are independently
  researcher-authored for ISME Communications.
- AI use is disclosed according to the selected journal's current policy.
- All comments are resolved or explicitly retained as outstanding.
- The full audit and visual inspection are rerun on the frozen package.

## Approval boundary

An agent may verify files, counts, checksums, and registry consistency. Only
named authors can approve interpretation, authorship, declarations, reviewer
choices, and submission.
