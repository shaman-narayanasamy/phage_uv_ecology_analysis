# Historical temporal quick-check audit — quarantined

Date: 2026-07-30

## Status update: 2026-08-10

All results in this document derived from preselected SOS, UV-response,
DNA-repair, stress-response, RNA:DNA, or response-module subsets are
quarantined quick checks. This document preserves their methods and provenance;
it is not a source of manuscript findings or null-result claims.

Do not cite the reported effect sizes, p-values, FDR counts, slopes, or cluster
results. Do not use them to select genes, MAGs, or categories for the global
analysis. The replacement workflow is full transcriptome-wide DE in GitHub
#22, followed by subsets of that complete result universe in #23. The binding
artifact-level rules are in `docs/expression_quarantine.md`.

## Valid inferential scope

The experiment contains one control membrane and one phage-UV-treated membrane
observed over three cleaning cycles. Initial and backflush material are two
sampling phases within each cycle. Multiple metatranscriptomic runs from the
same physical sample are technical sequencing replicates and are collapsed
before analysis.

Cycles are therefore analysed as repeated longitudinal observations of these
two membranes. They are not independent biological treatment replicates.
Condition is confounded with membrane identity, so no result below establishes
a population-level causal treatment effect.

This interpretation follows the project methods and the knowledgebase
statistical-analysis rules: the experimental unit controls inference,
comparisons are defined before testing, raw and BH-adjusted p-values are
reported, and null results are retained.

## Predefined analysis families

| Family | Unit and test | Multiplicity |
|---|---|---|
| Community RNA:DNA response | Six phase-cycle phage-UV/control contrasts; two-sided sign test and phase-blocked exact cycle-slope permutation | BH across two predefined modules |
| UV-response categories | Phase-blocked exact cycle-slope permutation | BH across eight predefined categories |
| SOS markers | Phase-blocked exact cycle-slope permutation | BH across seven predefined markers |
| MAG temporal slopes | Phase-blocked exact cycle-slope permutation | BH across eligible MAGs within each module |
| Trajectory clusters | Ward, PAM, and k-means; two feature spaces; k = 2–6 | Stability criteria fixed before interpretation |
| SNV sensitivity | MAG-aggregated paired Wilcoxon tests | BH across two predefined comparisons |
| edgeR sensitivity | Collapsed technical runs; phase- and cycle-adjusted quasi-likelihood models | BH within each model; technical-model sensitivity only |

MAG eligibility was fixed before testing: at least 100 module reads in total,
metatranscriptomic detection in at least six samples, and metagenomic detection
in at least six samples. This retained 320 MAGs for the core DNA-damage module
and 265 MAGs for the SOS module.

## Results

### Abundance-corrected transcription

The SOS RNA:DNA contrast was positive in all six phase-cycle comparisons. Its
median log2 phage-UV/control effect was 0.779. The two-sided sign-test raw
p-value was 0.0313 and the BH-adjusted value across the two predefined modules
was 0.0625.

The core DNA-damage response was positive in five of six comparisons, with a
median effect of 0.343, raw p = 0.219, and BH-adjusted p = 0.219.

Neither module showed a supported monotonic cycle trend. The SOS slope was
-0.234 log2 units per cycle (exact p = 0.333; BH-adjusted p = 0.667). The core
DNA-damage slope was -0.073 (exact p = 0.778; BH-adjusted p = 0.778).

### Gene-level sensitivity

The exploratory edgeR model found 26 of 807 SOS genes at FDR <= 0.05 for the
condition coefficient, with 24 positive coefficients. No gene survived FDR
correction for either the condition-by-cycle factor interaction or the linear
condition-by-cycle interaction.

These edgeR p-values were generated as a rapid sensitivity diagnostic, not as
independent biological replication. The former interpretation of a broad
phage-UV-associated SOS transcriptional bias is withdrawn. This restricted
gene universe cannot support a manuscript claim or a null claim and must not
guide selection for the transcriptome-wide model.

### Organism trajectories

No stable organism trajectory clusters were found. Sixty configurations were
tested across two response modules, two feature spaces, three algorithms, and
five values of k. A stable configuration required:

- minimum cluster size of at least five MAGs;
- mean silhouette of at least 0.25;
- median cross-algorithm adjusted Rand index of at least 0.60;
- median leave-one-cycle-out adjusted Rand index of at least 0.60.

Zero of 60 configurations passed. Cluster membership and taxonomic enrichment
outputs are retained only as diagnostics and must not be interpreted as
biological response groups. The manuscript candidate instead uses a continuous
MAG response heatmap ordered by each MAG's mean abundance-corrected SOS effect.

No individual MAG temporal slope survived BH correction.

### Population genomics: descriptive use only

The inferential SNV analysis is retired from manuscript use. inStrain measures
population-genomic similarity and variation in metagenomic reads; it is not a
DNA-damage assay and cannot establish lesions, treatment-induced mutations, or
mutation accumulation in this design.

The retained analysis is qualitative and coverage-qualified. A pair is shown
only when at least 1 Mbp and at least 50% of the callable genome were compared.
A MAG enters the descriptive panel only when at least 10 such pairs spanning at
least six observed samples are available. These criteria are fixed before
viewing population-genomic patterns. No statistical comparison by condition,
cycle, or phase is performed.

The panel reports consensus SNP differences per Mbp compared as a description
of heterogeneous population stability or turnover. It must not be described as
DNA damage, mutagenesis, adaptation, or a treatment effect.

## Current manuscript-use boundary

No expression result in this historical quick-check audit is manuscript-safe.
The DNA data may still contribute a separately governed qualitative
population-genomic description of stability and turnover among
coverage-qualified MAGs. Phage-host links remain excluded from this analysis
stage.

## Reproducible outputs

- `scripts/build_uv_activity_candidates.qmd`
- `scripts/build_sos_activity_candidates.qmd`
- `scripts/build_temporal_response_analysis.qmd`
- `scripts/evaluate_temporal_cluster_stability.qmd`
- `scripts/run_sos_edger_sensitivity.qmd`
- `scripts/build_population_genomics_descriptive.qmd`

Generated tables and vector figures are written under
`PRJEB79569/derived/manuscript_candidates/` outside the repository.
