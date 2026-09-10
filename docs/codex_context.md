# Codex context: PRJEB79569 phage-UV ecology

Current continuation checkpoint (2026-09-09): read the latest section of
`notes/handoff-2026-09-09-google-docs-api.md` first. Figures 1-5 now have
publication-size vector masters and verified native suggested previews. The
latest live readback `20260909T194325Z` passes 156 targeted checks. All 15
legend pairs now have verified native tracked clarifications; a dedicated test
proves exact preservation of all other text and all images. S1-S10 now
also have verified publication-size masters and native suggested previews;
the latest S10 replacement preserves complete prose, all 15 image IDs/order
and the 14 non-target images. All 15 masters pass the provisional size screen.
The explicit four-item author delivery queue
is in `docs/manuscript_figure_plan.md`: Zotero, review line numbers, high-quality
figures and a separate supplementary report. None is an overall completed
delivery gate yet. Preserve the separate subway agent's unapproved v11.
The author explicitly resumed work and then confirmed the goal was unpaused.
Companion v4 is now uploaded and verified: 14 visually reviewed pages,
ten complete revised captions, six files and 47 unchanged source files,
folder `1hTwcD70qWQG18oDYQLzmTMljsXhb5HlT` under the canonical Manuscript
location. V3/v2 remain preserved. The population Methods source audit is
complete: all five displayed MAG denominators equal their full dRep lengths
and all 139 qualified pairs remain; the log's missing-length warnings do not
affect them. Published 1.10.0 clustering defaults are traced to a hash-pinned
release. Exact Results-unit and Methods clarifications are verified native
suggestions, with every other text/image unchanged. No result was refitted.
Continue label alignment, claim/narrative review and the remaining delivery
gates; the former travel stop does not restrict this work. Two new audit TSVs
are not yet included in v4's correctly reported 47-file source archive.
Do not repeat completed figure rebuilding or the now-verified caption edits.

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
survived matched-CLR correction. The 64-pattern cell-wise label-swap calculations
do not preserve whole-membrane trajectories and are not valid randomisation tests
of treatment. These exploratory model-dependent results establish neither
community equivalence nor replicated treatment effects.

## Canonical paths

The provisionally accepted workflow schematic is `PRJEB79569/derived/workflow_metro_v10/`,
built by `scripts/build_workflow_metro.qmd`. It supersedes the earlier box-based
diagram for review. See `notes/handoff-2026-09-07-workflow-redesign.md`.

The separate figure agent's newer SVG restyle is a **live draft**, not an
accepted replacement: `PRJEB79569/derived/workflow_metro_v11_svg_draft/`.
Read `notes/handoff-2026-09-09-metro-v11-svg-draft.md` before touching the
workflow figure. V11 uses a hand-authored SVG; do not overwrite it with the
Quarto builder. Further author changes and two colour confirmations remain
open in that handoff. Preserve v10 in the accepted inventory until v11 is
accepted; manuscript work outside the figure can continue independently.

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

The 25 standalone analysis entrypoints are canonical Quarto notebooks under
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
- The returned 16S integration has a top25 revision allocated as working
  Supplementary Figure S10, inserted in v2 with its full caption below the image:
  `derived/16s_figure_top25_revision_2026-09-09/figures/16s-longitudinal-community-context.pdf`.
  Its full ASV denominator and shared family colour mappings are verified.
  The old boxed `study-analysis-workflow.pdf` is historical, not the current
  workflow schematic. Exact ASV-count Bray-Curtis summaries show
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
  recurrence, and population genomics. Returned 16S is working Supplementary S10.
  Use the fixed mappings in `docs/figure_visual_grammar.md` throughout.
- Supplementary Figures S6 and S7 provide MAG and vOTU taxonomic context. They
  are taxonomy-derived dendrograms, not sequence phylogenies, and do not broaden
  the treatment or host-phage claims. Current S6 is in
  `derived/taxonomic_context_revision_2026-09-09-v2/` and uses Figure 1's exact
  top25 profile and colours. S7's earlier live image is retained unchanged.
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

**Publication-size update, 2026-09-09:** `docs/figure_publication_size_audit.md`
now documents the size/font gap in all 15 old masters at a provisional 180 mm
width. Figure 1 has a new visually verified 180 x 200 mm candidate with embedded
fonts and 6.5 pt minimum text; source/statistics tables are byte-identical.
It is inserted as a native suggestion, with both captions verified at
`20260909T161333Z`: 128 targeted checks, 216 suggested text runs, ten original
Zotero metadata names; all 14 other figure properties unchanged. Use the new
handoff's first section and `manuscript/revisions/2026-09-09-figure1-publication.md`.
Other plates still require final-size work;
previous native-page QA is not publication-size acceptance.

