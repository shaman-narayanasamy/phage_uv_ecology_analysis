# Proposed manuscript draft for review

Status: proposed text, not an approved live manuscript. This draft preserves
the quarantined legacy scaffold separately and follows the completed #22 and
#23 analyses. Figure numbers and main-versus-supplementary placement remain
unassigned.

## Working title

Repeated phage-UV cleaning is associated with organism-resolved
transcriptional restructuring in anaerobic membrane biofilms

## Abstract

Combined bacteriophage and ultraviolet C cleaning can delay membrane fouling
in anaerobic membrane bioreactors, but the accompanying community-wide
transcriptional structure remains unresolved. We analysed metatranscriptomic
gene counts from one control membrane and one phage-UV-treated membrane sampled
across three cleaning cycles and two fractions. Twenty-three sequencing runs
were collapsed into 12 physical samples before modelling. Of 1,734,019 input
features, 361,907 passed the predeclared expression filter. The phase- and
cycle-adjusted condition coefficient identified 7,703 features at a
Benjamini-Hochberg false discovery rate below 0.05, of which 7,699 had an
absolute log2 fold-change of at least 1. Functional interpretation was narrow:
SOS-response genes were collectively higher-ranked in the treated membrane
(rank-based competitive test, raw p = 2.58 × 10^-4, FDR = 2.07 × 10^-3), while
the other predefined repair and stress categories were not supported for this
coefficient. Organism-resolved tests identified bidirectional transcriptional
structure in 175 of 340 eligible metagenome-assembled genomes, split between
100 higher-ranked and 75 lower-ranked genomes. A predeclared recurrence filter
retained 3,334 treatment-higher and 3,651 control-higher genes across the six
phase-cycle cells. The transcriptome therefore resolves heterogeneous,
organism-specific restructuring rather than a uniform DNA-repair programme.
Condition is confounded with membrane identity, so these results describe this
longitudinal two-membrane system and do not establish a population-level causal
treatment effect.

## Introduction

