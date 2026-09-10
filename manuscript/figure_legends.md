# Working figure legends

Status: descriptive legends for manuscript review. Numbering is provisional.
Control is green (`#8FCB8A`) and phage-UV is violet (`#7E57C2`) throughout the
main and supplementary figures.

## Main figures

**Figure 1. Microbial and phage community structure across three cleaning cycles.** (A) One control membrane and one phage-UV membrane sampled during the initial and backflush phases of three cleaning cycles, giving 12 physical samples. (B) Relative abundance among metagenomic reads mapped to 348 metagenome-assembled genomes (MAGs) for the top 25 classified families across the same six aligned cycle-phase positions. Named families use phylum-linked microshades adapted from Dahl et al. (2022); pale shades pool remaining or unresolved families within the same phylum, and grey denotes phyla outside the displayed set. The profile is descriptive and does not constitute a replicated treatment test. (C) Bray-Curtis principal-coordinate representation of MAG-mapped community composition. (D) Relative abundance of reads assigned to 607 high-quality classified viral operational taxonomic units (vOTUs) at viral realm level across the same aligned observations. (E) Bray-Curtis principal-coordinate representation of vOTU composition. In C and E, lines connect cycles within each membrane and sampling phase, point colour denotes membrane, point shape denotes phase, and labels denote cycle. C1-C3 denote cycles 1-3, I initial samples and B backflush samples. Insets report exhaustive paired label-swap tests of Bray-Curtis dissimilarity (BC), phase- and cycle-adjusted differential-abundance (DA) counts, and matched centred-log-ratio (CLR) sensitivity results. DA and CLR entries give the number passing Benjamini-Hochberg false discovery rate (BH FDR) < 0.05 over the number tested. The 64 label-swap patterns exchange labels within the six phase-cycle cells, not whole membrane trajectories. With one membrane per condition, all condition-associated comparisons are exploratory and do not estimate a replicated treatment effect.

**Figure 2. Global transcriptome structure.** (A) Leading log-fold-change dimensions calculated from the trimmed-mean-of-M-values (TMM)-normalised filtered expression matrix for 12 physical samples. Point colour denotes membrane, point shape denotes phase, and labels denote cleaning cycle. (B) Average log2 counts per million and phage-UV-minus-control log2 fold-change for the phase- and cycle-adjusted edgeR coefficient across the complete tested feature universe. Filled points passed Benjamini-Hochberg false discovery rate (BH FDR) < 0.05 and are coloured by the direction of higher expression. Open grey points are a deterministic context sample of up to 20,000 features not passing this threshold. Dotted horizontal lines mark log2 fold-changes of -1 and 1. The inset reports the tested-feature count and the counts passing the FDR threshold alone or together with an absolute log2 fold-change of at least 1. Feature-level results are provided in Supplementary Table S3. Membrane identity and condition are confounded.

**Figure 3. Functional and organism-resolved transcriptional structure.** (A) Competitive rank tests for eight predefined repair and stress categories in the adjusted membrane coefficient. Values are signed -log10 Benjamini-Hochberg false discovery rates (BH FDR), with negative values denoting control-higher and positive values denoting phage-UV-higher gene ranks. Filled points passed BH FDR < 0.05. (B) Number of eligible metagenome-assembled genome (MAG) gene sets passing BH FDR < 0.05 in each rank direction. (C) Median gene-level adjusted membrane log2 fold-change for the 12 strongest supported MAGs in each direction, selected by FDR and then absolute median log2 fold-change. Squares denote Genome Taxonomy Database (GTDB) phylum and circles denote the direction of higher-ranked genes. There were 340 eligible MAG sets, each with at least 20 tested genes and a median of at least six samples with non-zero counts per gene. Full functional and MAG-level statistics are provided in Supplementary Tables S4 and S5.

