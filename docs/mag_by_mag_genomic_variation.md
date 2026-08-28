# MAG-by-MAG population-genomic variation

Date: 2026-08-05

## Purpose and boundary

This analysis asks whether individual coverage-qualified MAGs show distinct
modes of population-genomic stability or turnover across the twelve
metagenomic samples. It uses inStrain for the question it can address:
read-backed population similarity and within-population variation.

It is not a DNA-damage, lesion, mutation-rate, adaptation, or treatment-effect
analysis. Condition is confounded with membrane identity, and the five MAGs
come from a priority-20 set selected using host-link and UV-signature context.
They are not a random or community-representative set.

## Inputs and integrity

The complete per-sample profile tables were staged from the canonical Isilon
archive into:

`PRJEB79569/community_uv_response/variant_analysis/instrain_priority_20/per_site_staging/`

For each of the twelve samples, staging includes the exported SNV table,
scaffold information, and compressed raw SNP table. A checksum-enabled rsync
dry run against Isilon reported no differences across 97 traversed entries and
492,694,540 bytes of selected files.

The archived log records inStrain v1.10.0. The compare command used all twelve
priority-20 profiles in `--database_mode`, an explicit scaffold-to-bin file,
and default compare settings. Its local provenance log is:

`PRJEB79569/community_uv_response/variant_analysis/instrain_priority_20/compare/all_samples/log/log.log`

## Fixed QC rules

The five-MAG entry rules remain those defined before this organism-level pass:

- pair: at least 1,000,000 compared bases;
- pair: at least 50% of the callable genome compared;
- MAG: at least ten qualified pairs;
- MAG: qualified pairs spanning at least six observed samples.

Additional sample- and site-level rules were fixed before inspecting the
organism-level patterns:

- sample: mean coverage at least 5x;
- sample: callable breadth at least 50%;
- site: inStrain class `SNV` and not cryptic;
- site: position coverage at least 10 reads;
- site: reported variant frequency at least 5%;
- recurrent allele: reported in at least two qualified samples.

A missing allele-frequency heatmap cell means that the allele was not reported
as a high-confidence SNV in that sample. It is not imputed as a zero-frequency
or reference allele.

## Organism-level results

### Propionicimonas sp023458095: phase-associated population structure

`TI3_MAGScoT_cleanbin_000001` has the clearest structured pattern. All six
qualified initial-flow observations across the two membranes and three cycles
belong to strain cluster S1. The two qualified cycle-3 backflush observations
are distinct: control backflush is S3 and phage-UV backflush is S2.

Among 15 same-cluster qualified pairs, the median consensus difference was
17.4 SNPs per callable Mbp, with a range of 3.0-39.1. Among nine
different-cluster pairs, the median was 1,344.1 SNPs per callable Mbp, with a
range of 1,331.2-2,861.3. This separation is expected to align with the
inStrain cluster assignment and is descriptive rather than an independent
statistical validation.

The corresponding backflush samples also have higher reported nucleotide
diversity than the cycle-3 initial-flow samples. However, both backflush
observations lie close to the minimum coverage boundary, so nucleotide
diversity is supporting QC context rather than the principal evidence.

Manuscript-safe interpretation: a persistent initial-flow population was
accompanied by distinct cycle-3 backflush populations in both membranes. This
is consistent with phase or biofilm-compartment structuring and is not
treatment-specific.

### UBA8904 sp002070455: dominant population with one isolated transition

`CBF3_MAGScoT_cleanbin_000031` has ten qualified observations. Nine belong to
S1; control initial-flow cycle 2 belongs to S2. Same-cluster pairs have a
median of 35.8 consensus differences per callable Mbp, whereas pairs involving
the isolated cluster have a median of 785.7.

This supports a predominantly stable population with one isolated
sample-specific transition. The apparent increase in nucleotide diversity
across several later observations is not interpreted biologically because
nucleotide diversity is negatively associated with coverage in this MAG.

