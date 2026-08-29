# Manuscript figure plan

Status: pre-16S allocation frozen after complete visual review on 2026-08-29.
Artifact filenames remain unnumbered so the allocation can be revised without
breaking provenance.

The current main-text and supplementary candidates have been reviewed together.
Every candidate and supplementary figure must use
`R/figure_style.R` and the fixed visual mappings in `docs/figure_visual_grammar.md`.

## Frozen pre-16S manuscript allocation

The working draft uses the following labels so that every quantitative claim has
an explicit destination. These labels can change during author review without
renaming the canonical artifacts.

1. Figure 1: `community-transcriptome-trajectory.pdf`.
2. Figure 2: `transcriptome-response-architecture.pdf`.
3. Figure 3: `recurrent-gene-structure.pdf`.
4. Figure 4: `population-genomic-heterogeneity.pdf`.
5. Figure 5: conditional insertion point for the delegated 16S result; it is
   included only if the returned analysis materially improves the story.
6. Supplementary Figures S1-S5: model diagnostics, cycle interactions, all
   functional coefficients, all MAG coefficients, and all five population-genomic
   pairwise landscapes, respectively.
7. Supplementary Figure S6: `mag-taxonomic-context.pdf`.
8. Supplementary Figure S7: `votu-taxonomic-context.pdf`.

## Current candidate set

1. Experimental system, community trajectory, and transcriptome geometry:
   - one membrane per condition across three cycles and two phases;
   - aligned top-25 family profiles from MAG-mapped metagenomic reads;
   - sample-level expression geometry after the community has been shown.
2. Transcriptome-wide, functional, and organism-resolved restructuring:
   - complete-universe adjusted-condition effect landscape;
   - competitive tests for all eight frozen functional categories;
   - supported MAGs in both expression directions;
   - the strongest organism-level effects with taxonomic context.
3. Six-cell recurrent gene differences:
   - built as `recurrent-gene-structure.pdf` and visually checked;
   - sequential provenance from 361,907 tested features to 6,985 recurrent
     predeclared candidates;
   - balanced phage-UV-higher and control-higher recurrence with five-of-six
     versus six-of-six cell concordance visible;
   - 12 genes per direction selected deterministically by condition FDR, then
     absolute condition log2 fold-change, for a legible six-cell heatmap.
4. Descriptive population-genomic heterogeneity:
   - built as `population-genomic-heterogeneity.pdf` and visually checked;
   - strain membership across five coverage-qualified MAGs;
   - median and range of pairwise consensus differences per callable Mbp;
   - a focused *Propionicimonas* pairwise landscape;
   - coverage-qualified structure for the five scoped MAGs;
   - no damage, mutagenesis, adaptation, accumulation, or treatment-effect inference.
5. Delegated 16S community structure:
   - reserved until the external collaborator returns the verified analysis;
   - expected to contribute community composition and ordination, without blocking
     the current figure work;
   - expected to validate or extend the community layer introduced in Figure 1,
     not to postpone all community context until the end of the story.

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
