# Handoff: PRJEB79569 full manuscript draft

Date: 2026-08-27; updated 2026-08-28

This is the controlling scientific handoff. Start here, then read
`docs/codex_context.md`. Do not reconstruct the project from chat, storage
cleanup, old tickets, or quarantined subset-first expression analyses.

## Current state

The full current-evidence figure suite and a complete venue-neutral manuscript
draft are ready for author review.

- Working manuscript: `manuscript/manuscript_skeleton.md`.
- Descriptive legends: `manuscript/figure_legends.md`.
- Zotero import file: `manuscript/references.bib`.
- Claim audit: `manuscript/claim_evidence_registry.tsv`.
- Analysis-use boundary: `manuscript/analysis_registry.tsv`.
- Figure architecture: `docs/manuscript_figure_plan.md`.
- Fixed visual mappings: `docs/figure_visual_grammar.md`.
- Canonical figure output:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/manuscript_figure_candidates/`.

The first draft was written under the knowledgebase scientific-writing and
writing-voice protocols. It retains negative results, anchors quantitative
claims to figures and tables, avoids em dashes, and ends each Results section
with the evidence-bounded finding. It remains agent-authored text. Regular
editing is permitted until the user begins revising accepted prose; after that,
work in Suggesting mode.

## Working argument

The main result is heterogeneous organism-resolved transcriptional
restructuring between the two repeatedly sampled membranes.

1. Cleaning cycle dominates the leading expression geometry. The two membranes
   do not show a simple global separation in the MDS.
2. After adjustment for phase and cycle, the membrane coefficient is broad and
   bidirectional: 7,703 features have FDR below 0.05 and 7,699 also have
   absolute log2 fold-change at least 1.
3. Functional support is narrow. SOS genes are collectively higher-ranked, but
   their median log2 fold-change is 0.136 and the other seven frozen repair and
   stress categories are unsupported for the adjusted membrane coefficient.
4. Organism-level coherence is widespread and bidirectional: 175 of 340
   eligible MAGs are supported, split between 100 phage-UV-higher and 75
   control-higher gene sets.
5. The recurrence filter retains 6,985 genes, split between 3,334 phage-UV
   higher and 3,651 control higher.
6. Five coverage-qualified MAGs show organism-specific genomic stability and
   turnover. This layer is descriptive and does not support damage, mutation,
   adaptation, or treatment-effect claims.

## Provisional figure allocation

Canonical artifacts remain unnumbered so the authors can reallocate them
without renaming files. The working draft uses:

1. Figure 1: `global-transcriptome-structure.pdf`.
2. Figure 2: `functional-organism-restructuring.pdf`.
3. Figure 3: `recurrent-gene-structure.pdf`.
4. Figure 4: `population-genomic-heterogeneity.pdf`.
5. Figure 5: reserved for the independently delegated 16S result.
6. Supplementary Figure S1: `supplementary-model-diagnostics.pdf`.
7. Supplementary Figure S2: `supplementary-cycle-interaction-landscape.pdf`.
8. Supplementary Figure S3: `supplementary-functional-coefficients.pdf`.
9. Supplementary Figure S4: `supplementary-mag-coherence.pdf`.
10. Supplementary Figure S5: `supplementary-population-genomics.pdf`.

Two additional candidates remain deliberately unallocated:

- `mag-taxonomic-context.pdf`: taxonomy-derived 348-MAG dendrogram with rings
  ordered as completeness, contamination, current full-universe post-model MAG
  coherence, and recurrent-gene balance, alongside a descriptive family-level
  community profile based on MAG-mapped metagenomic reads;
- `votu-taxonomic-context.pdf`: taxonomy-derived cladogram of 607 current
  high-quality vOTUs in 45 taxonomy groups plus realm composition.

Neither is a sequence phylogeny. The vOTU candidate is descriptive only and
does not support treatment-response or host-phage inference.

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
- Host-phage links remain deferred unless they materially clarify a supported
  organism-level result.
- The 16S analysis is owned by the external expert collaborator. Do not manage,
  audit, or rerun it from this workstream. Preserve the Figure 5 insertion point.

## Google Docs and Zotero

The existing Google Doc is:
`https://docs.google.com/document/d/1BwtV8cU5anyC8yFYUmiG09fIa-buT0t425bkm1tiTXs/edit?tab=t.0`.

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

The agent authored this draft, so regular editing mode is appropriate while the
user begins commenting and suggesting. If the user supplies revised or accepted
prose for further editing, work only in Suggesting mode unless explicitly asked
to replace it.

No direct Zotero connector was available to the agent. The ten DOI-addressed
records in `manuscript/references.bib` are the verified import queue. Import
them into Zotero, then use Zotero field codes in Google Docs. Do not pretend
that plain author-year text is a live Zotero citation.

## Quarto execution contract

All 17 standalone analysis entrypoints in `scripts/` are now canonical Quarto
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

## Validation completed

- `Rscript tests/test_manuscript_registry.R`.
- `Rscript tests/test_manuscript_figure_candidates.R <canonical-output>`.
- `bash scripts/validate_manifests.sh`.
- `Rscript tests/test_quarto_entrypoints.R`.
- Quarto 1.9.37 structure renders for all 17 `scripts/*.qmd` notebooks with
  execution disabled.
- `pandoc manuscript/manuscript_skeleton.md --bibliography=manuscript/references.bib`.
- `git diff --check`.

The original suite passed on 2026-08-27. On 2026-08-28, the two taxonomic-context
PDFs were also rendered to PNG and visually inspected. All 11 one-page vector
PDFs are governed by the candidate registry and checksum inventory. The
remaining-figure and taxonomic-context builders stage their outputs before
promotion.

## Next action

Begin author review in the versioned Google Doc and import
`manuscript/references.bib` into Zotero. Preserve the delegated 16S insertion
point. Once the user supplies revised or accepted prose, all agent changes to
that prose belong in Suggesting mode unless the user explicitly authorizes a
replacement.
