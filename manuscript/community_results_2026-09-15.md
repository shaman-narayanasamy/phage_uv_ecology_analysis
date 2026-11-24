# Community change is shared across molecular profiles while population contributions differ

Review draft for the first Results section. This revision is prepared locally;
it has not replaced the live Google Doc. Figure and table numbering will follow
the manuscript's consolidated supplementary inventory. The named references
below identify the exact accompanying artifacts without renumbering existing figures.

## Results

We aimed to resolve how the membrane community changed across repeated cleaning cycles, and whether these changes were shared across the amplicon, metagenomic and metatranscriptomic profiles. Genome reconstruction yielded 348 dereplicated metagenome-assembled genomes (MAGs), alongside 634 high-quality viral operational taxonomic units (vOTUs), including 103 assigned to Riboviria. The cDNA-derived 16S dataset comprised 2,700 amplicon sequence variants across the same 12 samples. Bacteroidota, Chloroflexota and Planctomycetota accounted for 17.4%, 15.2% and 9.9% of MAG-mapped DNA reads, respectively. The leading MAGs were assigned to CAJATL01 sp903944895, SHND01 sp004295045 and Propionicimonas sp023458095, contributing 6.5%, 4.0% and 2.3%, respectively. Of the 348 MAGs, 108 lacked a genus assignment and 211 lacked a species assignment, together representing 26.7% and 53.1% of MAG-mapped reads at the respective ranks. Genome resolution therefore captured a substantial component of the community beyond its named members (Figure 2; community contribution table).

The three molecular profiles followed a shared pattern of community change. We compared the Bray–Curtis dissimilarities between matched samples, obtaining Spearman correlations of 0.82 for 16S versus metagenomics, 0.80 for metagenomics versus metatranscriptomics, and 0.94 for 16S versus metatranscriptomics (community comparison, panel A). This agreement extended to successive cleaning cycles. Turnover between cycles 2 and 3 was lower than between cycles 1 and 2 in all four condition-by-phase trajectories for both 16S and metatranscriptomics, and in three of four trajectories for metagenomics. The remaining trajectory, the initial fraction under treatment, changed from 0.467 to 0.485 (panel B). The reduction in successive-cycle turnover was therefore shared across molecular profiles, rather than confined to the amplicon data.

The populations contributing to these profiles were nevertheless different. Bacteroidota dominated both the 16S and metagenomic profiles, accounting for 27.4% and 17.4% of their respective reads. Pseudomonadota contributed 18.9% of the 16S profile and 20.7% of MAG-assigned transcripts, compared with 7.4% of MAG-mapped DNA reads. Conversely, Chloroflexota accounted for 15.2% of MAG-mapped DNA reads but 5.4% of MAG-assigned transcripts. These contrasts became more prominent at genome resolution. An Acidovorax MAG (TBF1/1) and an Aliarcobacter MAG (TBF3/22) contributed 10.1% and 7.0% of MAG-assigned transcripts, compared with 1.1% and 1.2% of MAG-mapped DNA reads, respectively. In the opposite direction, SHND01 sp004295045 (TBF2/85) contributed 4.0% of MAG-mapped DNA reads but 0.036% of MAG-assigned transcripts (panel C; community contribution table). Thus, the shared community trajectory contained populations with markedly different genomic and transcriptional contributions, providing the organism-level context for the functional responses examined below.

Against this community-wide pattern, abundance models identified a restricted set of treatment-associated populations. The additive model adjusting for phase and cycle identified one MAG assigned to Bacteriovoracaceae with lower abundance under treatment, and no vOTUs at a false-discovery rate below 0.05. The joint condition-by-cycle interaction test identified a different MAG and four vOTUs. These models selected two distinct MAGs and four vOTUs whose abundance patterns were associated with treatment or its interaction with cleaning cycle (Figure 3).

## Figure caption

