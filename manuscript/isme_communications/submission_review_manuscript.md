Heterogeneous organism-resolved transcriptional restructuring across repeated phage-UV cleaning of anaerobic membrane biofilms

**Original Article**

**Running title:** Biofilm response to repeated phage-UV

Yevhen Myshkevych^1^, Giantommaso Scarascia^1^, Julie Sanchez Medina^1^,
Shaman Narayanasamy^1,2^, Venkata Satagopam^2^, and Pei-Ying Hong^1^

^1^ Environmental Science and Engineering Program, Biological and Environmental
Sciences & Engineering Division, King Abdullah University of Science and
Technology, Thuwal 23955-6900, Saudi Arabia

^2^ Luxembourg Centre for Systems Biomedicine, ELIXIR Luxembourg, University of
Luxembourg, Belval L-4367, Luxembourg

**Corresponding author:** Pei-Ying Hong, King Abdullah University of Science and
Technology, Thuwal 23955, Saudi Arabia; peiying.hong@kaust.edu.sa

**Author review note:** The author list, order, current affiliations,
corresponding-author designation, ORCID identifiers, contribution statement,
funding, and competing-interest declaration require confirmation. The list and
corresponding author above are inherited from the publication describing the
experimental system and are not treated as approved for this reanalysis. The
collaborator-owned 16S analysis is pending and is not represented as a result in
this version.

## Abstract

Combined bacteriophage and ultraviolet C cleaning can delay fouling of anaerobic
membrane bioreactors, but the community-wide context of this response is
unresolved. We analysed all expressed features from one control membrane and
one treated membrane sampled during two phases of three cleaning cycles.
Genome-resolved metagenomes showed diverse, changing community profiles, while
the global metatranscriptome was organised primarily by cleaning cycle. Of
1,734,019 input features, 361,907 passed a predeclared filter. After adjustment
for phase and cycle, 7,703 differed between membranes at a Benjamini-Hochberg
false discovery rate below 0.05, with 7,699 also exceeding an absolute log2
fold-change of 1. The signal was broad and bidirectional, while its functional
support was narrow. Genes assigned to the canonical bacterial damage-response
regulatory system were collectively higher-ranked in the treated membrane, but
the median log2 fold-change was 0.136 and the other seven predefined repair and
stress categories were unsupported. By contrast, 175 of 340 eligible
metagenome-assembled genomes carried coherent gene-set signals, split between
100 treated-membrane-higher and 75 control-membrane-higher sets. A predeclared
recurrence filter retained 6,985 genes across the six phase-cycle cells, again
in both directions. Five coverage-qualified genomes showed organism-specific
population stability and turnover without a uniform membrane-associated
pattern. Because each condition is represented by one membrane, treatment and
membrane identity are confounded. Repeated cleaning therefore coincided with
broad, organism-resolved transcriptional restructuring in this system, not a
uniform damage-response or adaptation programme.

**Keywords:** anaerobic membrane bioreactor; bacteriophage; UV-C; biofouling;
metatranscriptomics; genome-resolved analysis

## Introduction

Membrane biofouling constrains anaerobic membrane bioreactors and creates a
recurring need for cleaning [@Scarascia2021]. A combined bacteriophage and ultraviolet C (UV-C) procedure was
developed as a chemical-free alternative to conventional cleaning. In the
initial proof-of-concept, this procedure reduced membrane-associated cells and
extracellular polymeric substances while maintaining membrane flux [@Scarascia2021]. A subsequent experiment extended the procedure across three
cleaning cycles. Regrowth of transmembrane pressure remained delayed, although
bacterial-cell and protein removal declined over successive cycles
[@Myshkevych2025].

Membrane biofilms are dynamic communities whose membership and functional
potential can change during colonisation and maturation [@Lu2016; @Cheng2019]. Whether this changing engineering performance reflects a
uniform microbial response is less clear. The repeated-cycle study reported transcriptional
changes in selected biofilm-forming organisms and proposed that repeated
exposure could favour adaptation [@Myshkevych2025]. Yet a signal in
selected organisms or stress genes need not represent the wider community. It
can be embedded in shifts in community composition, organism abundance,
physiological state, membrane history, or sampled fraction. Resolving that
structure requires the full expressed feature universe to be modelled before
functional or taxonomic labels determine interpretation.