**Figure 4. Recurrent gene-level differences across six phase-cycle cells.** (A) Sequential selection from 361,907 tested features: Benjamini-Hochberg false discovery rate (BH FDR) < 0.05 and absolute adjusted membrane log2 fold-change >= 1; non-zero counts in at least six of the 12 physical samples; a non-empty gene annotation; and recurrent expression differences. Recurrence required the same direction in at least five of six phase-cycle cells and an absolute median cell-level log2 counts-per-million difference >= 1. (B) Numbers of phage-UV-higher and control-higher recurrent genes with directional agreement in five or six cells. (C) Phage-UV-minus-control differences in log2 counts per million, normalised by the trimmed mean of M values (TMM), for 12 recurrent genes per direction. Genes were selected by adjusted-condition FDR, then decreasing absolute log2 fold-change, with feature identifier breaking ties. Columns represent initial and backflush samples in cycles 1-3. Values use a prior count of 0.5. Bracketed labels identify the source metagenome-assembled genome. Full criteria and candidate statistics are provided in Supplementary Table S6. Recurrence describes these two membranes, not independent treatment replicates.

**Figure 5. Coverage-qualified population-genomic heterogeneity.** (A) Reported inStrain cluster assignments for five metagenome-assembled genomes (MAGs) with at least 10 qualified pairwise comparisons spanning at least six samples. Tile colour denotes membrane; S-prefixed labels identify reported clusters within each MAG and are not comparable between MAGs. Grey cells lack a reported cluster assignment. C and P denote control and phage-UV membranes; I and BF denote initial and backflush samples; suffixes 1-3 denote cleaning cycles. (B) Median and range of pairwise consensus differences per million compared bases (Mbp) for each MAG. Point colour denotes Genome Taxonomy Database (GTDB) phylum and point size denotes the number of observed samples. The horizontal axis is log10-scaled. (C) Pairwise consensus differences per compared Mbp among eight Propionicimonas sp023458095 profiles, shown on a log10 colour scale. Grey off-diagonal cells indicate unavailable or coverage-failing comparisons; the white diagonal marks self-comparisons and does not represent measured zero differences. Pairs required at least 1 Mbp of compared sequence and an inStrain-reported compared fraction >= 0.50. Full pair and MAG quality-control metrics are provided in Supplementary Table S7. These comparisons describe population-genomic variation, not direct DNA damage.

The returned collaborator-owned 16S analysis is represented by Supplementary
Figure S10 below. Its working allocation preserves Figure 1's focus on the
MAG- and vOTU-resolved community.

## Accepted workflow overview (number pending)

**Integrated multi-omics analysis of phage-UV membrane cleaning.** Twelve
physical samples span three cleaning cycles and two sampling phases (initial
and backflush) from one control and one phage-UV membrane. Continuous routes
trace cDNA-derived 16S amplicons, metagenomes (MG) and metatranscriptomes (MT)
from the same experiment. Quality-controlled MG and MT reads contribute to
sample-specific coassembly, with MT contigs supplied as an additional input.
Recovered MAGs are refined and dereplicated across samples; viral candidates
from coassemblies and additional single-omics assemblies are pooled and
clustered into representative viral operational taxonomic units (vOTUs).
Representatives form a unified MAG/vOTU catalogue for remapping both omics.
MG alignments support abundance summaries, while gene-level MT counts are
aggregated from sequencing runs to physical samples before full-transcriptome
edgeR analysis and post-model functional interpretation. Connected branches
show MAG-only population-genomic analysis, CRISPR-derived candidate host-phage
links and DADA2/SILVA-based amplicon community characterisation. Shared stations
indicate common operations or references; crossings without stations do not
join routes. Convergence at the community endpoint denotes complementary
interpretation, not pooled count tables. Repeated sampling does not provide
independent replication of treatment because membrane identity and condition
are confounded.

Accepted provisionally by the author on 2026-09-07: `workflow_metro_v10`.
Source and artifact paths are recorded in `accepted_figure_inventory.tsv`.
Final numbering remains open; Figure 1 continues to describe the community.

## Historical candidate legends (superseded by S6 and S7 below)

These earlier candidate descriptions are retained for provenance, not for
insertion into the current manuscript. In particular, the old 15-family
profile is superseded by the top25 profile in Supplementary Figure S6.

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