**Community comparison:** Matched amplicon, metagenomic and metatranscriptomic profiles across cleaning cycles. **A**, Pairwise Bray–Curtis dissimilarities for the same 12 samples, calculated separately from relative ASV counts (16S), MAG-mapped metagenomic counts (MG) and MAG-assigned transcript counts (MT). Each point represents one of 66 sample pairs. The first and second assays in each facet label correspond to the horizontal and vertical axes; rho denotes Spearman correlation. **B**, Consecutive-cycle Bray–Curtis dissimilarities within each condition and sampling phase. Colours identify Control and Treatment; symbols and line types identify Initial and Backflush. **C**, Mean MG and MT read shares for 12 MAGs selected by the larger of their two mean shares. Open circles represent MG and filled circles MT; connecting segments pair measurements from the same MAG. Taxonomic colours match Figure 2. Labels combine the deepest available genus, family or order assignment with a shortened MAG identifier. Means give equal weight to the 12 samples. Full identifiers, all 348 MAGs and the panel source data are provided in the community contribution table.

## Table caption

**Community contribution table:** Genomic and transcriptional contributions of the 348 MAGs. Rows contain the full MAG identifier, domain-to-species assignments, mean within-assay MG and MT read shares, their ratio, the fixed taxonomic colour and inclusion in the 12-MAG display. A blank taxonomic field denotes no assignment at that rank. The ratio is MT mean read share divided by MG mean read share. Mean shares are calculated over the same 12 samples. Separate source tables report sample-pair dissimilarities, cross-assay correlations and consecutive-cycle turnover.

## Methods

Community profiles were constructed for the same 12 condition-by-phase-by-cycle samples. Metagenomic counts were summed across contigs assigned to each MAG. Metatranscriptomic counts were summed across all genes assigned to each MAG before differential-expression filtering. Counts were divided by the MAG-assigned total within each sample and assay. The ASV profile used the collaborator's unrarefied counts divided by the sample total. Non-MAG transcript assignments were recorded separately; MAG-assigned reads represented 78.0–93.6% of all gene-assigned transcript reads. Mean contributions were calculated with equal weight for each sample.

Bray–Curtis dissimilarities were calculated from the relative profiles. Cross-assay agreement was summarised using Spearman correlation of the corresponding 66 unique sample-pair dissimilarities. Consecutive-cycle dissimilarities were calculated within each condition and sampling phase. The displayed MAGs were selected by ranking the larger of each MAG's mean MG and mean MT read shares, retaining the first 12; the complete 348-MAG table was retained. MAG taxonomy followed the existing GTDB-derived assignments and ASV taxonomy retained the collaborator's SILVA assignments.

## Limitations

The community comparison measures relative sequencing contributions rather than absolute population sizes. Metagenomic read shares depend on genome representation and mapping, while metatranscriptomic read shares additionally reflect gene content, transcript abundance and library preparation. Their ratio is not a per-cell transcription rate. The 16S assay was generated from cDNA and therefore represents a ribosomal RNA-derived profile rather than a DNA-based cell census. Concordance with metatranscriptomics should be interpreted in this assay context.

MAG-based profiles condition on the reconstructed catalogue and do not represent all organisms or transcripts in the samples. SILVA and GTDB differ in taxonomic assignments and rank boundaries, and no family-level equivalence between the two databases was imposed. Genome-based placeholder assignments also do not establish that a population has been cultured or formally described.

The 66 sample-pair distances share their underlying 12 samples and are not independent observations. Their correlations are descriptive summaries, without inferential p values. There was one membrane per condition, preventing separation of treatment from membrane identity. Three cycles describe the observed trajectories but do not establish long-term stability. Lower successive-cycle dissimilarity is not evidence that Control and Treatment converged towards the same community.

## Internal integration checklist

- Keep all limitations above in the Limitations section; do not distribute them through Results.
- Keep read-share definitions and computational details in Methods and captions.
- The catalogue has 634 vOTUs, whereas archived abundance modelling used the 616-member Cenote-linked set and retained 560 after filtering. Audit the 18-vOTU eligibility difference before final submission; it is an internal analysis task, not an explanation to bury in Limitations.
- Riboviria assignment alone does not prove a bacterial host. Retain the realm wording, not “103 RNA phages”.
- Live Google Doc updates remain pending after a browser security block in the preceding turn. Do not work around that block through another browser surface or API.
