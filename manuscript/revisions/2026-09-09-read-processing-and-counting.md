# Read processing and count construction: live v2 revision

Apply as native suggestions, replacing the previous combined coassembly/mapping
paragraph. Preserve all other Methods and author suggestions. The archived
execution audit covers all 35 sequencing runs, rather than extrapolating from
one representative log. Binning-source details are documented in the provenance
audit but will receive their own cited Methods paragraph.

## Revised paragraphs

Metagenomic and metatranscriptomic reads were processed with fastp 1.3.3 (Chen et al., 2018), with paired-end adapter detection enabled and a minimum retained read length of 36 bases. Ribosomal RNA reads were removed from the metatranscriptomic libraries with SortMeRNA (Kopylova et al., 2012), using the smr_v4.3_default_db.fasta reference. Paired and unpaired non-rRNA reads were retained as separate input streams.

Processed metagenomic and metatranscriptomic reads were coassembled separately for each physical sample with MEGAHIT (Li et al., 2015), including unpaired reads and metatranscriptomic contigs as additional inputs. Recovered bins were refined with MAGScoT (Rühlemann et al., 2022) and dereplicated across samples with dRep (Olm et al., 2017), using primary and secondary average-nucleotide-identity thresholds of 0.90 and 0.95, respectively. The resulting MAG representatives were combined with the representative vOTUs in a common sequence catalogue.

Metagenomic and metatranscriptomic reads were mapped separately to the unified catalogue with BWA-MEM (Li, 2013), using the -M option. Paired and unpaired alignments were merged and coordinate-sorted with SAMtools (Li et al., 2009). CoverM supplied metagenomic coverage and abundance summaries (Aroney et al., 2025). Metatranscriptomic gene counts were obtained with BEDTools coverage (Quinlan and Hall, 2010), using the common gene-coordinate BED file and each run's alignment BAM. The count of overlapping alignments, the seventh column of the headerless BED6-based output, supplied the expression matrix. Counting was unstranded and required at least one base of overlap; the recorded mapping and counting commands applied no additional mapping-quality threshold or secondary-alignment exclusion. These are alignment-overlap counts, not unique-fragment counts. This read-mapping catalogue was distinct from the MAG-only alignment inputs used for population-genomic comparisons.

## References

Chen S, Zhou Y, Chen Y, Gu J. 2018. fastp: an ultra-fast all-in-one FASTQ preprocessor. Bioinformatics 34:i884-i890. https://doi.org/10.1093/bioinformatics/bty560

Kopylova E, Noé L, Touzet H. 2012. SortMeRNA: fast and accurate filtering of ribosomal RNAs in metatranscriptomic data. Bioinformatics 28:3211-3217. https://doi.org/10.1093/bioinformatics/bts611

Li H, Handsaker B, Wysoker A, Fennell T, Ruan J, Homer N, Marth G, Abecasis G, Durbin R, 1000 Genome Project Data Processing Subgroup. 2009. The Sequence Alignment/Map format and SAMtools. Bioinformatics 25:2078-2079. https://doi.org/10.1093/bioinformatics/btp352

Quinlan AR, Hall IM. 2010. BEDTools: a flexible suite of utilities for comparing genomic features. Bioinformatics 26:841-842. https://doi.org/10.1093/bioinformatics/btq033

## Evidence and limits

- `derived/upstream_execution_audit_2026-09-09-v1/execution_audit.json`:
  35 fastp reports and 236 complete archived Snakemake metadata records.
  Each source is identified by its archive path and SHA256 hash.
- All 35 fastp reports state version 1.3.3 and the same explicit settings.
- All 23 paired and 23 unpaired SortMeRNA records use the named v4.3 reference.
  Environment declarations pin SortMeRNA 4.3.6, BWA 0.7.17 and SAMtools 1.9;
  these are declarations, not independently recovered runtime package records.
  Therefore the new prose does not assert those runtime versions.
- All 23 BEDTools records use `coverage -a BED -b BAM`, without `-s`, `-S`,
  `-f`, `-F`, `-split`, or upstream `samtools view -q/-F` filtering. Defaults
  are documented at https://bedtools.readthedocs.io/en/latest/content/tools/coverage.html .
  This describes the executed convention, not a strand-specific or unique-fragment
  quantification method. A read can overlap more than one feature; do not describe
  the library sums as unique molecules or unique sequenced fragments.
- The archived commands omit the later repository snapshot's `-sorted -g`
  options. Describe the archived command, not the current optimization.
- Parser: `scripts/run_full_transcriptome_edger.qmd`, explicit BED6 + four
  coverage-column schema and `read_count` aggregation. No analysis was rerun.
- Source papers checked against publisher, PMC or author-maintained records on
  2026-09-09. These additions are static until supported Zotero conversion.