**Supplementary Figure S1. Feature, library, and model diagnostics.** (A) Number of input features and features retained by the predeclared expression filter. (B) Retained and trimmed-mean-of-M-values (TMM)-effective library sizes for the 12 physical samples. Filled points denote effective library size; open points denote the retained raw library size. Green denotes control and violet phage-UV; circles denote initial samples and triangles backflush samples. (C) Median and interquartile range of trended dispersion, tagwise dispersion, and quasi-likelihood posterior variance for the adjusted-condition and condition-by-cycle models.

**Supplementary Figure S2. Complete-universe condition-by-cycle interaction landscapes.** (A) Average log2 counts per million and interaction log2 fold-change for the cycle-2 and cycle-3 departures from the cycle-1 membrane contrast. Filled points passed Benjamini-Hochberg false discovery rate (BH FDR) < 0.05; open grey points are deterministic context samples of up to 20,000 unsupported features per panel. (B) Average log2 counts per million and -log10(BH FDR) for the two-degree-of-freedom condition-by-cycle omnibus. The dotted line marks BH FDR = 0.05.

**Supplementary Figure S3. Predefined functional categories across all coefficients.** Competitive rank-test results for eight repair and stress categories in the adjusted membrane, cycle-2 interaction, cycle-3 interaction, and interaction-omnibus coefficients. Values are -log10 Benjamini-Hochberg false discovery rates (BH FDR). Directional values are negative for lower-ranked and positive for higher-ranked gene sets; omnibus values are non-directional and positive. Filled points passed BH FDR < 0.05; open points did not. Category membership and statistics are provided in Supplementary Table S4.

**Supplementary Figure S4. MAG-level coherence across directional coefficients.** (A) Number of eligible metagenome-assembled genome (MAG) gene sets passing Benjamini-Hochberg false discovery rate (BH FDR) < 0.05 in the up-ranked and down-ranked directions for the adjusted membrane, cycle-2 interaction, and cycle-3 interaction coefficients. (B) Median gene-level log2 fold-change and -log10(BH FDR) for all eligible MAG sets. Filled points passed BH FDR < 0.05; open points did not. Interaction coefficients are departures from the cycle-1 membrane contrast, not standalone treatment-minus-control effects within cycles 2 or 3. Full MAG statistics are provided in Supplementary Table S5.

**Supplementary Figure S5. Coverage-qualified pairwise population-genomic landscapes.** Pairwise consensus differences per million compared bases (Mbp) for five metagenome-assembled genomes (MAGs), each with at least 10 qualified pairs spanning at least six samples. Colour scales are log10-transformed. Grey off-diagonal cells indicate unavailable or coverage-failing comparisons; white diagonals mark self-comparisons, not measured zero differences. Pairs required at least 1 Mbp of compared sequence and an inStrain-reported compared fraction >= 0.50. C and P denote control and phage-UV membranes; I and BF denote initial and backflush samples; suffixes 1-3 denote cleaning cycles. Full pairwise measurements and quality-control fields are provided in Supplementary Table S7.

**Supplementary Figure S6. MAG taxonomic context and family-level community profile.** (A) Taxonomy-derived circular dendrogram of 348 dereplicated metagenome-assembled genomes (MAGs). Tip points denote Genome Taxonomy Database (GTDB) phylum. From inside to outside, rings show estimated completeness, estimated contamination, support and direction for the adjusted membrane coefficient, and recurrent-gene balance. Support denotes Benjamini-Hochberg false discovery rate < 0.05 in the complete-transcriptome MAG rank tests. Recurrent-gene balance is the number of phage-UV-higher minus control-higher recurrent genes divided by all tested genes for that MAG; colours beyond the displayed scale limits are saturated. This ring uses cell-level recurrence across all tested genes, not only the filtered candidates in Figure 4. (B) Relative abundance of the 25 named families and remainder categories shown in Figure 1, using its identical profile and microshades colour key (Dahl et al., 2022). Light shades denote within-phylum remainders and grey denotes other phyla. No reads are removed from the MAG-mapped denominator. Control is aligned above phage-UV across the six cycle-phase observations; I and B denote initial and backflush samples. The tree represents taxonomic classification, not sequence-derived evolutionary distance. Source data are provided in Supplementary Table S8.

