# Handoff: PRJEB79569 full manuscript draft

Date: 2026-08-27; updated 2026-09-01

This is the controlling scientific handoff. Start here, then read
`docs/codex_context.md`. Do not reconstruct the project from chat, storage
cleanup, old tickets, or quarantined subset-first expression analyses.

## Current state

The full current-evidence figure suite and a complete, evidence-led
venue-neutral manuscript form a verified evidence and authoring scaffold.
GitHub issue #29 completed the full editorial pass on 2026-08-29, before the
current ISME Communications LLM policy gate was identified.

- Working manuscript: `manuscript/manuscript_skeleton.md`.
- Descriptive legends: `manuscript/figure_legends.md`.
- Zotero import file: `manuscript/references.bib`.
- Claim audit: `manuscript/claim_evidence_registry.tsv`.
- Analysis-use boundary: `manuscript/analysis_registry.tsv`.
- Figure architecture: `docs/manuscript_figure_plan.md`.
- Fixed visual mappings: `docs/figure_visual_grammar.md`.
- Editorial audit: `docs/manuscript_editorial_audit.md`.
- Pre-submission reproducibility audit:
  `docs/pre_submission_reproducibility_audit.md`.
- Exact upstream repository execution states:
  `manuscript/upstream_repository_provenance.tsv`.
- Human review decisions and scientific checklist:
  `manuscript/isme_communications/author_decision_register.tsv` and
  `manuscript/isme_communications/scientific_review_checklist.md`.
- Canonical figure output:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/manuscript_figure_candidates/`.

The manuscript was written and edited under the knowledgebase
scientific-writing and writing-voice protocols. It retains negative results,
anchors quantitative claims to figures and tables, avoids em dashes, separates
the RNA landscape from per-cell regulation, and ends each Results section with
the evidence-bounded finding. Structural, terminology, citation, figure-order,
and quantitative checks pass. It remains agent-authored text. The live ISME
Communications policy checked on 2026-09-01 prohibits LLM-drafted manuscripts,
so this prose is not submission-ready and must not be made superficially
different to conceal its origin. Human researchers must independently author
the submitted text from the verified evidence package and resolve the AI-use
disclosure and artifact-review gate in
`manuscript/isme_communications/researcher_authorship_remediation.md`. Once the
user supplies researcher-authored or accepted prose, work only in Suggesting
mode and within the journal's permitted assistance scope.

## Working argument

The main result is heterogeneous organism-resolved transcriptional
restructuring between the two repeatedly sampled membranes.

1. The top-25 family profile now establishes the longitudinal community before
   transcriptional interpretation; it is descriptive MAG-mapped metagenomic
   context, not a replicated treatment test.
2. Cleaning cycle dominates the leading expression geometry. The two membranes
   do not show a simple global separation in the MDS.
3. After adjustment for phase and cycle, the membrane coefficient is broad and
   bidirectional: 7,703 features have FDR below 0.05 and 7,699 also have
   absolute log2 fold-change at least 1.
4. Functional support is narrow. SOS genes are collectively higher-ranked, but
   their median log2 fold-change is 0.136 and the other seven frozen repair and
   stress categories are unsupported for the adjusted membrane coefficient.
5. Organism-level coherence is widespread and bidirectional: 175 of 340
   eligible MAGs are supported, split between 100 phage-UV-higher and 75
   control-higher gene sets.
6. The recurrence filter retains 6,985 genes, split between 3,334 phage-UV
   higher and 3,651 control higher.
7. Five coverage-qualified MAGs show organism-specific genomic stability and
   turnover. This layer is descriptive and does not support damage, mutation,
   adaptation, or treatment-effect claims.

The submission-readiness claim audit is recorded in
`docs/submission_claim_audit.md`. It corrected one prose error in the recurrence
counts: 2,671 phage-UV-higher and 2,709 control-higher genes agree in all six
cells, while 663 and 942, respectively, agree in five of six.

## Current author-directed figure allocation

Canonical artifacts remain unnumbered so the authors can reallocate them
without renaming files. The working draft uses:

1. Figure 1: `community-structure-figure-one.pdf`.
2. Figure 2: `global-transcriptome-structure.pdf`.
3. Figure 3: `transcriptome-response-architecture.pdf`.
4. Figure 4: `recurrent-gene-structure.pdf`.
5. Figure 5: `population-genomic-heterogeneity.pdf`.
6. Supplementary Figure S1: `supplementary-model-diagnostics.pdf`.
7. Supplementary Figure S2: `supplementary-cycle-interaction-landscape.pdf`.
8. Supplementary Figure S3: `supplementary-functional-coefficients.pdf`.
9. Supplementary Figure S4: `supplementary-mag-coherence.pdf`.
10. Supplementary Figure S5: `supplementary-population-genomics.pdf`.
11. Supplementary Figure S6: `mag-taxonomic-context.pdf`.
12. Supplementary Figure S7: `votu-taxonomic-context.pdf`.
13. Supplementary Figure S8: `host-phage-network-evidence-audit.pdf`.
14. Supplementary Figure S9: `community-differential-abundance.pdf`.

The earlier combined `community-transcriptome-trajectory.pdf` and
`functional-organism-restructuring.pdf` layouts remain checksum-governed for
provenance but are no longer proposed as manuscript figures. Two descriptive
taxonomic candidates are allocated to the supplement:

- `mag-taxonomic-context.pdf`: taxonomy-derived 348-MAG dendrogram with rings
  ordered as completeness, contamination, current full-universe post-model MAG
  coherence, and recurrent-gene balance, alongside a descriptive family-level
  community profile based on MAG-mapped metagenomic reads. The community panel
  aligns control above phage-UV at the same six cycle-phase positions and
  distinguishes missing family assignments from collapsed classified families;
- `votu-taxonomic-context.pdf`: taxonomy-derived cladogram of 607 current
  high-quality vOTUs in 45 taxonomy groups plus realm composition.

Neither is a sequence phylogeny. The vOTU candidate is descriptive only and
does not support treatment-response or host-phage inference.

The complete visual review is recorded in
`docs/figure_visual_qa_2026-08-29.md`. Figure 1 was recomposed to reduce unused
space in the experimental-design panel while preserving the aligned community
profile.

Control is fixed to `#8FCB8A`; phage-UV is fixed to `#7E57C2`. The same mappings
apply in every main and supplementary figure.