Here, we place the metatranscriptome within its genome-resolved community
context and ask three connected questions: whether predefined DNA-repair and
stress functions shift collectively, whether individual organisms carry
coherent multi-gene signals, and whether gene-level differences recur across
the six phase-cycle cells. We then examine population-genomic variation in a
coverage-qualified five-genome set as descriptive context. The experiment
repeatedly sampled one membrane per condition, so treatment is inseparable from
membrane identity. We therefore seek reproducible structure within this
longitudinal two-membrane system, not a population-level causal treatment
effect.

## Materials and Methods

### Experimental design and sequencing data

The reactor configuration, membrane-cleaning procedure, and sampling strategy
were described by Myshkevych et al. (2025). One membrane was cleaned with
Milli-Q water and one membrane received the combined bacteriophage and UV-C
procedure. Material was collected from the initial and backflush fractions in
cycles 1, 2, and 3. The resulting design contained 12 physical samples, with one
sample in each membrane-by-phase-by-cycle cell. Raw sequencing data are
available from the European Nucleotide Archive under study accession
PRJEB79569.

The metatranscriptomic input comprised 23 sequencing-run count tables. Eleven
physical samples had two technical sequencing runs and one physical sample had
one run. Runs were mapped to physical samples using the versioned sample
metadata and summed once before modelling. Count-table parsing retained the
first data record from the headerless inputs and rejected conflicting duplicate
feature records. Features were represented by coordinate-aware identifiers
containing the contig, start, end, gene identifier, and strand.

Metagenome-assembled genome (MAG)-level community profiles were calculated from the metagenomic CoverM
read-count matrix [@Aroney2025]. Archived workflow metadata preserves
the exact command and reported metrics, but not the resolved CoverM package
version because the unpinned runtime environment was removed. Read counts were
joined to the CAT/BAT-GTDB classification and summed by family within each
physical sample.
Relative abundance was calculated within the MAG-mapped read total. The 25
families with the highest mean relative abundance were displayed using a
microshades-inspired hierarchy in which phylum determined hue and taxonomic
resolution determined shade [@Dahl2022]. The resulting profiles
describe the recovered MAG fraction rather than absolute whole-community
abundance.

The staged viral catalogue contained 607 deduplicated, classified,
high-quality viral operational taxonomic units (vOTUs) after quality assessment with CheckV 1.1.1 and database
v1.5 [@Nayfach2021]. Viral taxonomy was summarised as classification
paths and realms. These summaries describe catalogue composition; they are not
sequence phylogenies or measurements of treatment response.

### Complete-universe differential expression

Differential expression was performed in R 4.5.1 using edgeR 4.8.2 [@Robinson2010edgeR]. The unfiltered matrix contained 1,734,019 features across the 12
physical samples. Features were retained with `edgeR::filterByExpr` using a
minimum count of 10, a minimum total count of 15, and the phase- and
cycle-adjusted design. Library composition was normalised by the trimmed mean
of M-values (TMM) method [@Robinson2010TMM].

Two negative-binomial quasi-likelihood models were fitted. The main design,
`~ phase + cycle + condition`, estimated the phage-UV-minus-control coefficient
after adjustment for phase and cycle. The interaction design,
`~ phase + cycle * condition`, estimated the cycle-2 and cycle-3 departures from
the cycle-1 membrane contrast and a two-degree-of-freedom condition-by-cycle
omnibus test. The interaction coefficients are departures from cycle 1, not
standalone membrane contrasts within cycles 2 or 3. Raw P values were adjusted
by the Benjamini-Hochberg (BH) false discovery rate (FDR) method within each predeclared coefficient family
[@Benjamini1995]. Function, taxonomy, and effect direction were
not used to select features before fitting.

### Functional annotation and competitive gene-set tests

Primary gene annotations generated with Bakta 1.12.0 and the full Bakta
database 6.0 build dated 2025-02-24 were joined to the model results by
MAG and gene identifier [@Schwengers2021]. MAG taxonomy was joined from the staged CAT/BAT 6.0.1 classification
against a Genome Taxonomy Database (GTDB)-derived database build dated 2023-11-21 [@vonMeijenfeldt2019; @Parks2022]. The exact GTDB release tag was not preserved and is
not inferred from other projects. Annotation and taxonomy failures were
retained as explicit audit categories.

Eight functional categories were fixed before category-level interpretation:
photoreactivation, nucleotide-excision repair, recombination repair, SOS
response, base-excision and oxidative repair, oxidative stress, redox stress,
and general stress. Membership was taken from the versioned signature registry
and de-duplicated within category. The competitive background contained all
361,907 tested features, including unannotated and non-MAG features.