Membrane biofouling limits the operation of anaerobic membrane bioreactors and
creates a recurring requirement for membrane cleaning. Combining bacteriophages
with ultraviolet C irradiation provides a biologically based alternative to
chemical cleaning. The initial proof-of-concept reduced membrane-associated
cells and extracellular polymeric substances while maintaining membrane flux
([Scarascia et al. 2021](https://doi.org/10.1073/pnas.2016529118)). The repeated-
cycle experiment subsequently showed sustained engineering efficacy over three
cleaning cycles, alongside progressively reduced cell and protein removal
([Myshkevych et al. 2025](https://doi.org/10.1016/j.ceja.2025.100796)).

The published repeated-cycle analysis proposed transcriptional adaptation among
selected biofilm-forming bacteria. We aimed to test the metatranscriptome at
community scale, without beginning from a preselected DNA-repair, SOS, biofilm,
or organism subset. To that end, we modelled the complete expressed feature
universe, applied functional and taxonomic annotations only after model fitting,
and asked three questions: i) whether predefined repair and stress functions
were collectively shifted, ii) whether individual organisms contributed
coherent multi-gene signals and iii) whether gene-level differences recurred
across phase-cycle cells.

The experiment contains one membrane per condition, repeatedly observed across
cycles and phases. Condition is therefore inseparable from membrane identity.
The analysis is framed as a longitudinal description of these two membranes,
not as a replicated causal treatment test.

## Methods

### Experimental design and sequencing data

The reactor configuration, membrane-cleaning procedure and sampling strategy
were described by Myshkevych et al. (2025). Briefly, one control membrane was
cleaned with MilliQ water and one treated membrane received the combined UV-C
and bacteriophage procedure. The present analysis used initial and backflush
material from cycles 1 to 3, giving 12 physical samples across two conditions,
two phases and three cycles. Raw sequencing data are available from the
European Nucleotide Archive under study accession PRJEB79569.

The metatranscriptomic dataset contained 23 sequencing-run count tables. Eleven
physical samples had two technical sequencing runs and one sample had a single
run. Technical runs were mapped to physical samples through the versioned sample
metadata and summed exactly once before analysis. Count-table parsing retained
the first record from the headerless inputs and rejected conflicting duplicate
feature records. Features were represented by coordinate-aware identifiers
containing contig, start, end, gene identifier and strand.

### Transcriptome-wide differential expression

Differential expression was performed in R 4.5.1 with edgeR 4.8.2
([Robinson et al. 2010](https://doi.org/10.1093/bioinformatics/btp616)). The
unfiltered matrix contained 1,734,019 features across 12 physical samples.
Features were retained with `edgeR::filterByExpr`, using a minimum count of 10,
a minimum total count of 15 and the phase- and cycle-adjusted main design. This
retained 361,907 features. Library composition was normalised by the trimmed
mean of M-values method
([Robinson and Oshlack 2010](https://doi.org/10.1186/gb-2010-11-3-r25)).

Two negative-binomial quasi-likelihood models were fitted. The main design,
`~ phase + cycle + condition`, estimated the treatment-minus-control
coefficient adjusted for phase and cycle. The interaction design,
`~ phase + cycle * condition`, estimated the cycle-2 and cycle-3 departures
from the cycle-1 condition contrast and a two-degree-of-freedom omnibus
condition-by-cycle test. Raw p-values were adjusted by the Benjamini-Hochberg
method within each predeclared coefficient family
([Benjamini and Hochberg 1995](https://doi.org/10.1111/j.2517-6161.1995.tb02031.x)).
Features were not selected by function, taxonomy or effect direction before
model fitting.

### Functional annotation and competitive gene-set analysis

Primary Bakta gene annotations were joined to model results by MAG and gene
identifier after fitting. MAG taxonomy was joined from the staged CAT/BAT GTDB
classification table. Annotation and taxonomy failures were retained as
explicit audit categories.

Eight functional categories were fixed before category-level interpretation:
photoreactivation, nucleotide-excision repair, recombination repair, SOS
response, base-excision and oxidative repair, oxidative stress, redox stress
and general stress. Membership came from the pre-existing signature registry
and was de-duplicated within category. The competitive universe contained all
361,907 tested features, including unannotated and non-MAG features.

For one-degree-of-freedom coefficients, the signed gene statistic was defined
as `sign(logFC) × sqrt(F)`. Categories were tested with the rank-based
`cameraPR` competitive test in limma 3.66.0, using a preset inter-gene
correlation of 0.01
([Wu and Smyth 2012](https://doi.org/10.1093/nar/gks461)). The omnibus test used
`sqrt(F)` in a non-directional analysis. Categories required at least 10 tested
features. Benjamini-Hochberg adjustment was applied across the eight categories
separately for each coefficient.

### Organism-resolved and recurrent-expression summaries

MAG-level gene sets required at least 20 tested genes and median detection in
at least six of the 12 physical samples. Coherent organism-level direction was
tested with the same rank-based competitive procedure, with
Benjamini-Hochberg adjustment across eligible MAGs within each coefficient.
Support tables retained tested-gene counts, total counts, mean expression,
sample detection, annotation coverage and GTDB taxonomy.

Six-cell recurrence was descriptive. TMM-normalised log2 counts per million
were calculated from the collapsed raw-count matrix with a prior count of 0.5.
Treatment-minus-control differences were calculated separately for the initial
and backflush fractions in cycles 1 to 3. A gene was recurrent when at least
five of six differences shared a direction and the absolute median difference
was at least 1 log2 counts per million. Candidate genes additionally required
an adjusted-condition FDR below 0.05, absolute log2 fold-change of at least 1,
detection in at least six samples and a non-empty annotation. These recurrence
labels were not treated as additional hypothesis tests.

### Descriptive population-genomic context

Population-genomic comparisons were restricted to the scoped priority-20
inStrain analysis and were used only as descriptive context. A sample pair
required at least 1 Mbp and 50% of the callable genome, and a MAG required at
least ten qualified pairs spanning six samples. No statistical comparison by
condition, phase or cycle was performed. The scoped MAG set was selected using
earlier host-link and signature information and is not community-representative.

### Experimental-unit limitation

The repeated observations do not replace independent biological replication.
There is one control membrane and one treated membrane, so the condition
coefficient is confounded with membrane identity. Model p-values quantify
consistency within this observed two-membrane system. They cannot establish a
population-level treatment effect, UV-induced mutation or adaptation.

## Results

### The complete metatranscriptome separates a broad membrane-associated signal

Technical-run aggregation produced 12 physical-sample libraries from 23
sequencing runs. Of 1,734,019 input features, 361,907 passed the predeclared
expression filter. The adjusted condition model identified 7,703 features at
FDR < 0.05, of which 7,699 also had an absolute log2 fold-change of at least 1,
split between 3,694 treatment-higher and 4,005 control-higher features. The
cycle-2 and cycle-3 interaction coefficients identified 1 and 11 features at
FDR < 0.05, respectively, while the two-degree-of-freedom interaction omnibus
identified 357 features. The full result is therefore dominated by a broad,
bidirectional adjusted-condition signal, with comparatively sparse
coefficient-specific cycle departures (candidate global-DE figure and
complete #22 result tables).

### SOS genes are collectively shifted without a broad repair programme

Of the 361,907 tested features, 4,119 mapped to at least one of the eight frozen
repair and stress categories. SOS-response genes were collectively
higher-ranked for the adjusted condition coefficient (523 genes; rank-based
cameraPR competitive test, raw p = 2.58 × 10^-4, FDR = 2.07 × 10^-3). The
median gene log2 fold-change was 0.136 and 57.9% of SOS genes had positive
coefficients. Photoreactivation, nucleotide-excision repair, recombination
repair, base-excision and oxidative repair, oxidative stress, redox stress and
general stress were not supported for this coefficient, with FDR values from
0.642 to 0.892.

Redox-stress genes were higher-ranked for the cycle-2 interaction coefficient
(1,227 genes; raw p = 1.19 × 10^-3, FDR = 9.51 × 10^-3). No category was
supported for the cycle-3 interaction or the condition-by-cycle omnibus. The
functional result is a modest SOS-associated ranking and one cycle-relative
redox signal, not a broad or recurrent DNA-damage programme (candidate
functional-category enrichment figure and functional-category enrichment
table).

### Organism-resolved responses are widespread and bidirectional

All 342,632 tested MAG features mapped to the staged GTDB taxonomy table, and
340 of 348 classified MAGs met the predeclared expression-support criteria.
The adjusted-condition competitive tests supported 175 MAGs, split between 100
higher-ranked and 75 lower-ranked organisms. The cycle-2 interaction supported
133 MAGs, 68 higher-ranked and 65 lower-ranked, while the cycle-3 interaction
supported 132 MAGs, 73 higher-ranked and 59 lower-ranked. This breadth and
bidirectionality define a structured, organism-specific separation between the
two membranes rather than one uniform community-wide stress programme
(candidate MAG-coherence figure and MAG-coherence table).

### Recurrent gene differences occur in both directions

The effect, detection, annotation and recurrence criteria retained 6,985
genes. Of these, 3,334 were recurrently treatment-higher and 3,651 were
recurrently control-higher across the six phase-cycle cells. Candidate genes
included transport, carbohydrate metabolism, secretion, ribosomal, motility
and general regulatory annotations. These annotations define a discovery list,
not a predeclared pathway-family test. The balanced direction of recurrent
differences echoed the MAG-level result, broad ecological and transcriptional
differentiation rather than a one-way repair response (candidate recurrent-gene
heatmap and predeclared-gene candidate table).

### Population-genomic structure is organism-specific and descriptive

Five MAGs passed the predeclared pair and organism coverage rules. Their median
consensus differences ranged from approximately 29 to 1,114 SNPs per callable
Mbp. The clearest structured pattern occurred in *Propionicimonas*
sp023458095: all six qualified initial-fraction observations belonged to one
strain cluster, while the two qualified cycle-3 backflush observations formed
distinct clusters in both membranes. The remaining MAGs showed stable,
isolated or irregular transitions. No uniform condition-associated or
monotonic-cycle pattern was observed. These data describe possible population
stability and turnover among a selected five-MAG set; they do not test DNA
damage, mutagenesis or treatment-induced adaptation (candidate descriptive
population-genomics figure and corresponding QC tables).

## Discussion

The complete metatranscriptome changes the emphasis of the repeated-cleaning
experiment. The strongest signal is not a restricted DNA-repair programme. It
is a broad, bidirectional and organism-resolved difference between two
repeatedly sampled membranes. The SOS-associated gene set remains detectable
when placed in the complete transcriptome, but its median effect is modest and
the other repair categories are not collectively supported. This narrows the
interpretation of SOS transcription and prevents it from becoming a proxy for
UV-induced DNA damage.

On the one hand, thousands of recurrent gene differences and 175 supported
MAG-level signals demonstrate extensive transcriptional structure. On the
other hand, the nearly balanced directions, sparse cycle-specific genes and
negative category results argue against a single community-wide programme.
The organism-resolved signal is the robust finding of the metatranscriptomic
analysis, and it survives the transition from preselected quick checks to the
complete tested-feature universe.

The population-genomic analysis provides a separate descriptive layer. It
reveals organism-specific stability and turnover, including phase-associated
structure in *Propionicimonas*, but the selected MAG set and coverage
dependence prevent a community-wide inference. Host-phage links remain
available but are not required to explain the current result. The separately
owned 16S analysis can later provide an independent community-composition
layer, without changing the inferential boundary of the metatranscriptome.

The principal limitation is the experimental unit. One membrane represents
each condition, so membrane history, location and treatment cannot be
separated. The repeated phases and cycles improve longitudinal description but
do not provide biological treatment replication. The present analysis
therefore supports a precise conclusion: the treated and control membranes
show heterogeneous, organism-resolved transcriptional restructuring across
repeated observations, while broad DNA-damage, mutagenesis and adaptation
claims are not supported by this design.

## Candidate figure legends

The following legends are descriptive drafts. Candidate figures remain
unnumbered and unallocated.

**Functional-category enrichment.** Rank-based competitive tests of eight
predefined repair and stress categories across the adjusted condition,
cycle-2 interaction, cycle-3 interaction and non-directional interaction
omnibus coefficients. Filled points denote Benjamini-Hochberg FDR < 0.05 and
open points denote non-significant tests. Signed values place lower-ranked sets
to the left and higher-ranked sets to the right; omnibus values are
non-directional and shown as positive. Full statistics are provided in the
functional-category enrichment table.

**MAG-level transcriptional coherence.** Median gene-level adjusted-condition
log2 fold-change for 15 higher-ranked and 15 lower-ranked MAGs selected by the
predeclared MAG-set competitive test. Point colour denotes GTDB phylum, point
size denotes median mean expression and filled points denote
Benjamini-Hochberg FDR < 0.05. Full organism-level statistics and expression
support are provided in the MAG-coherence table.

**Recurrent gene-level differences across phase-cycle cells.**
Treatment-minus-control differences in TMM-normalised log2 counts per million
for 20 recurrently treatment-higher and 20 recurrently control-higher genes.
Rows satisfy the predeclared effect, detection, annotation and recurrence
criteria. Columns represent the initial and backflush fractions in cycles 1 to
3. Full candidate statistics are provided in the predeclared-gene table.

**Coverage-qualified pairwise population-genomic landscape.** Consensus SNP
differences per million compared bases for five MAGs with at least ten
qualified pairwise comparisons spanning at least six samples. Pairs required
at least 1 Mbp and 50% of the callable genome. Grey cells denote unavailable or
coverage-failing comparisons. Full pair and MAG quality-control metrics are
provided in the population-genomics tables.

## Data and code availability

Raw sequencing data are available from the European Nucleotide Archive under
PRJEB79569. Analysis code and exact provenance are recorded in this repository
and its code manifest. Generated tables, candidate figures, software versions,
input checksums and output checksums are recorded in the data manifest.

## References

- Benjamini Y, Hochberg Y. 1995. Controlling the false discovery rate: a
  practical and powerful approach to multiple testing. *Journal of the Royal
  Statistical Society Series B* 57:289-300.
  https://doi.org/10.1111/j.2517-6161.1995.tb02031.x
- Myshkevych Y, Scarascia G, Sanchez Medina J, Narayanasamy S, Satagopam V,
  Hong P-Y. 2025. Effectiveness of combined UV-C and bacteriophage approach
  over repeated cleaning cycles to alleviate membrane fouling of anaerobic
  bioreactors. *Chemical Engineering Journal Advances* 24:100796.
  https://doi.org/10.1016/j.ceja.2025.100796
- Robinson MD, McCarthy DJ, Smyth GK. 2010. edgeR: a Bioconductor package for
  differential expression analysis of digital gene expression data.
  *Bioinformatics* 26:139-140. https://doi.org/10.1093/bioinformatics/btp616
- Robinson MD, Oshlack A. 2010. A scaling normalization method for differential
  expression analysis of RNA-seq data. *Genome Biology* 11:R25.
  https://doi.org/10.1186/gb-2010-11-3-r25
- Scarascia G, Fortunato L, Myshkevych Y, Cheng H, Leiknes T, Hong P-Y. 2021.
  UV and bacteriophages as a chemical-free approach for cleaning membranes
  from anaerobic bioreactors. *Proceedings of the National Academy of Sciences
  of the United States of America* 118:e2016529118.
  https://doi.org/10.1073/pnas.2016529118
- Wu D, Smyth GK. 2012. Camera: a competitive gene set test accounting for
  inter-gene correlation. *Nucleic Acids Research* 40:e133.
  https://doi.org/10.1093/nar/gks461
