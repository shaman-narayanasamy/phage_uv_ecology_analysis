# Handoff: PRJEB79569 16S collaborator package

Date: 2026-08-20

This is an expert-to-expert handoff to the microbiome collaborator and their
agent. The 16S workstream is **delegated, not blocked**. The colleague owns the
processing and statistical choices; this package fixes the input identity,
experimental boundary, and return contract so they do not have to rediscover
the dataset.

## Verified substrate

The processed ASV/OTU, BIOM, QIIME2, DADA2, and phyloseq artifacts are not in
the local project tree or the canonical Isilon archive. The correct substrate
is therefore the public ENA amplicon data, now resolved unambiguously:

- project: `PRJEB79569` / `ERP163720`;
- 12 physical-sample amplicon runs and 24 paired FASTQ files;
- 17,053,094 ENA reads, corresponding to 8,526,547 read pairs;
- 5,132,981,294 bases;
- 2,783,761,569 compressed FASTQ bytes (about 2.78 GB decimal);
- Illumina MiSeq, paired 2 x 301 bp, `AMPLICON` / `PCR`;
- ENA metadata first public and last updated on 2026-02-02.

The committed input contracts are:

- `metadata/sample_metadata.tsv`: canonical biological design and all assay
  accessions;
- `metadata/16s_ena_run_manifest.tsv`: one row per amplicon run, in canonical
  sample order;
- `metadata/16s_ena_fastq_manifest.tsv`: exact HTTPS URL, filename, byte count,
  and ENA MD5 for every R1/R2 file;
- `scripts/build_16s_ena_manifests.R`: reproducibly rebuild and validate both
  manifests from the ENA Portal report;
- `scripts/fetch_16s_ena_reads.sh`: resumable, checksum-enforcing downloader to
  an explicitly chosen data directory.

The raw public reads are deliberately not duplicated in Git. From the repository
root, fetch them to managed project storage with:

```sh
bash scripts/fetch_16s_ena_reads.sh \
  metadata/16s_ena_fastq_manifest.tsv \
  /path/to/managed/16s_raw_reads
```

## Biological and library provenance

The original study states that an RNA aliquot was reverse-transcribed to cDNA
with SuperScript III One-Step RT-PCR and then used for 16S amplicon sequencing.
These data therefore represent the cDNA-derived, putatively active community,
not a total-DNA 16S community. ENA labels `library_source` as `METAGENOMIC`;
retain that archival field in provenance, but use the original methods as the
authority on biological material.

The reported primers are:

- 515F: `GTGYCAGCMGCCGCGGTAA`;
- 907R: `CCCCGYCAATTCMTTTRAGT`;
- expected amplicon: approximately 550 bp.

The original methods report no amplification in the negative control, but no
negative-control sequencing run is present among the 12 deposited amplicon runs.
Do not infer or manufacture a sequenced control during import or contamination
assessment.

The deposited FASTQs retain these primers. A full-file QA scan of representative
run `ERR13800671`, after both files matched their ENA MD5s, found exact
degenerate-primer prefixes in 378,152/396,905 R1 reads (95.28%) and
372,915/396,905 R2 reads (93.96%). Primer removal is therefore required before
DADA2; inspect quality and orientation and choose an appropriate paired
primer-removal/truncation strategy. The original in-house Perl trimming script
need not be recreated.

The original analysis used QIIME2 v2022.11, DADA2 denoising/chimera removal,
rarefaction to 23,800, q2-feature-classifier `classify-sklearn`, and SILVA 138.
These are provenance, not mandatory modern choices. Report and justify the exact
software, filtering parameters, taxonomy database/classifier, and region training
used in the new analysis.

Original article and methods:

- <https://doi.org/10.1016/j.ceja.2025.100796>
- <https://www.sciencedirect.com/science/article/pii/S2666821125000936>

## Experimental boundary

The 12 samples form one observation in each condition x phase x cycle cell:

- condition: control membrane or phage-UV-treated membrane;
- phase: initial or backflush;
- cycle: 1, 2, or 3.

There is one membrane per condition, so condition is confounded with membrane
identity. Treat this as a longitudinal description of these two membrane systems,
not a population-level causal treatment experiment. Do not collapse initial and
backflush phases without first examining their structure. Differential-abundance
testing is optional and, if used, must be framed as system-specific/exploratory;
no particular model or package is imposed by this handoff.

Start with the whole community. The genera emphasized by the original engineering
paper may be reported secondarily, but should not determine filtering, feature
selection, or the new ecological story.

## EnSE314 guide

Use <https://github.com/shaman-narayanasamy/EnSE314> at commit
`e7796c2723eb67e9a9ca2a5c24093b777406640a` as a guide, especially:

- `illumina_data_processing.qmd` for the DADA2-to-phyloseq pattern;
- `data_analysis.qmd` for downstream ecological analysis patterns.

This teaching repository is a reference implementation, not project source of
truth. Adapt it to the paired 515F/907R data, current package/database versions,
the design above, and the collaborator's own expert judgment.

## Requested return package

Please return a reproducible, checksum-addressed analysis containing:

- exact software, database, classifier, and parameter versions;
- per-sample read-retention and denoising/chimera QC;
- unrarefied ASV count table, taxonomy table, canonical sample metadata, and
  representative sequences;
- optional tree and serialized phyloseq object if used and defensible;
- whole-community composition, alpha-diversity, and beta-diversity results with
  the confounding boundary carried into every interpretation;
- any differential-abundance results clearly labeled as exploratory and kept on
  unrarefied counts;
- editable vector candidate figures following the repository visual grammar in
  `R/figure_style.R`, without assigning main/supplement figure numbers;
- a concise integration note distinguishing robust observations, fragile signals,
  and analyses that should not enter the manuscript.

Suggested managed output root:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/16s_analysis`

Keep code and compact provenance in this analysis repository; keep raw reads and
large generated objects in managed data storage and register them in the manifests.
The 16S results will be integrated later as community-ecology evidence. They do
not need to be forced into a phage-linkage or DNA-damage narrative.

## Suggested skills for agentic work

- `mattpocock-skills:diagnose` for import, primer-removal, or DADA2 failures;
- `spreadsheets:Spreadsheets` for compact QC and feature-table review;
- `mattpocock-skills:review` before merging the returned analysis;
- `mattpocock-skills:handoff` when returning results to the manuscript stream.
