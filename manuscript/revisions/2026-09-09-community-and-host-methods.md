# Community and host-link additions for live v2 review

Status: prepared from executed code and current output tables; live insertion
and readback are recorded in the Google Docs handoff. This file is a revision
payload, not a second authoritative manuscript.

## Community-abundance Methods

Metagenomic read counts from the unified MAG/vOTU catalogue were summed across contigs within each of the 348 dereplicated MAGs. The viral abundance analysis retained 616 vOTUs classified as high-quality by CheckV and containing at least one viral gene. This set included nine vOTUs without a taxonomic assignment and therefore differed from the 607-vOTU set used for the taxonomic composition panels. Counts were matched to the 12 physical samples; MAGs and vOTUs were analysed separately.

Counts were rounded to integers and analysed with DESeq2 (Love et al., 2014). Features required at least 10 reads in at least three samples. We fitted a condition-only model to reproduce the original analysis and a second model adjusting for sampling phase and cleaning cycle. The latter design was ~ phase + cycle + condition, with cycle treated as a factor. The dispersion trend used a local fit. The treatment-minus-control Wald contrast used alpha = 0.05 with the package's default independent filtering and Benjamini-Hochberg adjustment. Reported test counts exclude features without a finite P value; no additional fold-change shrinkage was applied.

For descriptive sensitivity analysis, counts received a pseudocount of 0.5 and were transformed to centred natural-log ratios within each sample. Treatment-minus-control differences were calculated in the six matched phase-cycle cells. We enumerated all 64 sign patterns and compared the absolute mean difference with its sign-flipped values, adjusting across all 348 MAGs or 616 vOTUs separately. The smallest attainable two-sided P value was 0.03125. Community ordinations used Bray-Curtis distances between relative-abundance profiles and classical multidimensional scaling with an additive correction. A partial pseudo-F statistic for condition, conditional on phase and cycle, was evaluated under all 64 within-cell label-swap patterns. These calculations describe the observed samples: independent cell-wise swaps do not preserve whole-membrane trajectories and are not a valid randomisation test of the treatment. Neither these sensitivities nor the count models supply independent membrane replication or establish equivalence when no features pass correction.

## Host-phage Methods

Candidate CRISPR links were obtained from the completed host-phage workflow. PILER-CR (Edgar, 2007) and MinCED identified CRISPR arrays in the dereplicated MAGs; their outputs were supplied jointly to SpacePHARER easy-predict against the project viral sequence database (Zhang et al., 2021). The executed rule specified 12 threads and no additional search-threshold override. It ran prediction only when the PILER-CR output exceeded five lines and the MinCED output was non-empty. We retained the resulting predictions as candidate links, not experimental host-range assignments.

Prediction tables were consolidated and reduced to unique MAG-phage pairs. For duplicate pairs, the row with the largest hit count, then the largest score, supplied the displayed attributes; this ordering was a deduplication rule, not an additional significance test. Linked viral contigs were mapped through the cluster-membership table to current vOTU representatives and audited against CheckV quality, viral-gene content and taxonomic annotation. The network included all deduplicated links. Current complete-transcriptome MAG-level direction and support were overlaid for context, without preselecting hosts according to expression direction. No test of infection activity or association between CRISPR linkage and expression was performed.

## Host-phage Results

CRISPR-derived host-link predictions connected 80 MAGs to 85 viral contigs through 86 unique candidate pairs (Supplementary Figure S8). Forty-nine linked MAGs had supported gene-set signals in the current complete-transcriptome analysis, with both expression directions represented. Only 12 linked viral representatives had current catalogue annotations, and none passed the high-quality classified-vOTU filter used for the taxonomic profiles. The network therefore provides candidate host associations compatible with prior CRISPR exposure, but cannot connect the displayed viral community to active infections or explain the membrane-associated expression differences.

## Revised community-abundance Results paragraph

The abundance results depended on the analytical specification. The condition-only MAG model identified no features after false-discovery-rate correction; adjustment for phase and cycle identified one of 348 tested MAGs. For vOTUs, two of 529 features passed correction in the condition-only model and none of 560 did in the adjusted model. No MAG or vOTU passed correction in the matched centred-log-ratio sensitivity analysis (Supplementary Figure S9). The six matched cells and absence of independent membrane replication limit these comparisons. They neither establish community equivalence nor isolate a causal treatment effect.

## Corrected Supplementary Figure S9 legend

Supplementary Figure S9. Exploratory microbial and phage differential abundance. (A) Bray-Curtis principal-coordinate representations of relative-abundance profiles for the 348 MAGs and 616 high-quality vOTUs with viral genes. Lines connect cycles within each membrane and sampling phase; colour denotes membrane, shape denotes phase, and labels denote cycle. (B) Phase- and cycle-adjusted DESeq2 log2 fold-changes and -log10 adjusted P values. Highlighted features meet BH FDR < 0.05 and an absolute log2 fold-change of at least 1. The adjusted models identified one of 348 tested MAGs and none of 560 tested vOTUs. Condition-only results, matched CLR effects and exhaustive label-swap statistics are provided in the source tables, not additional panels. These repeated observations do not provide independent membrane replication; the comparisons neither establish community equivalence nor a causal treatment effect.

## Source evidence and citations

- `scripts/run_community_differential_abundance.qmd`: count filters, designs,
  Wald contrasts, local dispersion fit, CLR, sign flips and partial pseudo-F.
- `derived/community_differential_abundance/tables/analysis_summary.tsv`:
  condition-only/adjusted counts 337/348 MAGs and 529/560 vOTUs.
- `scripts/build_host_phage_network_figure.qmd` and its three source-table
  outputs: deduplication, catalogue join, complete-universe overlay and counts.
- Executed host-phage commit `604db81b73f2550bdea08e5eaa08f35186d21f53`, rules
  `spacepharer_genomes.smk`, `pilercr.smk`, `minced.smk`.
- Love MI, Huber W, Anders S. 2014. Moderated estimation of fold change and
  dispersion for RNA-seq data with DESeq2. Genome Biology 15:550.
  https://doi.org/10.1186/s13059-014-0550-8
- Zhang R, Mirdita M, Levy Karin E, Norroy C, Galiez C, Söding J. 2021.
  SpacePHARER: sensitive identification of phages from CRISPR spacers in
  prokaryotic hosts. Bioinformatics 37:3364–3366.
  https://doi.org/10.1093/bioinformatics/btab222
- Edgar RC. 2007. PILER-CR: Fast and accurate identification of CRISPR repeats.
  BMC Bioinformatics 8:18. https://doi.org/10.1186/1471-2105-8-18
- MinCED source: https://github.com/ctSkennerton/minced

Exact executed DESeq2, SpacePHARER, PILER-CR and MinCED versions are not
established by these files. An unpinned environment recipe or today's installed
package version must not be presented as the executed version. Preserve this
provenance limitation until an execution log or archived environment resolves it.