For one-degree-of-freedom coefficients, the signed gene statistic was defined as
`sign(logFC) x sqrt(F)`. Categories were tested with the rank-based `cameraPR`
competitive test in limma 3.66.0, using a preset inter-gene correlation of 0.01
[@Wu2012]. The omnibus statistic was `sqrt(F)` and was tested without
direction. Categories required at least 10 tested features. Benjamini-Hochberg
adjustment was applied across the eight categories separately for each
coefficient.

### Organism-resolved transcriptional coherence

MAG-level gene sets required at least 20 tested genes and median detection in at
least six of the 12 physical samples. Coherent organism-level direction was
tested with the same rank-based competitive procedure. P values were adjusted
across eligible MAGs within each coefficient. The audit table retained tested
and total gene counts, mean expression, sample detection, annotation coverage,
and GTDB taxonomy. Direction refers to the rank of genes within a MAG for the
specified coefficient. It does not imply a change in organism abundance.

### Recurrent expression across phase-cycle cells

Six-cell recurrence was defined descriptively. TMM-normalised log2 counts per
million were calculated from the collapsed raw-count matrix with a prior count
of 0.5. The phage-UV-minus-control difference was calculated separately for the
initial and backflush fractions in cycles 1, 2, and 3. A gene was recurrent when
at least five of the six cell differences shared a direction and the absolute
median difference was at least 1 log2 counts per million. Candidate genes also
required an adjusted-condition FDR below 0.05, an absolute adjusted-condition
log2 fold-change of at least 1, detection in at least six samples, and a
non-empty annotation. Recurrence labels were used to organise the supported
genes. They were not treated as a second hypothesis test.

### Descriptive population-genomic comparisons

Population-genomic comparisons used the scoped priority-20 inStrain 1.10.0
analysis [@Olm2021]. A sample pair was retained when at least 1 million base pairs (Mbp) and
50% of the callable genome were compared. A MAG was retained for the descriptive
panel when it had at least 10 qualified pairs spanning at least six samples.
Consensus differences were divided by callable bases and expressed per Mbp. No
statistical comparison by condition, phase, or cycle was performed. The scoped
MAGs originated from earlier host-link and signature priorities and are not a
community-representative set.

### Experimental-unit and inferential boundary

The repeated observations do not provide independent treatment replication.
There is one control membrane and one phage-UV membrane. Membrane history,
position, and treatment cannot be separated. Model P values quantify the
consistency of the fitted coefficients within these 12 observations. They do
not establish a population-level treatment effect, UV-induced mutation, or
adaptation. Functional transcription was not treated as direct evidence of DNA
lesions. Population-genomic outputs were interpreted only as descriptive
within-organism context.

## Results

### Community composition and transcriptome geometry changed through the cleaning cycles

The 23 sequencing runs collapsed to 12 physical-sample libraries, one for each
membrane-by-phase-by-cycle cell (Figure 1A). The MAG-mapped metagenomic reads
showed a taxonomically diverse community across these observations. No named
family exceeded 6.6% mean relative abundance across the 12 profiles, and the
identity and abundance of prominent families changed among cycles and phases
(Figure 1B). This descriptive profile establishes the community through which
the transcriptional results are interpreted; it is not a replicated test of a
treatment effect.

In the leading log-fold-change space, samples were organised primarily by
cycle. Cycle-1 samples occupied the left of the ordination, cycle-2 samples the
lower right, and cycle-3 samples the upper right. Samples from the two membranes
were generally close within matched phase-cycle cells (Figure 1C). The complete
expression geometry therefore did not show a simple global separation by
condition.

### The adjusted membrane coefficient was broad but bidirectional

Of 1,734,019 input features, 361,907 passed the predeclared expression filter
(20.9%; Supplementary Figure S1A). The phase- and cycle-adjusted membrane
coefficient identified 7,703 features at FDR < 0.05. Of these, 7,699 also had an
absolute log2 fold-change of at least 1, comprising 3,694 phage-UV-higher and
4,005 control-higher features (Figure 2A). The fitted system-specific membrane
contrast was thus broad and almost evenly bidirectional, even though it was not
the dominant axis of the sample ordination.

