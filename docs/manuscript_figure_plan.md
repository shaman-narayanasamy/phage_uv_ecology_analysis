# Manuscript figure plan

Status: author-directed allocation revised on 2026-09-01. Figure 1 describes
the microbial and phage communities. Supplementary Figure S8 contains the
host-phage evidence audit and S9 contains detailed community-abundance tests.
Artifact filenames remain unnumbered so the allocation can be revised without
breaking provenance.

The current main-text and supplementary candidates have been reviewed together.
Every candidate and supplementary figure must use
`R/figure_style.R` and the fixed visual mappings in `docs/figure_visual_grammar.md`.

## Current author-directed manuscript allocation

The working draft uses the following labels so that every quantitative claim has
an explicit destination. These labels can change during author review without
renaming the canonical artifacts.

1. Figure 1: `community-structure-figure-one.pdf`.
2. Figure 2: `global-transcriptome-structure.pdf`.
3. Figure 3: `transcriptome-response-architecture.pdf`.
4. Figure 4: `recurrent-gene-structure.pdf`.
5. Figure 5: `population-genomic-heterogeneity.pdf`.
6. Supplementary Figures S1-S5: model diagnostics, cycle interactions, all
   functional coefficients, all MAG coefficients, and all five population-genomic
   pairwise landscapes, respectively.
7. Supplementary Figure S6: `mag-taxonomic-context.pdf`.
8. Supplementary Figure S7: `votu-taxonomic-context.pdf`.
9. Supplementary Figure S8: `host-phage-network-evidence-audit.pdf`.
10. Supplementary Figure S9: `community-differential-abundance.pdf`.

The independently delegated 16S result has returned and passed the canonical
12-sample contract. Its longitudinal and workflow candidates are now available
for allocation, but no main-versus-supplement placement is imposed before
author review.

## Current candidate set

1. Experimental system and microbial and phage community structure:
   - one membrane per condition across three cycles and two phases;
   - aligned top-25 family profiles from MAG-mapped metagenomic reads;
   - high-level vOTU realm profiles across the same observations;
   - microbial and vOTU Bray-Curtis ordinations with exhaustive paired-label
     tests and explicit exploratory-design boundaries.
2. Global transcriptome structure:
   - filtered-expression geometry across all 12 physical samples;
   - complete-universe adjusted-condition effect landscape.
3. Transcriptome-wide, functional, and organism-resolved restructuring:
   - complete-universe adjusted-condition effect landscape;
   - competitive tests for all eight frozen functional categories;
   - supported MAGs in both expression directions;
   - the strongest organism-level effects with taxonomic context.
4. Six-cell recurrent gene differences:
   - built as `recurrent-gene-structure.pdf` and visually checked;
   - sequential provenance from 361,907 tested features to 6,985 recurrent
     predeclared candidates;
   - balanced phage-UV-higher and control-higher recurrence with five-of-six
     versus six-of-six cell concordance visible;
   - 12 genes per direction selected deterministically by condition FDR, then
     absolute condition log2 fold-change, for a legible six-cell heatmap.
5. Descriptive population-genomic heterogeneity:
   - built as `population-genomic-heterogeneity.pdf` and visually checked;
   - strain membership across five coverage-qualified MAGs;
   - median and range of pairwise consensus differences per callable Mbp;
   - a focused *Propionicimonas* pairwise landscape;
   - coverage-qualified structure for the five scoped MAGs;
   - no damage, mutagenesis, adaptation, accumulation, or treatment-effect inference.
6. Delegated 16S community structure:
   - 12 samples and 2,700 ASVs assigned with SILVA 138.2;
   - aligned family composition, Bray-Curtis trajectories, alpha diversity,
     and consecutive-cycle turnover are available as a visually verified
     vector candidate;
   - all four membrane-by-phase trajectories show lower C2-to-C3 than C1-to-C2
     Bray-Curtis turnover, a descriptive recurrence with no formal time-series
     or treatment-effect inference;
   - the collaborator's unrestricted PERMANOVA p-values are not
     manuscript-ready for the repeated two-membrane design.

## Returned 16S and complete-study overview candidates

1. `16s-longitudinal-community-context.pdf`:
   - top-12 family composition in aligned stacked bars;
   - directed Bray-Curtis PCoA trajectories across cycles;
   - observed-ASV and Shannon-diversity trajectories;
   - exact consecutive-cycle Bray-Curtis turnover derived from the unrarefied
     ASV table;
   - shared family labels retain the fixed manuscript colour mapping.
2. `study-analysis-workflow.pdf`:
   - connects the two-membrane, three-cycle sampling design to 16S,
     metagenomic, and metatranscriptomic data layers;
   - records the DADA2/SILVA, MAG/vOTU, full-universe edgeR,
     population-genomic, and CRISPR-link branches;
   - displays the one-membrane-per-condition inference boundary directly.

Both artifacts are unnumbered candidates under
`PRJEB79569/derived/16s_manuscript_integration/`. The workflow is a strong
main-text overview candidate; the 16S longitudinal figure can either refine the
community opening or become a dedicated supplementary figure after author
review.

