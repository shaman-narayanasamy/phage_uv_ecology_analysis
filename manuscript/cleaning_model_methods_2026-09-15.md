# Cleaning performance and candidate MAG modelling

## Composite cleaning performance

We developed a cleaning-performance score combining sequential release measurements and transmembrane-pressure (TMP) regrowth lag, following the engineering interpretation of Myshkevych et al. (2025; doi:10.1016/j.ceja.2025.100796).

For each membrane-cycle observation and readout k (cells, protein or polysaccharides), I and BF denote the amounts recovered in the initial and backflush fractions. We calculated:

\[R_k=\frac{I_k}{I_k+BF_k},\qquad \bar R=\frac{R_{\rm cells}+R_{\rm protein}+R_{\rm polysaccharides}}{3}.\]

Release means were digitised from the published Figure 2. Cell counts were back-transformed from log10 values before calculating ratios. Protein and polysaccharide measurements retained their published membrane-area normalisation.

We used the exact lag durations from Table 1: 6, 4 and 0 days for control, and 18, 12 and 1 days for treatment. Published cleaning rounds 2-4 were aligned in order with omics cycles 1-3.

We standardised the mean release fraction \(\bar R\) and lag L across the same six membrane-cycle observations using their pooled means and sample standard deviations, then calculated:

\[z(X_i)=\frac{X_i-\bar X}{s_X},\qquad S_i=\frac12z(\bar R_i)+\frac12z(L_i).\]

The three release ratios contributed equally to \(\bar R\). Standardised \(\bar R\) and L each received half of the total weight. Individual ratios were not standardised separately, and the composite was not rescaled to 0-100.

Higher S denotes preferential initial release and longer regrowth lag. Zero denotes the six-observation reference mean. The composite and its weights were developed here; they were not defined in the original study.

The reference means and sample standard deviations were frozen for all models and scenarios. Missing readouts or zero ratio denominators produced unavailable scores; negative amounts and zero reference variance were rejected.

## Candidate predictors and regression models

We retained the 14 MAGs carrying at least one biofilm-associated gene upregulated in treatment at full-transcriptome FDR (BH) ≤ 0.05. Membership used the combined 3,905-gene annotation set throughout.

The DNA predictor was the log2 DESeq2-size-factor-normalised count for the whole MAG. All selected counts were positive, so no pseudocount was added.

The RNA predictor was the mean gene-centred log2 counts per million (CPM) across all tested combined-list genes assigned to each MAG, including genes without significant differential expression.

Log2 CPM used the full-transcriptome effective library sizes and edgeR prior.count = 0.5. Each gene was centred across all 12 physical samples before averaging within a MAG.

We fitted DNA and RNA predictors separately for each MAG and sampling phase. Each fit used six membrane-cycle outcomes. Initial and backflush samples supplied separate predictor views; outcomes were not duplicated within a fit.

The primary model included categorical cycle and condition. We also fitted a linear-cycle sensitivity and a post hoc condition-only specification using ordinary least squares in R:

```r
lm(score ~ factor(cycle) + condition + x)
lm(score ~ cycle + condition + x)
lm(score ~ condition + x)
```

Here, x denotes the DNA or RNA predictor, condition contrasts treatment with control, and cycle takes values 1, 2 and 3. The models had one, two and three residual degrees of freedom, respectively.

We reported two-sided t tests and 95% coefficient intervals, alongside HC3 heteroscedasticity-consistent standard-error sensitivities. Each specification comprised 56 slope tests: 14 MAGs by two predictors by two phases.

Benjamini-Hochberg correction was applied across the 56 tests within each specification and across all 168 tests jointly. Ordinary and HC3 tests were corrected separately. Specifications were not selected by their P values.

We examined leverage, Cook's distance, predictor variance inflation and leave-one-cycle-out slope signs. Cycle deletion was an influence analysis. Fitted-versus-observed displays used in-sample predictions.

## MAG suppression scenarios and phage links

For a fractional reduction f in whole-MAG DNA abundance, we held condition, cycle, size factors, score normalisation and fitted coefficients fixed. The predictor and predicted-score contrasts were:

\[\Delta x=\log_2(1-f),\qquad \Delta\widehat S=\widehat\beta_x\log_2(1-f).\]

We evaluated f = 0, 0.10, 0.25, 0.50, 0.75, 0.90 and 0.95. At 50% suppression, the predicted change equals minus the DNA coefficient. Positive changes denote higher modelled cleaning performance, expressed in score units.

Scenario intervals were obtained by transforming the coefficient's 95% interval and ordering its endpoints. We recorded treatment observations shifted below the observed predictor range. Other MAG abundances were not renormalised.

Effects from separate single-MAG models were not added. RNA coefficients describe changes per expression-score unit; percentage suppression scenarios were restricted to whole-MAG DNA abundance.

We matched the fixed candidate list to existing CRISPR/SpacePHARER host links using exact MAG identifiers. Linked viral contigs and catalogue representatives were counted separately, retaining their original supporting records.

## Provenance for manuscript maintenance

- Score: `analysis/cleaning_performance_score.qmd`; `derived/cleaning_performance_score_2026-09-14-v1/`.
- Primary/linear-cycle models: `analysis/cleaning_score_MAG_models.qmd`; `derived/cleaning_score_MAG_models_2026-09-14-v1/`.
- Condition-only and joint BH168: `analysis/cleaning_score_condition_models.qmd`; `derived/cleaning_score_condition_models_2026-09-14-v1/`.
- RNA aggregation: `analysis/figure_derived_biofilm_phenotypes.qmd`, expression-and-overlays chunk.
- Links: `analysis/biofilm_candidate_phage_crosswalk.qmd`; `derived/biofilm_candidate_phage_crosswalk_2026-09-14-v1/`.
- Live addition must remain Codex Assistant suggestions; preserve existing Methods and author comments. Provenance section stays local, not manuscript prose.
- Limitations remain in the manuscript's dedicated section. Do not import historical endpoint definitions or bootstrap results from former proxy models.