Cycle-specific departures were sparse at the individual-feature level. The
cycle-2 and cycle-3 interaction coefficients contained 1 and 11 features at
FDR < 0.05, respectively. The two-degree-of-freedom interaction omnibus
contained 357 supported features (Supplementary Figure S2). The main
transcriptional result was the adjusted membrane contrast, not a progressive
increase in cycle-specific differential expression.

### Functional support was restricted to a modest SOS ranking and a cycle-2 redox signal

Among the tested features, 4,119 mapped to at least one of the eight predefined
repair and stress categories. SOS-response genes were collectively
higher-ranked for the adjusted membrane coefficient (523 genes; `cameraPR` raw
P = 2.58 × 10^-4, BH FDR = 2.07 × 10^-3; Figure 2B). The category-level result
was statistically supported, but the gene-level shift was modest. Median log2
fold-change was 0.136, and 57.9% of SOS genes had positive coefficients.

Photoreactivation, nucleotide-excision repair, recombination repair,
base-excision and oxidative repair, oxidative stress, redox stress, and general
stress were unsupported for the adjusted membrane coefficient (BH FDR range
0.642 to 0.892; Figure 2B). Redox-stress genes were higher-ranked for the
cycle-2 interaction coefficient (1,227 genes; raw P = 1.19 × 10^-3, BH FDR =
9.51 × 10^-3). No category was supported for the cycle-3 interaction or the
condition-by-cycle omnibus (Supplementary Figure S3). The functional evidence
did not define a broad or recurrent DNA repair programme.

### Organism-resolved transcriptional signals were widespread and bidirectional

Of 348 classified MAGs, 340 met the expression-support criteria. The adjusted
membrane coefficient supported 175 MAG-level gene sets, comprising 100 with
phage-UV-higher genes and 75 with control-higher genes (Figure 2C). The 24
strongest supported sets selected for display spanned multiple phyla and both
directions of median gene-level change (Figure 2D). No single taxonomic group
accounted for the organism-level result.

The interaction models also contained coherent MAG-level structure. The
cycle-2 interaction supported 133 MAGs, with 68 up-ranked and 65 down-ranked
gene sets. The cycle-3 interaction supported 132 MAGs, with 73 up-ranked and 59
down-ranked sets (Supplementary Figure S4). These competitive results can
detect a coordinated shift across many genes even when few individual genes
pass feature-level FDR. Across coefficients, the nearly balanced directions
showed that the recovered community did not follow one uniform
metatranscriptomic response.

### Recurrent gene-level differences remained balanced in direction

The recurrence procedure traced the complete tested universe through four
predeclared filters (Figure 3A). Of 361,907 tested features, 7,699 met the
adjusted-condition FDR and effect-size thresholds, 7,603 were detected in at
least six samples, 7,141 had a non-empty annotation, and 6,985 met the
five-of-six-cell recurrence rule. Among the recurrent genes, 3,334 were
phage-UV higher and 3,651 were control higher. Six-of-six directional agreement
was observed for 2,671 phage-UV-higher and 2,709 control-higher genes; the
remaining 663 and 942 genes, respectively, agreed in five of six cells
(Figure 3B).

The 24 deterministically selected display genes included transport,
carbohydrate metabolism, transcriptional regulation, protein homeostasis, and
general stress annotations (Figure 3C). These labels describe the candidate
catalogue. They do not constitute a pathway-enrichment result. Recurrence
reinforced the organism-level evidence: stable differences occurred in both
directions and were not confined to DNA repair functions.

### Population-genomic heterogeneity was organism-specific

Five MAGs passed the pairwise and organism-level coverage rules. Their median
consensus-difference rates ranged from 29.4 to 1,114.1 per callable Mbp, with
substantial variation among pairs within several MAGs (Figure 4A,B). The five
qualified organisms therefore did not share a common level or temporal pattern
of genomic similarity.

The clearest structured example occurred in *Propionicimonas* sp023458095. All
six coverage-qualified initial-fraction observations belonged to strain cluster
S1. The two qualified cycle-3 backflush observations were distinct from those
initial observations and from each other, with the control observation assigned
to S3 and the phage-UV observation assigned to S2 (Figure 4A,C). The other MAGs
showed stable, isolated, or irregular transitions (Supplementary Figure S5).
The strongest pattern in this selected set was associated with organism and
sample fraction, not a uniform condition-associated trajectory. These data do
not demonstrate treatment-induced mutation or adaptation.