**Supplementary Figure S7. vOTU taxonomic context.** (A) Taxonomy-derived cladogram of 607 deduplicated high-quality viral operational taxonomic units (vOTUs) after quality assessment with CheckV (Nayfach et al., 2021), each with a taxonomic assignment and at least one viral gene, grouped into 45 taxonomic paths. Point colour denotes realm and point size denotes the number of vOTUs in the group. (B) Number of qualifying vOTUs in each realm. The cladogram is not a sequence phylogeny and does not encode treatment response or host-phage linkage.

**Supplementary Figure S8. CRISPR-derived host-phage candidate-link evidence audit.** (A) Eighty host metagenome-assembled genomes (MAGs) and 85 phage contigs connected by 86 deduplicated SpacePHARER candidate pairs. Host-node colour denotes Genome Taxonomy Database (GTDB) phylum, phage-node shape denotes the mapped viral realm, edge width denotes the number of SpacePHARER hits, and edge colour overlays the support and direction of the host MAG's current adjusted membrane coefficient. Labels identify the six host MAGs linked to two phage candidates and the single phage candidate linked to two hosts. (B) Linked host MAGs by current complete-transcriptome support and direction. (C) Linked phage representatives by current catalogue-annotation status. The network represents CRISPR-derived candidate links, not direct infection, treatment response, or host-range validation. None of the linked phage representatives passes the manuscript's high-quality classified viral operational taxonomic unit (vOTU) filter. Full link and catalogue audits are provided in Supplementary Table S9.

**Supplementary Figure S9. Exploratory microbial and phage differential abundance.** (A) Bray-Curtis principal-coordinate representations of relative-abundance profiles for the 348 metagenome-assembled genomes (MAGs) and 616 high-quality viral operational taxonomic units (vOTUs) with viral genes. Lines connect cycles within each membrane and sampling phase; colour denotes membrane, shape denotes phase, and labels denote cycle. (B) Phase- and cycle-adjusted DESeq2 log2 fold-changes and -log10 adjusted P values. Highlighted features meet Benjamini-Hochberg false discovery rate (BH FDR) < 0.05 and an absolute log2 fold-change of at least 1. The adjusted models identified one of 348 tested MAGs and none of 560 tested vOTUs. Condition-only results, matched centred-log-ratio (CLR) effects and exhaustive label-swap statistics are provided in Supplementary Table S10, not additional panels. These repeated observations do not provide independent membrane replication; the comparisons neither establish community equivalence nor a causal treatment effect.

**Supplementary Figure S10. Longitudinal cDNA-derived 16S community profiles.** (A) Relative abundance of the 25 named families with the highest mean abundance across the 12 complementary-DNA (cDNA)-derived samples. Other classified families and unclassified families are retained separately, with no renormalisation to the displayed named families. Shared family labels use the same colours as the MAG profiles; SILVA and Genome Taxonomy Database (GTDB) assignments remain separate. Families were assigned using SILVA 138.2 (Quast et al., 2013) after DADA2 inference (Callahan et al., 2016). (B) Bray-Curtis principal-coordinate representation, with arrows connecting cycles within each membrane and sampling phase. Point labels denote cycle. (C) Observed amplicon sequence variants (ASVs) and Shannon diversity across cleaning cycles. (D) Consecutive-cycle Bray-Curtis dissimilarity calculated from the unrarefied ASV table. Green denotes control and violet phage-UV; circles denote initial samples and triangles backflush samples. The returned analysis used 150,000 primer-trimmed read pairs per sample before denoising. Lines connect repeated observations from the same membrane and phase, not independent replicates; no treatment hypothesis-test results are displayed. ASV counts and longitudinal summaries are provided in Supplementary Table S11.
