# Community differential-abundance analysis

## Why this analysis exists

The original poster stated that community structure did not differ significantly
between the treatment and control cycles. Its source notebook contained a
condition-only DESeq2 analysis for MAG abundance and sample-level PERMANOVA.
That analysis had not been carried into the reconstructed manuscript workflow.

`scripts/run_community_differential_abundance.qmd` now reproduces the poster-era
condition-only test and adds the same current-data analysis for the viral
community. It also adds phase/cycle adjustment, matched time-point log-ratio
effect sizes, exhaustive sign-flip tests, and paired restricted-permutation
Bray-Curtis tests.

## Verified current result

| Community | Condition-only DESeq2 | Phase/cycle-adjusted DESeq2 | Paired global test | Matched CLR after BH |
|---|---:|---:|---:|---:|
| MAG | 0 of 337 at FDR < 0.05 | 1 of 348 at FDR < 0.05 and absolute log2FC >= 1 | exact p = 0.125 | 0 of 348 |
| vOTU | 2 of 529 at FDR < 0.05 and absolute log2FC >= 1 | 0 of 560 at FDR < 0.05 | exact p = 0.0625 | 0 of 616 |

The single adjusted MAG hit was `CI3_MAGScoT_cleanbin_000045`, classified to
Bdellovibrionota and Bacteriovoracaceae*, with lower estimated abundance in the
phage-UV membrane. It did not retain BH support in the matched CLR analysis.
The two condition-only vOTU hits disappeared after phase/cycle adjustment.

## Interpretation boundary

Only one membrane represented each condition. Repeated phase/cycle samples are
longitudinal observations, not independent biological membrane replicates.
Accordingly, these analyses can identify trajectories and candidate abundance
differences, but they cannot distinguish a treatment effect from membrane
identity. The condition-only no-discovery result was reproduced; it is not an
equivalence test or evidence that the communities are unchanged.

The exhaustive calculations enumerate 64 independent within-cell swaps or
sign patterns. They do not preserve the whole-membrane trajectories and must
not be described as a valid randomisation test of the experimental treatment.
For two-sided CLR sign flips the minimum attainable P value is 2/64 = 0.03125;
these low-resolution sensitivities also undergo correction over 348 or 616
features. Lack of corrected support therefore cannot be used to validate a
null or to establish that the isolated count-model hit is false. Report the
model dependence and effect sizes, with all P values explicitly conditional
on unverified exchangeability/model assumptions in this unreplicated design.

The canonical checksum-bound outputs are under
`PRJEB79569/derived/community_differential_abundance/` outside the code checkout.
