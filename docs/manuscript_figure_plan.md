# Manuscript figure plan

Status: complete candidate architecture. Artifact filenames remain unnumbered;
the manuscript uses provisional numbering for review.

Figures are being built before the manuscript argument is frozen. Main-text versus
supplementary placement and panel assignments remain open until the candidates have
been reviewed together. Every candidate and supplementary figure must use
`R/figure_style.R` and the fixed visual mappings in `docs/figure_visual_grammar.md`.

## Provisional manuscript allocation

The working draft uses the following labels so that every quantitative claim has
an explicit destination. These labels can change during author review without
renaming the canonical artifacts.

1. Figure 1: `global-transcriptome-structure.pdf`.
2. Figure 2: `functional-organism-restructuring.pdf`.
3. Figure 3: `recurrent-gene-structure.pdf`.
4. Figure 4: `population-genomic-heterogeneity.pdf`.
5. Figure 5: reserved for the delegated 16S result.
6. Supplementary Figures S1-S5: model diagnostics, cycle interactions, all
   functional coefficients, all MAG coefficients, and all five population-genomic
   pairwise landscapes, respectively.

## Current candidate set

1. Experimental design and global transcriptome structure:
   - one membrane per condition across three cycles and two phases;
   - sample-level expression geometry;
   - complete-universe adjusted-condition effect landscape.
2. Functional and organism-resolved restructuring:
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
     the current figure work.

## Additional unallocated candidates

1. `mag-taxonomic-context.pdf`:
   - taxonomy-derived circular dendrogram for all 348 dereplicated MAGs;
   - fixed phylum colours plus current adjusted-membrane coherence,
     recurrent-gene balance, completeness, and contamination rings;
   - descriptive taxonomic context, not a marker-gene or genome sequence
     phylogeny.
2. `votu-taxonomic-context.pdf`:
   - taxonomy-derived cladogram of 607 deduplicated high-quality vOTUs grouped
     into 45 current taxonomy paths;
   - accompanying realm-level catalogue composition;
   - descriptive catalogue context only, with no treatment-response or
     host-phage inference.

These candidates restore the useful descriptive tree concepts from the
original poster without importing its superseded expression overlays. Their
main-text or supplementary placement and any panel combination remain open.

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
