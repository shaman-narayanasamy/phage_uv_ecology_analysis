# Cross-omics Bray-Curtis permutation results

## Results text

Community dissimilarity was strongly concordant across the three molecular
readouts. Bray-Curtis distance matrices were correlated for metagenomics and
metatranscriptomics (Spearman ρ = 0.795), metagenomics and cDNA-derived 16S
profiles (ρ = 0.820), and metatranscriptomics and 16S profiles (ρ = 0.938).
Matrix-level sample-label permutations supported all three associations after
Benjamini-Hochberg correction (FDR (BH) = 1.5 × 10^-5, 4.0 × 10^-5 and 1.5 × 10^-5,
respectively). The associations were retained when cycle labels were permuted
only within each condition-by-phase stratum (FDR (BH) = 7.72 × 10^-4 for all three
comparisons), showing that the concordance was not explained solely by the
shared condition and sampling-phase structure.

## Methods text

Cross-assay concordance was quantified as the Spearman correlation between the
corresponding lower triangles of the Bray-Curtis distance matrices for the 12
matched samples. Significance was assessed without treating the 66 distances as
independent observations. Global two-sided tests used 99,999 random permutations
of sample labels in the second matrix. A design-constrained sensitivity test
enumerated all 1,296 permutations of the three cycle labels independently within
the four condition-by-phase strata. Monte Carlo P values used a plus-one
correction; exact constrained P values included the observed labelling.
Benjamini-Hochberg correction was applied across the three assay comparisons
separately for each permutation scheme.

## Figure caption

**Cross-assay concordance of community dissimilarity. A,** Spearman correlations
between corresponding Bray-Curtis dissimilarities from 12 matched samples (66
unique sample pairs) profiled by metagenomics (MG), metatranscriptomics (MT) and
cDNA-derived 16S sequencing. **B,** Benjamini-Hochberg-adjusted permutation
FDR (BH) values. Circles show global sample-label tests using 99,999 random
permutations; triangles show exact tests over all 1,296 cycle-label permutations
within condition-by-phase strata. The dashed line denotes FDR (BH) = 0.05. Tests were
two-sided and correction was applied across the three assay comparisons
separately within each permutation scheme.

## Allocation

Author allocated the statistical table as **Supplementary Table S1** on
2026-09-16. The compact figure is retained as an internal/optional visual and is
not currently allocated to the manuscript. Canonical outputs:

- `PRJEB79569/derived/community_cross_omics_permutation_2026-09-16-v3/figures/bray_curtis_concordance_tests.pdf`
- `PRJEB79569/derived/community_cross_omics_permutation_2026-09-16-v3/tables/bray_curtis_matrix_permutation_tests.tsv`
- `PRJEB79569/derived/community_cross_omics_permutation_2026-09-16-v3/tables/bray_curtis_matrix_permutation_tests.md`

The test supports cross-assay concordance; it does not create independent
biological replication of Treatment and Control membranes.