## Binding boundaries

- There is one membrane per condition. Condition is confounded with membrane
  identity. Results are longitudinal and system-specific, not replicated
  causal treatment effects.
- SOS-associated transcription is not direct evidence of DNA damage.
- Subset-first SOS, UV-response, DNA-repair, RNA:DNA, temporal-module, and
  trajectory-cluster analyses are prohibited from the manuscript and
  supplement.
- Population genomics is descriptive and limited to a selected five-MAG set.
- Host-phage links are allocated only as Supplementary Figure S8, a descriptive
  CRISPR/SpacePHARER historical-exposure evidence audit. They do not establish
  active infection, validated host range, treatment response, or causal linkage
  to transcription.
- The 16S analysis is owned by the external expert collaborator. Susana's
  summary, SharePoint delivery, and repository branch were received on
  2026-09-03. Review `notes/handoff-2026-09-04-16s-return-receipt.md`; the
  package was downloaded, independently cross-checked, and promoted to the
  canonical data root on 2026-09-07. One supplied manifest row is stale;
  sample-contract and statistical-design validation remain under issue #30.
  The returned result has no reserved figure number and may refine Figure 1
  only if it materially improves the community story.
- The original `smarbas` repository invitation expired and was replaced on
  2026-08-29. GitHub write permission was confirmed on 2026-09-01, with no
  pending invitation remaining. A read-only audit found no
  returned branch is `origin/feature/prjeb79569-16s-analysis` at `b6acbe5`.

## Google Docs and Zotero

The Google Docs history below records named historical snapshots. A read-only
export of the live document was audited on 2026-09-07, while the user was
populating it and making comments. Do not edit, replace, or reformat it until
the user explicitly asks.

The existing Google Doc is:
`https://docs.google.com/document/d/1BwtV8cU5anyC8yFYUmiG09fIa-buT0t425bkm1tiTXs/edit?tab=t.0`.