Figures 2 and 3 now also use verified publication-size masters from
`derived/manuscript_figures_publication_2026-09-09-v2/` (180 x 100/195 mm).
Readback `20260909T162818Z` passes 131 targeted checks: both are uncropped native
image suggestions; all 13 other image properties and all manuscript prose are
unchanged against the immediate baseline. Four numerical source panels are
byte-identical; no ordination or models were recomputed. See
`manuscript/revisions/2026-09-09-figures2-3-publication.md`. Figures 4-5 and
S1-S10 remain the next final-size work, followed by companion versioning.

**Live revision checkpoint, 2026-09-09:** the user subsequently authorised
incorporating his edits and continuing the manuscript autonomously. The old
2026-09-07 hold below is historical, not the current instruction. Version 1 is
preserved; version 2 (`1IigeesgapAc-Tfi7ac3JXimKpDpc-cqD-MXiptLwYT8`) contains
the accepted original author edits and subsequent Codex changes in Suggesting
mode. Community Results, upstream/16S Methods, and descriptive 16S Discussion
are present. Figure 1 community is now inserted and Figure 2 transcriptome is
replaced with its two-panel version; both are tracked image suggestions,
uncropped and aspect-ratio verified. All five main captions and gallery labels
are aligned in order, with updated main-text references. Figure 3 uses the
three-panel functional/organism artifact to avoid duplicating Figure 2's
landscape. Ten existing Zotero metadata names remain intact. Full details and
outstanding work: `notes/handoff-2026-09-09-google-docs-api.md`, latest readback
`20260909T143027Z`: 128 targeted checks pass; 215 suggested text runs. Six-of-six
recurrence counts in live Results are corrected
to 2,671 phage-UV-higher and 2,709 control-higher;663/942 are five-of-six, not six.
The abstract, Introduction close and six Discussion paragraphs
now follow the evidence-led narrative payload, all verified once in the right
sections as Normal text. Community-abundance and host-link Methods, network Results,
S6-S9 legends and four static references are now suggested. S8 network and S9
abundance images are inserted, unique, uncropped and correctly placed. S9 was
rebuilt without model refits; all nine source tables remain byte-identical.
Four returned16S methods citations and reference entries are verified live.
S6 is replaced with the stacked tree/top25-profile revision and S10 is inserted;
both images are unique, uncropped and aspect-ratio verified. S10 has its caption
below the image and a Results S10D reference. All 15 gallery captions are now
verified immediately below their corresponding image in Normal text. Current named-family colours are frozen in
`metadata/manuscript_family_colours.tsv`; the historical R palette is not the
cross-figure authority. All source analyses and previous figure versions remain.
Three upstream Methods paragraphs now carry tool citations, and 12 further
static references are inserted, including the missing microshades entry. The
local bibliography now has 41 journal articles, one DOI preprint and one software
record. The 143219 Zotero audit finds 29 exact DOI matches among 42 records;
13 remain unmatched. Existing items must be reused. Library writes and new
live citation fields remain pending.
The Methods now include executed preprocessing/counting conventions, five
binning tools/six assignment streams, CONCOCT split/clustering settings, actual
dRep 75% completeness/25% contamination eligibility thresholds, and chunk-aware
viral gene-coordinate construction. The 260-record execution audit and v3
coordinate audit are manifest-registered. The 174 exact duplicated coordinate
records agree with all 23 existing count-run audits; no analysis was rerun.
Full per-MAG GFF provenance, MAG-quality and ambiguous-count sensitivity remain
open. The supplementary companion v2 and its source ZIP are checksum-verified
in the established Manuscript Drive subfolder. Review line-number rendering
and journal-size figure quality still need verification.
This is an in-progress author-review revision, not a final
or submission-ready manuscript. The subway v11 SVG remains the separate
agent's live draft and has not been promoted. The historical scaffold-complete
and citation-audit statements below do not cover the newly inserted material.

The complete evidence-led venue-neutral manuscript scaffold, author-directed
main-figure architecture, ten working supplementary figures, descriptive legends, bibliography, and
claim audit form a verified evidence and authoring scaffold. The local candidate suite contains 13
PDFs, including two reader-facing opening figures and their two preserved
analysis-led predecessors. Supplementary Figure S8 is the descriptive
host-phage evidence audit. A read-only export of the live Google Doc was audited
on 2026-09-07; it contained 20 rendered pages, tracked changes/comments, and a
stale pre-return figure narrative. That historical hold was superseded by the
author's explicit revision authorisation; continue in Suggesting mode, preserving
his accepted edits and comments. The document is now
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
Use the current 42-DOI-plus-software bibliography and existing exact DOI matches
when completing Zotero integration; do not re-import the historical 16-record
scaffold or duplicate existing items. New static references are not live fields.
The agent-authored starting draft may
be used as an evidence map, but not as submission prose for ISME
Communications. If the user supplies researcher-authored or accepted prose, use
Suggesting mode for agent changes and limit assistance to the journal's
permitted scope.
Do not rerun or take over the collaborator's 16S workflow. Its returned results
now have working allocation S10; that is not final author acceptance.

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
