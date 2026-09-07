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

The original poster's community-abundance claim has also been reconstructed.
The condition-only MAG DESeq2 model returned zero FDR-supported MAGs, matching
the poster. A phase/cycle-adjusted screen returned one MAG, but no MAG survived
BH correction in the six-cell matched CLR analysis. For 616 high-quality vOTUs,
two condition-only hits disappeared after phase/cycle adjustment and none
survived matched-CLR correction. Paired restricted-permutation Bray-Curtis tests
were not significant for MAGs (exact p = 0.125) or vOTUs (exact p = 0.0625).
These are exploratory system-specific comparisons, not replicated treatment
effects.

## Canonical paths

- Local data root:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569`
- Full transcriptome-wide output:
  `PRJEB79569/derived/full_transcriptome_de/`
- Full-universe interpretation:
  `PRJEB79569/derived/full_de_interpretation/`
- Complete figure suite and registry:
  `PRJEB79569/derived/manuscript_figure_candidates/`
- Community differential-abundance output:
  `PRJEB79569/derived/community_differential_abundance/`
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

The 24 standalone analysis entrypoints are canonical Quarto notebooks under
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
- The 16S analysis remains owned by Susana Martinez Arbas. Her scientific
  summary and recipient-only SharePoint folder were received by Gmail on
  2026-09-03, and her repository branch now ends at `b6acbe5`. The replacement
  delivery was downloaded and promoted locally on 2026-09-07. Treat the result
  as returned with one stale internal manifest row. The canonical 12-sample
  contract and local file integrity are verified; statistical-design validation
  remains open. See
  `notes/handoff-2026-09-04-16s-return-receipt.md`.
- The returned 16S integration now has two unnumbered, visually verified vector
  candidates: `16s-longitudinal-community-context.pdf` and
  `study-analysis-workflow.pdf`. Exact ASV-count Bray-Curtis summaries show
  lower C2-to-C3 than C1-to-C2 turnover in all four membrane-by-phase
  trajectories. This recurrence is descriptive; three cycles are insufficient
  for a formal time-series model and treatment remains membrane-confounded.
- The verified CRISPR-derived host-phage evidence audit is allocated as
  Supplementary Figure S8. It contains 86 deduplicated candidate pairs linking
  80 MAGs to 85 phage contigs. Treat it as historical-exposure context only,
  not active infection, validated host range, treatment response, or causal
  linkage to transcription.
- Canonical figure filenames remain unnumbered. By author decision, Figure 1 is
  `community-structure-figure-one.pdf`, combining the design, aligned microbial
  and vOTU composition, and their Bray-Curtis ordinations. It is followed by
  global transcriptome structure, functional and organism-resolved structure,
  recurrence, and population genomics. Delegated 16S has no reserved number.
  Use the fixed mappings in `docs/figure_visual_grammar.md` throughout.
- Supplementary Figures S6 and S7 provide MAG and vOTU taxonomic context. They
  are taxonomy-derived dendrograms, not sequence phylogenies, and do not broaden
  the treatment or host-phage claims.
- Supplementary Figure S8 provides the CRISPR-derived candidate-link network
  and its host-signal and viral-catalogue audits. None of its linked phage
  representatives passes the manuscript's high-quality classified-vOTU filter.
- Supplementary Figure S9 contains the detailed exploratory microbial and vOTU
  differential-abundance and sensitivity analyses.
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

The complete evidence-led venue-neutral manuscript scaffold, author-directed
main-figure architecture, nine supplementary figures, descriptive legends, bibliography, and
claim audit form a verified evidence and authoring scaffold. The local candidate suite contains 13
PDFs, including two reader-facing opening figures and their two preserved
analysis-led predecessors. Supplementary Figure S8 is the descriptive
host-phage evidence audit. A read-only export of the live Google Doc was audited
on 2026-09-07; it contained 20 rendered pages, tracked changes/comments, and a
stale pre-return figure narrative. The user is editing and commenting in the
live document; do not touch it until explicitly asked. The document is now
filed at `My Drive/Projects/Phage therapy/PRJEB79569 phage UV/Manuscript`
(folder ID `1ajfSU0gAgrMPBsuhXQ4QSIrXWwrnRchy`). The local revised argument
begins with longitudinal community context, then moves through cycle-led
transcriptome geometry, a broad
bidirectional adjusted membrane coefficient, narrow functional support,
widespread organism-level coherence, recurrent gene-level structure, and
descriptive population-genomic heterogeneity.

The live ISME Communications policy checked on 2026-09-01 prohibits
LLM-drafted manuscripts. The current agent-authored prose cannot be submitted
to that journal after superficial editing. Human researchers must independently
author the submission from the verified evidence package and resolve the AI-use
disclosure and artifact-review steps in
`manuscript/isme_communications/researcher_authorship_remediation.md`.

## Next decision

The evidence boundary, figure allocation, visual QA, citation audit, manuscript
scaffold, and pre-16S reproducibility audit are complete under GitHub issues
#26 through #31. The collaborator-owned 16S result has now returned. Its
canonical local copy was verified against two independent downloads on
2026-09-07; issue #30 remains active for the single stale collaborator-manifest
row, design-aware statistics, and evidence-weighted integration. The 12-sample
contract is verified.
Import the 16 records in
`manuscript/references.bib` into Zotero before converting temporary author-year
text into live Google Docs field codes. The agent-authored starting draft may
be used as an evidence map, but not as submission prose for ISME
Communications. If the user supplies researcher-authored or accepted prose, use
Suggesting mode for agent changes and limit assistance to the journal's
permitted scope.
Do not manage the delegated 16S analysis or preallocate it a figure number.

The full pre-16S reproducibility audit passed on 2026-09-01. Upstream software
provenance is now versioned in `manuscript/upstream_software_provenance.tsv`:
Bakta 1.12.0/database 6.0, CAT/BAT 6.0.1/database build 2023-11-21, CheckV
1.1.1/database v1.5, and inStrain 1.10.0 are verified. The exact executed
CoverM version and exact GTDB release tag are explicitly not recoverable and
must not be inferred from unrelated cached environments or other projects.
Exact repository execution states are bound separately in
`manuscript/upstream_repository_provenance.tsv`: multiomics commit
`5f7dfe4c42ba65a8188589f437667a61285a5bea` reconstructs the preserved executed
worktree byte-for-byte, and host-phage commit
`604db81b73f2550bdea08e5eaa08f35186d21f53` is tied to its completed full-run
log. Final issue #31 closure still requires the issue #30 decision.