Taxonomy-derived summaries place these organism-level results within catalogues
of 348 classified MAGs and 607 high-quality classified vOTUs (Supplementary
Figure S6; Supplementary Figure S7). These classification-derived diagrams
describe recovered taxonomic breadth. They are not sequence phylogenies and do
not encode a treatment response or host-phage linkage.

CRISPR-derived candidate linkage connected 80 host MAGs to 85 phage contigs
through 86 deduplicated SpacePHARER pairs (Supplementary Figure S8). Forty-nine
linked hosts also carried a supported adjusted-membrane MAG coefficient, but
the direction was mixed. Only 12 linked phage representatives had a current
catalogue annotation, and none passed the manuscript's high-quality classified-
vOTU filter. The network therefore records candidate historical exposure rather
than active infection, validated host range, or treatment response.

## Discussion

The complete metatranscriptome changes the scale of the biological
interpretation. Cleaning cycle organised the global sample geometry. After
cycle and phase were modelled, the two membranes differed across thousands of
features, but those differences were almost evenly split in direction and
distributed across many organisms. The strongest supported interpretation is
therefore heterogeneous organism-resolved restructuring, not a single stress
programme shared across the community.

The SOS result remains part of that story, but it does not define it. SOS genes
were collectively higher-ranked in the phage-UV membrane, and the competitive
test remained significant against the complete expressed background. However,
the median shift was small, almost 42% of SOS genes had negative coefficients,
and none of the other seven repair and stress categories was supported for the
same coefficient. Transcription of an SOS-associated gene set is not a direct
measurement of DNA lesions because SOS induction is a regulated response that
varies across organisms and physiological contexts [@Maslowska2019].
Calling this a community-wide DNA-damage response would exceed the evidence.

The organism-level analysis explains why a narrow pathway account was
insufficient. More than half of the eligible MAGs carried a coherent adjusted
membrane signal, and both directions were common. The recurrence analysis
recovered the same structure at gene level. Thousands of genes differed in at
least five of six phase-cycle cells, but the recurrent catalogue remained
balanced between the two membranes and crossed diverse annotations. The
community was structured at the level of organisms and genes. It was not moving
as one unit.

This structure cannot be assigned entirely to transcriptional regulation.
The RNA counts were not normalised to matched DNA abundance, so MAG-level
gene-set coherence cannot separate organism abundance from cellular RNA output.
The changing MAG-mapped metagenomic profiles make community turnover a
plausible contributor, but the present analysis does not fit a joint DNA-RNA
model. We therefore use transcriptional restructuring to describe the observed
RNA landscape, not to claim a uniform per-cell regulatory response.

The population-genomic analysis adds context without rescuing an adaptation
claim. Coverage-qualified comparisons revealed both stable and changing strain
assignments, but only five preselected MAGs met the descriptive criteria. In the
clearest case, *Propionicimonas*, the separation followed the initial versus
backflush fractions more strongly than condition. This pattern is compatible
with spatial or fraction-specific population structure. It does not identify
its cause. The genomic data should therefore remain a qualitative layer rather
than a statistical treatment analysis.

The experimental unit sets the final boundary. One membrane represents each
condition, so treatment is confounded with membrane identity. Repeated cycles
and fractions improve the resolution of change within the system, but they do
not create independent treatment replicates. The reported P values and FDRs are
useful for organising internally consistent signals across the observed
samples. They cannot support a general causal estimate for phage-UV cleaning.

The present evidence supports a precise conclusion: the two repeatedly sampled
membranes developed broad, bidirectional, organism-resolved differences in
their transcriptomes, whereas a uniform damage-response or adaptation
programme was not supported. Future replicated experiments should separate
membrane identity from cleaning treatment and pair metagenomic abundance with
transcription at each time point.


## Acknowledgments

We thank the KAUST FM Utilities team for providing access to raw wastewater
samples. [AUTHOR CONFIRMATION REQUIRED]

## Author contributions

Proposed CRediT statement for author review: Yevhen Myshkevych: investigation,
methodology, and writing - review and editing. Giantommaso Scarascia:
investigation, conceptualisation, and writing - review and editing. Julie
Sanchez Medina: methodology, investigation, and writing - review and editing.
Shaman Narayanasamy: conceptualisation, data curation, formal analysis,
methodology, software, visualisation, writing - original draft, and writing -
review and editing. Venkata Satagopam: resources, software, and writing - review
and editing. Pei-Ying Hong: conceptualisation, funding acquisition, project
administration, resources, supervision, and writing - review and editing. All
roles require confirmation by the authors.