## Preserved earlier layouts

1. `global-transcriptome-structure.pdf` and
   `functional-organism-restructuring.pdf` remain checksum-governed as the
   analysis-led v1 layouts. Their panels have been recomposed into Figures 1
   and 2 above; they are retained for provenance, not proposed as additional
   manuscript figures.

## Supplementary taxonomic context

1. `mag-taxonomic-context.pdf`:
   - taxonomy-derived circular dendrogram for all 348 dereplicated MAGs;
   - concentric rings ordered from the tree outwards as completeness,
     contamination, current adjusted-membrane coherence, and recurrent-gene
     balance;
   - accompanying legacy 12-sample family-level relative-abundance profile from
     MAG-mapped metagenomic reads; the clearer top-25 microshades version is now
     displayed prominently in Figure 1;
   - control above phage-UV with the six cycle-phase positions aligned on a
     shared horizontal axis;
   - descriptive taxonomic context, not a marker-gene or genome sequence
     phylogeny.
2. `votu-taxonomic-context.pdf`:
   - taxonomy-derived cladogram of 607 deduplicated high-quality vOTUs grouped
     into 45 current taxonomy paths;
   - accompanying realm-level catalogue composition;
   - descriptive catalogue context only, with no treatment-response or
     host-phage inference.

These supplementary candidates restore the useful descriptive tree concepts from the
original poster without importing its superseded expression overlays. Their
descriptive status is explicit: neither tree is a sequence phylogeny, and the
viral panel carries no treatment-response or host-phage inference.

## Integrated taxonomic layout comparison

Four review candidates combine catalogue structure with longitudinal
composition without replacing the working manuscript figures:

1. `mag-taxonomy-family-bars.pdf` and `mag-taxonomy-family-area.pdf` pair the
   348-MAG taxonomy-derived dendrogram and quality/interpretation rings with the
   aligned top-25 family profile.
2. `votu-taxonomy-realm-bars.pdf` and `votu-taxonomy-realm-area.pdf` pair the
   607-vOTU taxonomy-derived cladogram with a genuine 12-sample metagenomic
   read profile summarized at realm level.

The stacked-bar versions are recommended. The six cycle-phase positions are
discrete observations, and bars preserve that sampling structure. Stacked areas
connect the observations with straight segments, which makes trajectories look
continuous and turns the 25-family MAG profile into difficult-to-follow ribbons.
At viral realm level, Duplodnaviria contributes 93.3-97.1% of mapped reads in
every sample. That dominance is an informative high-level catalogue result, but
it leaves little longitudinal taxonomic restructuring to display. The viral
panel is therefore supplementary context unless a more resolved, prespecified
viral question earns a main-text role.

## Host-phage network allocation

`host-phage-network-evidence-audit.pdf` restores the interaction layer visible
in the original poster without reusing its quarantined subset-first expression
filter. It contains 86 deduplicated SpacePHARER host-phage candidate pairs
linking 80 MAGs to 85 phage contigs. The host overlay uses only the current
complete-transcriptome adjusted membrane coefficient. The accompanying audit
shows that 12 linked phage representatives have current catalogue annotation
and none passes the manuscript's high-quality classified-vOTU filter.

This is allocated as Supplementary Figure S8. The links are compatible with
historical CRISPR exposure, but do not demonstrate active infection, treatment
response, host range, adsorption through biofilm, or causal connection to the
MAG transcriptional coefficient.

## Current supplementary set

1. `supplementary-model-diagnostics.pdf`:
   - feature filtering, retained and effective library sizes, and model-dispersion
     summaries.
2. `supplementary-cycle-interaction-landscape.pdf`:
   - complete-universe cycle-2, cycle-3, and interaction-omnibus feature landscapes;
   - interaction coefficients are departures from cycle 1, not standalone cycle
     treatment effects.
3. `supplementary-functional-coefficients.pdf`:
   - all eight frozen repair and stress categories across all four predeclared
     coefficient families.
4. `supplementary-mag-coherence.pdf`:
   - supported MAG counts and MAG-level coherence across the three directional
     coefficients.
5. `supplementary-population-genomics.pdf`:
   - complete coverage-qualified pairwise landscapes for all five scoped MAGs.
6. `community-differential-abundance.pdf`:
   - poster-style and design-aware MAG and vOTU abundance comparisons;
   - matched CLR and exhaustive paired-label sensitivity tests;
   - allocated as Supplementary Figure S9 because no robust community-wide or
     feature-level pattern survives the full sensitivity analysis.

The six-cell recurrence figure already contains its selection provenance,
direction-concordance counts, and a balanced gene catalogue, so no redundant
supplementary recurrence panel is created.

## Excluded figure sources

Subset-first SOS, UV-response, DNA-repair, RNA:DNA, temporal-module, and
module-clustering figures remain quarantined. The retired broad inStrain comparison
cannot be revived as manuscript evidence. Inferential candidates may use only
full-universe expression outputs and the separately governed descriptive
population-genomics outputs. Current quality and taxonomy catalogues may feed
clearly labelled descriptive context figures without becoming treatment evidence.
