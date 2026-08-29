# Working figure legends

Status: descriptive legends for manuscript review. Numbering is provisional.
Control is green (`#8FCB8A`) and phage-UV is violet (`#7E57C2`) throughout the
main and supplementary figures.

## Main figures

**Figure 1. Experimental system, community trajectory, and transcriptome
geometry.** (A) One
control membrane and one phage-UV membrane sampled during the initial and
backflush phases of three cleaning cycles, giving 12 physical samples. (B)
Relative abundance among MAG-mapped metagenomic reads for the top 25 classified
families across the same six aligned cycle-phase positions. Named families use
phylum-linked microshades; pale shades pool remaining or unresolved families
within the same phylum, and grey denotes phyla outside the displayed set. The
profile is descriptive and does not constitute a replicated treatment test.
(C) Leading log-fold-change dimensions calculated from the TMM-normalised
filtered expression matrix. Point colour denotes membrane, point shape denotes
phase, and labels denote cycle.

**Figure 2. Transcriptome-wide, functional, and organism-resolved structure.**
(A) Average log2 counts per million and phage-UV-minus-control log2 fold-change
for the phase- and cycle-adjusted edgeR coefficient. Filled points passed BH FDR
< 0.05 and are coloured by the direction of higher expression; open grey points
are a deterministic context sample. Dotted horizontal lines mark log2
fold-changes of -1 and 1. (B)
Competitive rank tests for eight predefined repair and stress categories in the
adjusted membrane coefficient. Values are signed -log10(BH FDR), with negative
values denoting control-higher and positive values denoting phage-UV-higher gene
ranks. Filled points passed BH FDR < 0.05. (C) Number of eligible MAG gene sets
passing BH FDR < 0.05 in each rank direction. (D) Median gene-level adjusted
membrane log2 fold-change for the 12 strongest supported MAGs in each direction,
selected by FDR and then absolute median log2 fold-change. Squares denote GTDB
phylum and circles denote the direction of higher-ranked genes. Full functional
and MAG-level statistics are provided in the interpretation tables.

**Figure 3. Recurrent gene-level differences across six phase-cycle cells.**
(A) Sequential counts after the adjusted-condition FDR and effect-size filter,
sample-detection filter, annotation filter, and five-of-six-cell recurrence
rule. (B) Numbers of phage-UV-higher and control-higher recurrent genes with
directional agreement in five or six phase-cycle cells. (C)
Phage-UV-minus-control differences in TMM-normalised log2 counts per million for
12 genes per direction, selected by adjusted-condition FDR and then absolute
log2 fold-change. Columns represent the initial and backflush fractions in
cycles 1 to 3. Full candidate statistics are provided in the recurrent-gene
table.

**Figure 4. Coverage-qualified population-genomic heterogeneity.** (A) Strain
cluster assignment across the observed samples for five MAGs with at least 10
qualified pairs spanning at least six samples. Blank cells indicate absent or
coverage-failing sample profiles. (B) Median and range of pairwise consensus
differences per callable Mbp for each MAG. Point colour denotes GTDB phylum and
point size denotes the number of observed samples. The horizontal axis is log10
scaled. (C) Pairwise consensus differences per callable Mbp among the eight
coverage-qualified *Propionicimonas* sp023458095 profiles. Pairs required at
least 1 Mbp and 50% of the callable genome. Full pair and MAG quality-control
metrics are provided in the population-genomics tables.

**Figure 5. Delegated 16S community analysis.** Reserved for the external
collaborator's verified result. Panel content and legend will be added only
after the analysis and provenance have been returned.

## Additional unallocated candidates

**MAG taxonomic context and family-level community profile.** (A)
Taxonomy-derived circular dendrogram of 348 dereplicated metagenome-assembled
genomes (MAGs). Tip points denote GTDB phylum. Concentric rings show, from the
inside out, estimated completeness, estimated contamination, support and
direction for the phase- and cycle-adjusted membrane coefficient, and the
balance of recurrent phage-UV-higher versus control-higher genes. The adjusted
membrane ring uses the complete tested gene universe and post-model MAG-level
rank tests. (B) Relative abundance of the 15 fixed, most abundant classified
families, unclassified MAGs, and all remaining families among MAG-mapped
metagenomic reads in the 12 physical samples. C1-C3 denote cleaning cycles 1-3;
I denotes the initial sample and B the backflush sample. Control is shown above
phage-UV with the six cycle-phase positions aligned vertically. `Other
classified families` combines the 147 classified families outside the fixed 15,
whereas `Unclassified at family level` denotes MAGs without a family assignment.
Family colours are fixed across figures. The dendrogram represents taxonomic
classification rather than sequence-derived evolutionary distance, and
membrane identity remains confounded with condition. The community profile is
descriptive and is not a replicated treatment-effect analysis.

