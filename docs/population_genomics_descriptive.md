# Descriptive population genomics

Date: 2026-08-01

## Purpose and boundary

The inStrain output is retained only as a qualitative view of population-genomic
stability and turnover among sufficiently covered MAGs. It is not a DNA-damage
assay. The figure makes no statistical comparison by condition, cycle, or phase
and supports no claim about lesions, mutagenesis, adaptation, mutation
accumulation, or treatment causality.

The source is the scoped priority-20 inStrain run. Those MAGs were originally
prioritized using host-link and UV-signature information, so they are not a
random or community-representative MAG set. The figure cannot estimate how
common any displayed pattern is in the full community.

## Coverage rules

Rules are applied before viewing the population-genomic pattern:

- pair-level: at least 1,000,000 compared bases;
- pair-level: at least 50% of the callable genome compared;
- MAG-level: at least 10 pairwise comparisons passing both pair rules;
- MAG-level: the passing pairs span at least six observed samples.

Five MAGs pass. Grey cells represent unavailable pairs or pairs that fail the
coverage rules. The plotted value is the number of consensus SNP differences
per million compared bases, displayed on a log-scaled colour axis. Normalizing
by compared bases avoids presenting raw SNV distance as though all pairs had the
same callable genome length.

## Qualitative reading

The panel shows substantial heterogeneity among MAGs and uneven sample
availability within MAGs. Median consensus differences per Mbp among the five
displayed MAGs range from approximately 29 to 1,114. This range is descriptive;
it is not a ranked treatment response.

Any manuscript text should be limited to observations such as:

> Coverage-qualified metagenomic comparisons revealed heterogeneous pairwise
> population-genomic similarity among five scoped MAGs. These patterns are
> presented descriptively as possible stability or turnover and are not
> interpreted as treatment-induced mutation.

## Caption draft

**Coverage-qualified pairwise population-genomic landscape.** Heatmaps show
consensus SNP differences per million compared bases for five MAGs with at
least ten qualified pairwise comparisons spanning at least six samples. A pair
was retained when at least 1 Mbp and 50% of the callable genome were compared.
Grey cells denote unavailable or coverage-failing pairs; diagonal cells denote
self-comparisons. C, control membrane; P, phage-UV-treated membrane; I, initial
fraction; BF, backflush fraction. Colour is log-scaled. The scoped MAG set is
not community-representative, and the panel is descriptive rather than evidence
of DNA damage, mutagenesis, or a treatment effect.

## Reproduction

- Script: `scripts/build_population_genomics_descriptive.R`
- Pair QC table:
  `PRJEB79569/derived/manuscript_candidates/tables/population_genomics_pair_qc.tsv`
- MAG QC table:
  `PRJEB79569/derived/manuscript_candidates/tables/population_genomics_mag_qc.tsv`
- Figure:
  `PRJEB79569/derived/manuscript_candidates/figures/population-genomics-pairwise-landscape.pdf`

## Organism-level continuation

The five qualified MAGs have now been assessed individually using staged
per-sample SNV and scaffold tables. The organism-level QC rules, figures, and
manuscript-safe interpretation are documented in
`docs/mag_by_mag_genomic_variation.md`. That analysis stays within the same
descriptive boundary and does not reinstate condition, damage, mutation, or
adaptation inference.
