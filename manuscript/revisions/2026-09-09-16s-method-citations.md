# Returned 16S method citations for v2

Source-verified references for the tools actually used in Susana's returned
workflow. These changes add attribution, not new analysis settings or versions.
Native Google Docs suggestions and live readback determine insertion status.

## Cited Methods paragraph

For the cDNA-derived 16S amplicon analysis, anchored 515F and 907R primers were removed with cutadapt 5.2 (Martin, 2011), discarding pairs lacking either primer. Primer-free reads were subsampled to 150,000 pairs per sample with a fixed seed before denoising. DADA2 1.34.0 (Callahan et al., 2016) in R 4.4.3 was run with forward and reverse truncation lengths of 279 and 200 bases, maximum expected errors of 2 per mate, truncation quality 2, and a minimum paired-read overlap of 20 bases. Reads were inferred without pooling, with an error-learning budget of 50 million bases and seed 20260901, followed by consensus chimera removal. Taxonomy was assigned against SILVA 138.2 (Quast et al., 2013) with minimum bootstrap support of 80. Counts, taxonomy and sample metadata were assembled with phyloseq 1.50.0 (McMurdie and Holmes, 2013). This analysis used subsampled reads, not a full-depth reprocessing of the deposited libraries.

## References

Callahan BJ, McMurdie PJ, Rosen MJ, Han AW, Johnson AJA, Holmes SP. 2016. DADA2: High-resolution sample inference from Illumina amplicon data. Nature Methods 13:581-583. https://doi.org/10.1038/nmeth.3869

Martin M. 2011. Cutadapt removes adapter sequences from high-throughput sequencing reads. EMBnet.journal 17:10-12. https://doi.org/10.14806/ej.17.1.200

Quast C, Pruesse E, Yilmaz P, Gerken J, Schweer T, Yarza P, Peplies J, Glöckner FO. 2013. The SILVA ribosomal RNA gene database project: improved data processing and web-based tools. Nucleic Acids Research 41:D590-D596. https://doi.org/10.1093/nar/gks1219

McMurdie PJ, Holmes S. 2013. phyloseq: An R Package for Reproducible Interactive Analysis and Graphics of Microbiome Census Data. PLOS ONE 8:e61217. https://doi.org/10.1371/journal.pone.0061217

## Verification sources

- DADA2 publisher: https://www.nature.com/articles/nmeth.3869
- Cutadapt publisher: https://doi.org/10.14806/ej.17.1.200
- SILVA original article: https://pmc.ncbi.nlm.nih.gov/articles/PMC3531112/
- phyloseq publisher: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0061217