## Funding

The experimental study was supported by KAUST baseline grant BAS/1/1033-01-01
awarded to Pei-Ying Hong. The authors must confirm whether this grant supported
the present reanalysis and identify any additional support before submission.

## Conflict of interest

The authors declare no competing interests. [ALL AUTHORS TO RECONFIRM]


## Data availability

Raw sequencing data are available from the European Nucleotide Archive under
PRJEB79569 (secondary study accession ERP163720). Analysis code, sample
metadata, software versions, explicit upstream provenance gaps, input
checksums, output checksums, and exact output provenance are versioned in the
project repository (https://github.com/shaman-narayanasamy/phage_uv_ecology_analysis) and its manifests. The complete statistical tables
underlying all displayed summaries are retained in the project-derived data
store.

## References

::: {#refs}
:::

## Figures

![](manuscript/isme_communications/review_assets/figure1.png){width=6.5in}

**Figure 1. Experimental system, community trajectory, and transcriptome
geometry.** (A) One
control membrane and one phage-UV membrane sampled during the initial and
backflush phases of three cleaning cycles, giving 12 physical samples. (B)
Relative abundance among MAG-mapped metagenomic reads for the top 25 classified
families across the same six aligned cycle-phase positions. Named families use
phylum-linked microshades adapted from Dahl et al. (2022); pale shades pool
remaining or unresolved families within the same phylum, and grey denotes phyla
outside the displayed set. The profile is descriptive and does not constitute a
replicated treatment test.
(C) Leading log-fold-change dimensions calculated from the TMM-normalised
filtered expression matrix. Point colour denotes membrane, point shape denotes
phase, and labels denote cycle.

Alt text: Three-panel figure showing the two-membrane sampling design, stacked family-level community profiles across six aligned cycle-phase observations, and leading log-fold-change coordinates for the 12 metatranscriptomic samples.

\newpage

![](manuscript/isme_communications/review_assets/figure2.png){width=6.5in}

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

Alt text: Four-panel figure showing the adjusted membrane expression landscape, competitive repair and stress category results, counts of supported genome-level gene sets by direction, and median effects for the strongest supported organisms.

\newpage

![](manuscript/isme_communications/review_assets/figure3.png){width=6.5in}

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

Alt text: Three-panel figure showing the recurrent-gene selection funnel, counts by directional agreement across six cells, and a heatmap of cell-level differences for 24 deterministically selected genes.

\newpage

![](manuscript/isme_communications/review_assets/figure4.png){width=6.5in}

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

Alt text: Three-panel figure showing strain-cluster membership for five coverage-qualified genomes, their pairwise consensus-difference summaries, and the pairwise landscape for Propionicimonas sp023458095.

## Supplementary figures

![](manuscript/isme_communications/review_assets/supplementary_figure_s1.png){width=6.5in}

**Supplementary Figure S1. Feature, library, and model diagnostics.** (A) Number
of input features and features retained by the predeclared expression filter.
(B) Retained and TMM-effective library sizes for the 12 physical samples. Filled
points denote effective library size; open points denote the retained raw
library size. Colour denotes membrane and shape denotes phase. (C) Median and
interquartile range of trended dispersion, tagwise dispersion, and
quasi-likelihood posterior variance for the adjusted-condition and
condition-by-cycle models.

Alt text: Three-panel diagnostic figure summarising feature filtering, retained and effective library sizes, and model-dispersion estimates.

\newpage

![](manuscript/isme_communications/review_assets/supplementary_figure_s2.png){width=6.5in}

**Supplementary Figure S2. Complete-universe condition-by-cycle interaction
landscapes.** (A) Average log2 counts per million and interaction log2
fold-change for the cycle-2 and cycle-3 departures from the cycle-1 membrane
contrast. Filled points passed BH FDR < 0.05; open grey points are deterministic
context samples. (B) Average log2 counts per million and -log10(BH FDR) for the
two-degree-of-freedom condition-by-cycle omnibus. The dotted line marks BH FDR
= 0.05.

Alt text: Expression landscapes for cycle-2 and cycle-3 interaction coefficients and the two-degree-of-freedom interaction omnibus.

\newpage

![](manuscript/isme_communications/review_assets/supplementary_figure_s3.png){width=6.5in}

**Supplementary Figure S3. Predefined functional categories across all
coefficients.** Competitive rank-test results for eight repair and stress
categories in the adjusted membrane, cycle-2 interaction, cycle-3 interaction,
and interaction-omnibus coefficients. Directional coefficients are signed by
gene-rank direction. Omnibus values are non-directional and positive. Filled
points passed BH FDR < 0.05; open points did not.

Alt text: Competitive rank-test results for eight predefined repair and stress categories across four model coefficients.

\newpage

![](manuscript/isme_communications/review_assets/supplementary_figure_s4.png){width=6.5in}

**Supplementary Figure S4. MAG-level coherence across directional
coefficients.** (A) Number of eligible MAG gene sets passing BH FDR < 0.05 in
the up-ranked and down-ranked directions for the adjusted membrane, cycle-2
interaction, and cycle-3 interaction coefficients. (B) Median gene-level log2
fold-change and -log10(BH FDR) for all eligible MAG sets. Filled points passed
BH FDR < 0.05; open points did not. Interaction coefficients are departures
from cycle 1.

Alt text: Counts and effect summaries for eligible genome-level gene sets across the adjusted membrane and two interaction coefficients.

\newpage

![](manuscript/isme_communications/review_assets/supplementary_figure_s5.png){width=6.5in}

**Supplementary Figure S5. Coverage-qualified pairwise population-genomic
landscapes.** Pairwise consensus differences per callable Mbp for all five MAGs
passing the organism-level coverage rules. Grey cells indicate unavailable or
coverage-failing comparisons. Pairs required at least 1 Mbp and 50% of the
callable genome.

Alt text: Coverage-qualified pairwise consensus-difference matrices for the five genomes retained for descriptive population-genomic analysis.

\newpage

![](manuscript/isme_communications/review_assets/supplementary_figure_s6.png){width=6.5in}

**Supplementary Figure S6. MAG taxonomic context and family-level community
profile.** (A) Taxonomy-derived circular dendrogram of 348 dereplicated MAGs.
Tip points denote GTDB phylum. Concentric rings show estimated completeness,
estimated contamination, adjusted-membrane gene-set coherence, and
recurrent-gene balance. (B) Relative abundance of the 15 most abundant
classified families, unclassified MAGs, and all remaining classified families
among MAG-mapped metagenomic reads. Control is aligned above phage-UV across the
six cycle-phase observations. The dendrogram is classification-derived, not a
sequence phylogeny, and the abundance profiles are descriptive.

Alt text: Taxonomy-derived circular dendrogram for 348 genomes with quality and transcriptomic rings, paired with aligned stacked family-level metagenomic profiles.

\newpage

![](manuscript/isme_communications/review_assets/supplementary_figure_s7.png){width=6.5in}

**Supplementary Figure S7. vOTU taxonomic context.** (A) Taxonomy-derived
cladogram of 607 deduplicated high-quality vOTUs after quality assessment with
CheckV [@Nayfach2021], grouped into 45 taxonomic paths. Point colour
denotes realm and point size denotes group size. (B) Number
of qualifying vOTUs in each realm. The cladogram is not a sequence phylogeny
and does not encode treatment response or host-phage linkage.

Alt text: Taxonomy-derived cladogram for 607 high-quality viral operational taxonomic units, grouped into 45 taxonomic paths, with realm-level catalogue counts.

\newpage

![](manuscript/isme_communications/review_assets/supplementary_figure_s8.png){width=6.5in}

**Supplementary Figure S8. CRISPR-derived host-phage candidate-link evidence
audit.** (A) Eighty host MAGs and 85 phage contigs connected by 86 deduplicated
SpacePHARER candidate pairs. Host-node colour denotes GTDB phylum, phage-node
shape denotes the mapped viral realm, edge width denotes the number of
SpacePHARER hits, and edge colour overlays the support and direction of the host
MAG's current adjusted membrane coefficient. Labels identify the six host MAGs
linked to two phage candidates and the single phage candidate linked to two
hosts. (B) Linked host MAGs by current complete-transcriptome support and
direction. (C) Linked phage representatives by current catalogue-annotation
status. The network represents CRISPR-derived candidate links, not direct
infection, treatment response, or host-range validation. None of the linked
phage representatives passes the manuscript's high-quality classified-vOTU
filter.

Alt text: Bipartite evidence-audit network connecting 80 host genomes to 85 phage contigs through 86 deduplicated CRISPR-derived candidate links, with host-expression and viral-catalogue context.
