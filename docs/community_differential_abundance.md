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
identity. The most defensible summary is that the poster's microbial null result
was reproduced and that no abundance signal was robust across the adjusted,
matched, and global community analyses.

The canonical checksum-bound outputs are under
`PRJEB79569/derived/community_differential_abundance/` outside the code checkout.