**vOTU taxonomic context.** (A) Taxonomy-derived cladogram of 607 deduplicated
high-quality viral operational taxonomic units (vOTUs) with an assigned
taxonomic path and at least one viral gene. Tips represent 45 distinct taxonomy
paths, point colour denotes realm, point size denotes the number of vOTUs in
the group, and selected larger groups are labelled. (B) Number of qualifying
vOTUs in each realm; unclassified taxonomy labels are combined for display.
The cladogram represents taxonomic classification rather than a sequence
phylogeny and is descriptive of the current catalogue only. It does not encode
treatment response or host-phage linkage.

## Supplementary figures

**Supplementary Figure S1. Feature, library, and model diagnostics.** (A) Number
of input features and features retained by the predeclared expression filter.
(B) Retained and TMM-effective library sizes for the 12 physical samples. Filled
points denote effective library size; open points denote the retained raw
library size. Colour denotes membrane and shape denotes phase. (C) Median and
interquartile range of trended dispersion, tagwise dispersion, and
quasi-likelihood posterior variance for the adjusted-condition and
condition-by-cycle models.

**Supplementary Figure S2. Complete-universe condition-by-cycle interaction
landscapes.** (A) Average log2 counts per million and interaction log2
fold-change for the cycle-2 and cycle-3 departures from the cycle-1 membrane
contrast. Filled points passed BH FDR < 0.05; open grey points are deterministic
context samples. (B) Average log2 counts per million and -log10(BH FDR) for the
two-degree-of-freedom condition-by-cycle omnibus. The dotted line marks BH FDR
= 0.05.

**Supplementary Figure S3. Predefined functional categories across all
coefficients.** Competitive rank-test results for eight repair and stress
categories in the adjusted membrane, cycle-2 interaction, cycle-3 interaction,
and interaction-omnibus coefficients. Directional coefficients are signed by
gene-rank direction. Omnibus values are non-directional and positive. Filled
points passed BH FDR < 0.05; open points did not.

**Supplementary Figure S4. MAG-level coherence across directional
coefficients.** (A) Number of eligible MAG gene sets passing BH FDR < 0.05 in
the up-ranked and down-ranked directions for the adjusted membrane, cycle-2
interaction, and cycle-3 interaction coefficients. (B) Median gene-level log2
fold-change and -log10(BH FDR) for all eligible MAG sets. Filled points passed
BH FDR < 0.05; open points did not. Interaction coefficients are departures
from cycle 1.

**Supplementary Figure S5. Coverage-qualified pairwise population-genomic
landscapes.** Pairwise consensus differences per callable Mbp for all five MAGs
passing the organism-level coverage rules. Grey cells indicate unavailable or
coverage-failing comparisons. Pairs required at least 1 Mbp and 50% of the
callable genome.

**Supplementary Figure S6. MAG taxonomic context and family-level community
profile.** (A) Taxonomy-derived circular dendrogram of 348 dereplicated MAGs.
Tip points denote GTDB phylum. Concentric rings show estimated completeness,
estimated contamination, support and direction for the adjusted membrane
coefficient, and recurrent-gene balance. (B) Relative abundance of the 15 most
abundant classified families, unclassified MAGs, and all remaining classified
families among MAG-mapped metagenomic reads. Control is aligned above phage-UV
across the six cycle-phase observations. The tree represents taxonomic
classification, not sequence-derived evolutionary distance, and the abundance
profiles are descriptive.

**Supplementary Figure S7. vOTU taxonomic context.** (A) Taxonomy-derived
cladogram of 607 deduplicated high-quality vOTUs grouped into 45 taxonomic
paths. Point colour denotes realm and point size denotes the number of vOTUs in
the group. (B) Number of qualifying vOTUs in each realm. The cladogram is not a
sequence phylogeny and does not encode treatment response or host-phage
linkage.