Its canonical Drive location is
`My Drive/Projects/Phage therapy/PRJEB79569 phage UV/Manuscript` (folder ID
`1ajfSU0gAgrMPBsuhXQ4QSIrXWwrnRchy`). The 2026-09-07 read-only export rendered
to 20 pages and confirmed tracked editorial state. It also showed that the live
figure allocation and 16S placeholders lag the current project decisions; this
is an editorial review finding, not authorization to rewrite the live document.

The document is now titled `PRJEB79569 phage-UV ecology | Manuscript draft v1`.
Before replacement, the obsolete state was preserved as the named version
`Pre-manuscript figure plan and legends - 2026-08-27`. The document was then
atomically replaced with the complete manuscript and a gallery containing all
nine then-current figure previews. A Markdown export verified 4,073 words, the
editorial insertion note, the gallery at the end of the document, and exactly
nine image references. The completed nine-preview state was preserved as the
named version `Manuscript draft v1 with complete figure gallery - 2026-08-28`.
The MAG and vOTU taxonomic-context previews were then appended at the end of
the gallery. A fresh Markdown export verified 4,089 words, the unchanged
manuscript title and editorial note, and exactly 11 image references. This
state was preserved as `Manuscript draft v1 with eleven-figure gallery -
2026-08-28`.

The MAG preview was subsequently replaced with the revised two-panel figure:
quality rings first, followed by the biological overlays, plus the family-level
metagenomic community profile. The vOTU preview was restored without a content
change. A fresh Markdown export verified 4,092 words, the unchanged manuscript
title and editorial note, exactly 11 image references, and both taxonomic
candidates at the gallery end. This state was preserved as `Manuscript draft
v1 with revised MAG family profile - 2026-08-28`.

The MAG preview was then replaced once more after aligning control directly
above phage-UV at the same six cycle-phase positions and explicitly relabelling
the two grey components as `Unclassified at family level` and `Other classified
families`. The unchanged vOTU preview was restored beside it. A fresh Markdown
export verified 4,092 words, the unchanged manuscript title and editorial note,
exactly 11 unique image references, and both taxonomic candidates at the gallery
end. This state was preserved as `Manuscript draft v1 with vertically aligned
MAG profile - 2026-08-28`.

The agent authored this draft, so regular editing mode is appropriate while the
user begins commenting and suggesting. If the user supplies revised or accepted
prose for further editing, work only in Suggesting mode unless explicitly asked
to replace it.

No direct Zotero connector was available to the agent. GitHub issue #28 closed
the current citation audit on 2026-08-29. The 16 unique DOI-addressed records in
`manuscript/references.bib` are the verified import queue, and
`docs/citation_audit.md` records their roles and verification basis. Import them
into Zotero, then use Zotero field codes in Google Docs. Do not pretend that
plain author-year text is a live Zotero citation. Add 16S-specific references
only after the collaborator reports the exact executed workflow.

## Quarto execution contract

All 23 standalone analysis entrypoints in `scripts/` are now canonical Quarto
notebooks. Their former `.R` files were replaced by same-basename `.qmd` files
so the user can inspect objects and debug lines or chunks directly in RStudio.
Automatic execution during rendering is disabled because several workflows
write project outputs.

For exact non-interactive execution, use:

```sh
bash scripts/run_qmd.sh scripts/<notebook>.qmd [arguments...]
```

The runner purls the notebook to a disposable temporary directory, sets
`PHAGE_UV_NOTEBOOK_PATH` for repository discovery, runs the extracted source
with `Rscript`, and removes it. The reusable files in `R/` and automated files
in `tests/` remain `.R`; they are modules and tests, not analysis notebooks.

### Taxonomic-resolution exploration

`scripts/explore_taxonomic_resolution_figures.qmd` builds a separate, versioned
exploration under `PRJEB79569/derived/taxonomic_resolution_exploration/`. Its
top-25 family profile now feeds story-reorganized Figure 1. The top-25 semantic
unnamed fraction is 47.2% at family, 58.6% at genus, and 70.6% at species. The microshades-style
profiles retain stacked bars but colour remaining or unresolved taxa by their
known phylum, reducing the literal global-grey share to 16.5%, 18.7%, and 13.4%,
respectively. The output also contains a rank-retention audit and a common-layout
family heat-tree across the two aligned six-position longitudinal series.

