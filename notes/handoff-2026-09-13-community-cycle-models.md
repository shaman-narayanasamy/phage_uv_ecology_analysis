# MAG/vOTU cycle-model extension

Date: 2026-09-13. Local analysis candidate; no manuscript or figure replacements.
Susana's separate 16S request is published at commit `509fe16`; see
`notes/handoff-2026-09-13-susana-16s-models-pointer.md`.

## Canonical implementation

- Notebook: `analysis/community_cycle_models.qmd`.
- Tests: `tests/test_community_cycle_models.R`.
- Outputs: `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/community_cycle_models_2026-09-13-v1/`.
- Previous additive analysis remains unchanged in `derived/community_differential_abundance/`.

Raw metagenomic CoverM counts are summed per MAG or selected per high-quality
vOTU with viral genes. The same predecessor catalogue rules retain 348 MAGs and
616 eligible vOTUs before filtering. Counts are rounded as in the predecessor;
per-feature maximum rounding differences are exported. Requiring count >=10 in
at least three samples retains 348 MAGs and 560 vOTUs. This is not a family- or
genus-aggregated analysis. Each community is normalised separately.

## Models and tests

DESeq2 1.50.2, local dispersion trend, categorical cycle 1/2/3. References are
control, initial, cycle 1. Twelve samples; main design rank 5 (7 residual df),
full design rank 7 (5 residual df).

```r
main <- ~ phase + cycle + condition
full <- ~ phase + cycle * condition
reduced <- ~ phase + cycle + condition
```

The main condition test is Wald. The full-versus-reduced likelihood-ratio test
jointly tests the two interactions (2 df). The joint table deliberately excludes
DESeq2's default displayed log fold change: that coefficient is not the omnibus
effect. Separate secondary Wald interaction coefficients retain explicit names
and BH correction across both coefficients per community. Main and joint tests
use separate per-community feature families; independent-filtering defaults are
retained and unfiltered all-nonmissing BH columns are also supplied.

Source method: https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html

## Initial findings

| Community | Features retained | Main FDR <0.05 | Joint interaction FDR <0.05 |
|---|---:|---:|---:|
| MAG | 348 | 1 | 1 |
| vOTU | 560 | 0 | 4 |

These counts are unchanged using the additional all-nonmissing BH column.
All main-model feature IDs, log2 fold changes, p-values and adjusted p-values
agree with the predecessor exports (`all.equal` TRUE for both communities).

The interacting MAG is `CI3_MAGScoT_cleanbin_000027` (FDR 0.02326).
Interacting vOTUs are:

- `CI3_coassembly_megahit_CI3_contig_k141_1679835` (FDR 0.02902)
- `TBF3_coassembly_megahit_TBF3_contig_k141_2493445` (FDR 1.95e-6)
- `TI3_coassembly_megahit_TI3_contig_k141_922117` (FDR 0.001211)
- `TI3_coassembly_megahit_TI3_contig_k141_1734682` (FDR 9.33e-6)

Next: inspect these features' taxonomy, raw/normalised trajectories and influence
diagnostics, then create unnumbered review figures. No figure allocation or
manuscript claim follows automatically from an FDR threshold.

## Validation and interpretation

Full fitted RDS objects, design matrices, sample map, feature filters, raw and
normalised counts, size factors, dispersion/convergence diagnostics and Cook's
distances are retained. Input/output SHA256 inventories bind the run. Tests
recompute BH and chi-square p-values and rerun the LRT from saved dispersions.
Post-run validation PASS for both communities: hashes, sample mapping, count
filter, design rank, full/reduced convergence, BH, chi-square probabilities and
independently repeated LRT. The original additive exports also reproduce exactly
within R's `all.equal` tolerance. This validates implementation, not independent
biological replication or robustness to every modelling assumption.

These models assume the remaining residual structure is adequately described
by their count model; no random effects or temporal autocorrelation was fitted.
Condition is inseparable from membrane identity. Interpret as system-specific
abundance differences and differing trajectories, not replicated causal treatment
effects. Sequencing abundance is not absolute microbial load. This interaction
is not a test of all cycle changes shared by both membranes.

## Suggested skills

`mattpocock-skills:diagnose` for numerical failures;
`mattpocock-skills:handoff` for continuation;
`pdf:pdf` when producing the next vector figure previews.
