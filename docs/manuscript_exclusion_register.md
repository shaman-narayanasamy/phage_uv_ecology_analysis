# Mandatory manuscript exclusion register

Author-confirmed quarantine: 2026-09-22. Status: ACTIVE. Applies to main text, figures, captions, supplementary material, factsheets and automatic report generation.

Quarantine means provenance/debugging use only, not deletion and not a claim that every underlying calculation is incorrect. Never reactivate an excluded result merely because its file exists, appears in an old manifest or agrees with a newer result. Reopening requires a new explicit author decision recorded here with replacement provenance.

| ID | Audited excluded scope | Replacement / boundary | Evidence |
|---|---|---|---|
| Q01 | Non-combined biofilm definitions as scientific results: historical9, historical12, biofilm_union/3489; mag_functional_concentration_2026-09-13-v1; mag_concentration_dependence_2026-09-13-v1; noncanonical biofilm review v1-v3 and membership-specific summaries/tests/previews in biofilm_full_transcriptome_review_2026-09-13-v4 | Active combined definition and combined-mode concentration/dependence packages, dated 2026-09-13-v1. Historical rules/membership remain permitted provenance inputs for constructing the combined union. The underlying full-transcriptome DE is NOT excluded. | notes/biofilm-sos-active-definition-2026-09-13.md |
| Q02 | Subset-first SOS/UV/repair expression workflows and their outputs exactly as scoped in docs/expression_quarantine.md | Full-transcriptome DE followed by functional interpretation. Raw counts, annotation maps, community ecology and coverage-qualified genomic comparisons remain outside this quarantine. | docs/expression_quarantine.md |
| Q03 | Superseded 607/616-vOTU abundance analyses, including viral results/panels in community_differential_abundance_figure_revision_2026-09-09 and its older supplement allocation | Catalogue-aligned community_cycle_models_catalogue_aligned_2026-09-16-v1: 634 eligible vOTUs, 578 retained. Do NOT infer that unrelated MAG outputs in mixed directories are excluded. | manuscript/supplementary_table_plan_2026-09-16.tsv; notes/decision-2026-09-21-abundance-results-correction.md; current manuscript reconciliation |
| Q04 | Earlier U+B40 cohort comparison, ERR4181942–ERR4181944, including the shared 250-base cross-cohort analysis previously called cycle 0 | Excluded from this manuscript by author decision. Current-experiment 12-sample 16S and within-experiment cycle analyses remain active. Preserve collaborator files and historical comparison provenance. No blanket quarantine of 16S_v2 or its mixed receipt directory. | notes/handoff-2026-09-21-manuscript-MAG-and-16S-outcomes.md |
| Q05 | September 9 supplementary report/source manifest as a submission package, and inherited legacy numbering | Historical package only. Individual components require claim-by-claim reconciliation; they are not all scientifically excluded. Figure S1 original experiment and Table S1 Bray-Curtis concordance retain their author allocations. | manuscript/supplementary_report_sources.json; September 16 proposed inventory; author reconciliation discussion 2026-09-22 |

Paths naming generated outputs above are relative to the data root PRJEB79569/derived. The full file/class scope of Q02 is in its linked register, not a new blanket ban on all similarly named modern analyses.

## Required checks before using an artifact

1. Check this register and docs/expression_quarantine.md before selecting a source.
2. Trace result definition, model universe and catalogue version. A newer timestamp or attractive significance is not evidence of eligibility.
3. Mark unknown or mixed-scope artifacts NEEDS_REVIEW; do not silently approve or quarantine the whole folder.
4. Excluded material must not populate active manifest rows or scientific figures/tables. Historical inventories remain readable only as provenance.
5. Keep current combined biofilm/SOS results, complete-universe DE and current-experiment 16S explicitly separate from excluded predecessors.

The legacy supplementary builder is blocked when its source specification has quarantined status. This guards that builder only; other consumers must follow this register. No claim of universal technical enforcement is made.