### Integrated MAG and vOTU taxonomic layouts

`scripts/compare_taxonomic_timeseries_layouts.qmd` builds four review candidates
under `PRJEB79569/derived/taxonomic_timeseries_layout_comparison/`: integrated
MAG-tree plus top-25-family and vOTU-tree plus realm-profile figures, each using
stacked bars and stacked areas. All 607 verified high-quality classified vOTU
representatives map to the 12-sample metagenomic CoverM matrix. Duplodnaviria
accounts for 93.3-97.1% of mapped reads within this vOTU set. Visual review
favours bars because they preserve the six discrete observations; area plots
imply unobserved continuity and turn the MAG families into thin ribbons. These
are review candidates and have not replaced the manuscript figures or Google
Doc previews.

### Community differential abundance

The original poster's condition-only MAG analysis has now been reconstructed
from the current 12-sample CoverM matrix in
`scripts/run_community_differential_abundance.qmd`. It returned zero
FDR-supported MAGs, reproducing the poster's null community statement. The
current workflow also includes phase/cycle-adjusted DESeq2, six matched-cell
CLR effects with exhaustive sign-flip tests, and paired restricted-permutation
Bray-Curtis tests for 348 MAGs and 616 high-quality vOTUs with viral genes.

The adjusted screen returned one MAG and zero vOTUs at FDR below 0.05; neither
community contained matched-CLR features after BH correction. Global exact
p-values were 0.125 for MAGs and 0.0625 for vOTUs. Treat all condition
coefficients as exploratory because condition remains confounded with membrane
identity. Canonical outputs are under
`PRJEB79569/derived/community_differential_abundance/`; the vector PDF is a
supplementary candidate and has not been inserted into Google Docs.

## Validation completed

- `Rscript tests/test_manuscript_registry.R`.
- `Rscript tests/test_manuscript_figure_candidates.R <canonical-output>`.
- `Rscript tests/test_taxonomic_timeseries_layouts.R`.
- `bash scripts/validate_manifests.sh`.
- `Rscript tests/test_quarto_entrypoints.R`.
- Quarto 1.9.37 structure renders for all 22 `scripts/*.qmd` notebooks with
  execution disabled.
- `pandoc manuscript/manuscript_skeleton.md --bibliography=manuscript/references.bib`.
- `git diff --check`.

The original suite passed on 2026-08-27. On 2026-08-28, the two taxonomic-context
PDFs and the two story-reorganized opening PDFs were rendered to PNG and visually
inspected. All 13 one-page vector
PDFs are governed by the candidate registry and checksum inventory. The
remaining-figure and taxonomic-context builders stage their outputs before
promotion.

The complete pre-16S audit passed on 2026-09-01 through
`bash scripts/run_pre_submission_audit.sh`: all 16 R tests, manifest checks,
all 22 no-execute Quarto structure renders, the Pandoc manuscript build,
figure checksums, and repository hygiene. Bakta, CAT/BAT, CheckV, and inStrain
versions are verified; unrecoverable CoverM and GTDB-release details are
explicitly recorded rather than inferred. Exact multiomics and host-phage
repository execution states are checksum-bound in
`manuscript/upstream_repository_provenance.tsv`. Issue #31 remains open only
because issue #30 has not returned and a final post-decision audit may be needed.

## Submission-readiness roadmap

GitHub issues #26-#34 are the controlling dependency-ordered roadmap. Issues #26
through #29 completed the evidence, figures, citations, and manuscript edit.
Issue #30 remains collaborator-owned for manifest confirmation and scientific
integration; the returned files themselves are now local. The agent-addressable
pre-16S work for #31 and #32 is complete and audited; both remain human-gated by
the 16S decision, author review, declarations, and live submission-day checks.
Issue #33 obtains author and coauthor approval, and #34 submits and archives
only the approved release.

ISME Communications is now a conditional target: the human-authoring and
AI-disclosure remediation must be completed before issue #33 can treat any
manuscript as approvable for that journal.

Work one issue at a time and close it only after its acceptance criteria are
evidenced. Once the user supplies revised or accepted prose, all agent changes
to that prose belong in Suggesting mode unless the user explicitly authorizes a
replacement.