### SHND01 sp004295045: provisional late initial-flow transition

`TBF2_MAGScoT_cleanbin_000085` has nine qualified observations. Eight belong
to S1; phage-UV initial-flow cycle 3 belongs to S2. Same-cluster pairs have a
median of 569.0 consensus differences per callable Mbp, compared with 1,346.9
for different-cluster pairs.

The cycle-3 observation has 6.8x mean coverage and 53.6% callable breadth, and
no matched control cycle-3 or phage-UV backflush cycle-3 observation passes
sample QC. This is therefore a provisional isolated transition, not evidence
of a late treatment response.

### Unclassified Chloroflexota: irregular multi-cluster turnover

`CBF2_MAGScoT_cleanbin_000015` has seven qualified observations and three
clusters. Five observations belong to S1; control backflush cycle 3 is S3 and
phage-UV initial-flow cycle 1 is S2. Same-cluster pairs have a median of 720.7
consensus differences per callable Mbp, compared with 2,626.3 for
different-cluster pairs.

The sparse and uneven sample support does not define a monotonic cycle,
condition, or phase pattern. The appropriate description is irregular
population turnover among the observed samples.

### Aliarcobacter: consensus-cluster stability

All six qualified observations of `TBF3_MAGScoT_cleanbin_000022` belong to S1.
The 15 qualified pairs range from 92.5 to 890.1 consensus differences per
callable Mbp, with a median of 265.6. This MAG therefore provides a useful
counterexample: detectable within-cluster variation without consensus strain
replacement across the observed samples.

## Coverage sensitivity

The organism-level nucleotide-diversity and SNV-density summaries are
diagnostics, not inferential outcomes. Across qualified samples, coverage was
associated with one or both metrics in several MAGs. In particular, SNV
density was strongly coverage-dependent in the Chloroflexota and SHND01 MAGs,
while nucleotide diversity was negatively associated with coverage in the
Chloroflexota and UBA8904 MAGs. These small-n Spearman checks are warnings
about measurement sensitivity, not hypothesis tests.

Consequently, the robust descriptive hierarchy is:

1. coverage-qualified pairwise consensus differences and strain membership;
2. sample coverage and callable breadth;
3. recurrent allele-frequency and nucleotide-diversity patterns as supporting
   diagnostics only.

## Scientific synthesis

The MAG-by-MAG pass does reveal a coherent result that was hidden by the pooled
heatmap: population-genomic dynamics are organism-specific. The set contains a
strong phase-associated population-structure candidate in *Propionicimonas*,
three taxa with isolated or irregular transitions, and one taxon with a stable
consensus cluster.

There is no uniform treatment-associated or monotonic cycle pattern. The
clearest structured result occurs in both membranes and therefore points to
sample phase or biofilm compartment rather than phage-UV causality.

## Figure candidates

- `mag-genomic-variation-strain-clusters.pdf`: compact five-MAG overview;
- `mag-genomic-variation-microdiversity.pdf`: coverage-sensitive diagnostic;
- `mag-genomic-variation-dossier-ti3-bin-000001.pdf`: strongest organism-level
  candidate;
- four additional organism dossiers retained unallocated for comparison and
  supplementary use if needed.

All outputs are under:

`PRJEB79569/derived/manuscript_candidates/`

## Reproduction

- Builder: `scripts/build_mag_genomic_variation_dossiers.qmd`
- Sample QC: `tables/mag_genomic_variation_sample_qc.tsv`
- Strain memberships: `tables/mag_genomic_variation_strain_clusters.tsv`
- Cluster-distance summary:
  `tables/mag_genomic_variation_cluster_pair_summary.tsv`
- Recurrent alleles: `tables/mag_genomic_variation_recurrent_sites.tsv`
- Coverage sensitivity: `tables/mag_genomic_variation_coverage_sensitivity.tsv`
