# Descriptive population genomics

Date: 2026-08-01; denominator and release-source audit 2026-09-09

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
- pair-level: inStrain-reported `percent_compared` at least 0.50;
- MAG-level: at least 10 pairwise comparisons passing both pair rules;
- MAG-level: the passing pairs span at least six observed samples.

Five MAGs pass. Grey cells represent unavailable pairs or pairs that fail the
coverage rules. The plotted value is the number of consensus SNP differences
per million compared bases, displayed on a log-scaled colour axis. Normalizing
by compared bases avoids presenting raw SNV distance as though all pairs had the
same callable genome length.

The pinned inStrain 1.10.0 source defines `percent_compared` as compared bases
divided by the summed lengths of scaffolds retained by the comparison. The
archived log contains 2708 scaffold-length exclusions across the scoped input,
so this denominator must not be assumed to equal a full MAG without checking.
The independent dRep-length audit confirms exact equality for all five
displayed MAGs, no missing-length scaffolds in those MAGs, and no change to
their 139 qualified comparisons under a full-catalogue-length filter. Among
the 15 MAGs with comparison rows, only the non-selected
`CBF1_MAGScoT_cleanbin_000067` has a reduced denominator (4661422 versus
4663029 bp); no pair or MAG eligibility changes under the full-length check.

Reproducible, read-only notebooks are
`manuscript/instrain_release_source_audit.qmd` and
`manuscript/instrain_denominator_audit.qmd`. Their versioned outputs are under
`derived/instrain_release_source_audit_2026-09-09/` and
`derived/instrain_denominator_audit_2026-09-09/`.
`tests/test_instrain_provenance.py` verifies the pinned release hash, original
inputs, all 191 genome-wide comparison rows and selected-set stability.

Release 1.10.0 defines average-linkage clustering at population ANI 0.99999,
with comparison distance set to 1 below reported compared fraction 0.10.
The archived completed invocation specifies no clustering override. This
identifies published defaults, not independently recovered historical installed
source. Existing cluster assignments are retained without reclustering;
display labels remove the MAG-specific prefix and prepend `S`.

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
was retained when at least 1 Mbp was compared and the reported compared fraction
was at least 0.50 (verified to use the full catalogue length for these five MAGs).
Grey cells denote unavailable or coverage-failing pairs; diagonal cells denote
self-comparisons. C, control membrane; P, phage-UV-treated membrane; I, initial
fraction; BF, backflush fraction. Colour is log-scaled. The scoped MAG set is
not community-representative, and the panel is descriptive rather than evidence
of DNA damage, mutagenesis, or a treatment effect.

## Reproduction

- Script: `scripts/build_population_genomics_descriptive.qmd`
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
