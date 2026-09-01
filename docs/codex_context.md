# Codex context: PRJEB79569 phage-UV ecology

This is a science-first orientation for future agents. Start with
`notes/handoff-2026-08-27-full-manuscript-draft.md`. Do not reconstruct the
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
- Complete figure suite and registry:
  `PRJEB79569/derived/manuscript_figure_candidates/`
- Working manuscript:
  `manuscript/manuscript_skeleton.md`
- Descriptive legends:
  `manuscript/figure_legends.md`
- Zotero-importable bibliography:
  `manuscript/references.bib`
- Citation audit and live-field-code boundary:
  `docs/citation_audit.md`
- Claim audit:
  `manuscript/claim_evidence_registry.tsv`
- Analysis-use registry:
  `manuscript/analysis_registry.tsv`
- Reproducible audit report:
  `analysis/phage_uv_ecology.qmd`
- Complete pre-submission audit runner and current report:
  `scripts/run_pre_submission_audit.sh` and
  `docs/pre_submission_reproducibility_audit.md`

## Executable analysis sources

The 20 standalone analysis entrypoints are canonical Quarto notebooks under
`scripts/*.qmd`. Use `bash scripts/run_qmd.sh scripts/<notebook>.qmd
[arguments...]` for exact command-line execution. The runner uses a temporary
purl extraction and supplies `PHAGE_UV_NOTEBOOK_PATH` for repository discovery.
Notebook rendering does not execute analysis code automatically. Reusable
modules in `R/` and automated tests in `tests/` intentionally remain `.R`.

## Analysis boundaries

- Every subset-first SOS, UV-response, DNA-repair, RNA:DNA, temporal-module,
  and module-clustering expression analysis is quarantined. See
  `docs/expression_quarantine.md`.
- Population genomics is descriptive, coverage-qualified, and limited to a
  selected five-MAG set. See `docs/population_genomics_descriptive.md`.
- The 16S analysis is owned by a separate collaborator. Do not manage or rerun
  it from this workstream; audit only the returned package for integration.
- A fresh write invitation for `smarbas` is pending as of 2026-08-29 after the
  earlier invitation expired. No returned result or pull request was present.
- The verified CRISPR-derived host-phage evidence audit is allocated as
  Supplementary Figure S8. It contains 86 deduplicated candidate pairs linking
  80 MAGs to 85 phage contigs. Treat it as historical-exposure context only,
  not active infection, validated host range, treatment response, or causal
  linkage to transcription.
- Canonical figure filenames remain unnumbered. The story-reorganized working
  draft begins with `community-transcriptome-trajectory.pdf`, then
  `transcriptome-response-architecture.pdf`, followed by the recurrence and
  population-genomics candidates. Figure 5 remains a conditional insertion
  point for delegated 16S.
  Use the fixed mappings in `docs/figure_visual_grammar.md` throughout.
- Supplementary Figures S6 and S7 provide MAG and vOTU taxonomic context. They
  are taxonomy-derived dendrograms, not sequence phylogenies, and do not broaden
  the treatment or host-phage claims.
- Supplementary Figure S8 provides the CRISPR-derived candidate-link network
  and its host-signal and viral-catalogue audits. None of its linked phage
  representatives passes the manuscript's high-quality classified-vOTU filter.
- A separate taxonomic-resolution exploration compares top-25 family, genus,
  and species stacked profiles using phylum-hued microshades remainders. It also
  contains an information-retention audit and a family heat-tree time-series
  diagnostic. Family is the deepest defensible main-text resolution and its
  top-25 microshades profile now appears prominently in revised Figure 1;
  genus, species, and heat-tree variants remain exploratory.
- A separate four-PDF taxonomic layout comparison pairs the MAG tree with the
  family profile and the vOTU tree with a 12-sample realm profile, each as bars
  and areas. Bars are recommended because the six observations are discrete.
  Viral realm composition is 93.3-97.1% Duplodnaviria across samples, so the
  high-level viral panel is descriptive supplementary context rather than a
  strong longitudinal main-text result.

## Current manuscript state

The complete evidence-led venue-neutral manuscript, story-reorganized main figures,
supplementary figures, two taxonomic-context candidates, descriptive legends,
bibliography, and claim audit are ready for author review. The local candidate
suite contains 13 PDFs, including two reader-facing opening figures and their
two preserved analysis-led predecessors. The versioned Google Doc still
contains the complete draft and its previous 11 figure previews,
including the two taxonomic-context candidates at the end of the gallery. The
MAG preview now includes the family-level metagenomic community profile and
the quality-first ring order. Its control and phage-UV profiles are vertically
aligned at the same six cycle-phase positions, and missing family assignments
are explicitly distinguished from collapsed classified families. The
pre-replacement, nine-preview, initial 11-preview, revised-MAG, and aligned-MAG
states are named in version history. It has not yet been replaced with the two
story-reorganized previews. The revised argument begins with longitudinal
community context, then moves through cycle-led transcriptome geometry, a broad
bidirectional adjusted membrane coefficient, narrow functional support,
widespread organism-level coherence, recurrent gene-level structure, and
descriptive population-genomic heterogeneity.

## Next decision

The evidence boundary, complete figure allocation, visual QA, citation audit,
and full manuscript edit are complete under GitHub issues #26 through #29.
Proceed to issue #30 only when the collaborator-owned 16S result is returned;
integrate it only if informative. Import the 14 records in
`manuscript/references.bib` into Zotero before converting temporary author-year
text into live Google Docs field codes. The agent-authored starting draft may
remain in regular editing mode while the user comments and suggests. If the
user supplies revised or accepted prose, use Suggesting mode for agent changes.
Do not manage the delegated 16S analysis; preserve its conditional Figure 5
insertion point.

The full pre-16S reproducibility audit passed on 2026-08-30. Upstream software
provenance is now versioned in `manuscript/upstream_software_provenance.tsv`:
Bakta 1.12.0/database 6.0, CAT/BAT 6.0.1/database build 2023-11-21, CheckV
1.1.1/database v1.5, and inStrain 1.10.0 are verified. The exact executed
CoverM version and exact GTDB release tag are explicitly not recoverable and
must not be inferred from unrelated cached environments or other projects.
Final issue #31 closure still requires the issue #30 decision.
