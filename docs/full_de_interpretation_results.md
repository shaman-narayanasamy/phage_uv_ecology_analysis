# Full-DE interpretation results

Date: 2026-08-10

These results implement GitHub issue #23 from the complete #22 tested-feature
universe. Methods and thresholds were frozen in
`docs/full_de_interpretation_plan.md`. The canonical generated output is
`PRJEB79569/derived/full_de_interpretation/` outside the repository.

## Result universe and annotation audit

- 361,907 tested features were retained without functional preselection.
- 342,605 features matched MAG-gene annotations, 27 MAG features remained
  unmatched, and 19,275 features were non-MAG features.
- All 342,632 tested MAG features mapped to the staged GTDB taxonomy table.
- 4,119 tested features belonged to at least one of the eight frozen UV/stress
  categories; six belonged to multiple categories and remain explicitly
  multiply assigned.

## Frozen functional family

Only two of 32 category-by-coefficient tests passed BH FDR 0.05.

- SOS-response genes were collectively higher-ranked for the phase- and
  cycle-adjusted condition coefficient (523 tested features; competitive
  rank-test FDR 0.0021). The median gene logFC was only 0.136 and 57.9% of the
  set had positive coefficients. This is a modest distributed SOS-associated
  transcriptional ranking in the observed two-membrane system, not evidence of
  DNA damage or UV-caused lesions.
- Redox-stress genes were higher-ranked for the cycle-2 interaction coefficient
  (1,227 tested features; FDR 0.0095). This coefficient is the change in the
  condition contrast at cycle 2 relative to cycle 1; it is not a standalone
  cycle-2 treatment effect.

No frozen category was supported for the cycle-3 interaction or the
two-degree-of-freedom condition-by-cycle omnibus. Photoreactivation,
nucleotide-excision repair, recombination repair, oxidative stress,
base-excision/oxidative repair, and general stress were not supported for the
adjusted condition coefficient. These negative and heterogeneous findings are
part of the result, not reasons to redefine the category family.

## Organism-resolved structure

Of 348 classified MAGs, 340 met the predeclared expression-support criteria.
Competitive MAG-set tests found widespread, bidirectional organism structure:

- adjusted condition: 175 of 340 MAGs supported, 100 higher-ranked and 75
  lower-ranked;
- cycle-2 interaction: 133 supported, 68 higher-ranked and 65 lower-ranked;
- cycle-3 interaction: 132 supported, 73 higher-ranked and 59 lower-ranked.

This breadth and bidirectionality argue against a single uniform stress
program. They are consistent with strong organism-specific differences between
the two repeatedly sampled membranes. Because membrane identity and condition
are confounded, the MAG rankings are descriptive and cannot establish a
population-level treatment response.

## Recurrent gene candidates

The predeclared effect, detection, annotation, and six-cell recurrence filter
retained 6,985 genes: 3,334 recurrently treatment-higher and 3,651 recurrently
control-higher. The balanced directions again indicate broad ecological and
transcriptional differentiation rather than a one-way DNA-repair response.
Candidate loci include transport, carbohydrate metabolism, secretion,
ribosomal, motility, and general regulatory functions, but these annotations
are currently a discovery list rather than a frozen pathway-family test.

## Manuscript boundary

The strongest defensible interpretation is a heterogeneous, organism-resolved
transcriptional restructuring of the two-membrane system, with a modest
SOS-associated ranking but no broad or recurrent DNA-damage program. The
condition coefficient remains confounded with membrane identity. Figures are
unnumbered and unallocated; #24 must decide what belongs in main text versus
supplement and must retain the negative category results.
