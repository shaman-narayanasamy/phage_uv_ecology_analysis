# Workflow provenance audit, 2026-09-07

This audit replaces the inaccurate independent-MG/MT model in workflow metro
versions 1-3. Version 10 is the current review candidate. No analysis was rerun.

## Repositories inspected

| Repository or branch | Evidence inspected | Role and boundary |
| --- | --- | --- |
| `multiomics_pipeline` | Executed-state commit `5f7dfe4c42ba65a8188589f437667a61285a5bea`: `rules/coassembly/megahit.smk`, `workflows/coassembly.smk`, `workflows/binning.smk`, `rules/binning/dereplication.smk`, `rules/quantification/bwa.smk`, `rules/quantification/quantify_genes.smk` | MG/MT processing, sample-specific coassembly, MAG recovery, across-sample dereplication, common-reference mapping and gene coverage. Current local HEAD is a different revision and was not substituted for the executed state. |
| `viromics_pipeline` | HPC checkout `/home/users/snarayanasamy/repositories/viromics_pipeline`, base `05189c3ad6d7ca8d6b968cd799b5a69b335c97b0`; identification, consolidation and vOTU workflows and clustering rules; archived output tree and Vclust log | Viral discovery across multiple assembly types, pooling across samples, representative vOTU construction. Checkout has tracked modifications and untracked clustering code; the base commit alone does not specify execution. |
| `host_phage_linking` | Recorded executed commit `604db81b73f2550bdea08e5eaa08f35186d21f53`, `workflows/crispr_links.smk`; existing execution provenance and network integration audit | Host CRISPR discovery and SpacePHARER candidate links. Optional identity/prediction branches are not asserted as executed. |
| `community_uv_response` | README, PRJEB79569 configuration template, HPC handoff; local HEAD `d677f8661ee320ed648481c2591fb61a1077cf1e` | MAG alignment and inStrain population-genomic context. Do not infer combined-catalogue BAMs were the inputs merely because they exist. Subset-first expression modules remain quarantined. |
| `membrane_cleaning` | Legacy README and `rules/dereplication/drep/collect_all_bins.smk`, HEAD `35b787e83a9e79cc0b1d626ed7c9aedcf6c8d70f`; original notebooks under `raw/membrane_cleaning_v2/` | Historical workflow/poster provenance. The legacy code explicitly distinguished all-sample collection from condition-specific collection. Current implementation belongs to successor repos. |
| `phage_uv_ecology_analysis` | Full-transcriptome notebook, analysis registry, upstream provenance, community and host-link docs | Full-universe modelling, post-model interpretation, community figures and downstream descriptive results. Gene counts come from the `quantification/mags_votu/gene_coverage/` stream. |
| Collaborator branch in `phage_uv_ecology_analysis` | `origin/feature/prjeb79569-16s-analysis`: protocol and entrypoint inventory; validated local return | Separate cDNA-amplicon stream: cutadapt, DADA2, SILVA, phyloseq/ecology. The EnSE314 repository is a methodological guide, not an executed PRJEB79569 pipeline. |

## Confirmed data flow

1. The executed MEGAHIT rule supplies paired MG and MT reads together and adds
   unpaired reads plus MT contigs with `-r`. Coassembly is per physical sample,
   not one assembly pooled over the full experiment. The archived coassembly
   directory contains the 12 canonical physical sample aliases.
2. Binning/refinement precedes cross-sample MAG dereplication. The dRep rule
   collects `{sample}/magscot_bins` for all samples into `bin_paths.txt`.
   The archived `binning/dereplication/log/cluster_arguments.json` records
   primary ANI 0.90 and secondary ANI 0.95. These are execution settings, not
   a claim that every downstream MAG has high completeness/low contamination.
3. Viral discovery also uses single-omics assemblies. Archived CI1 inputs
   include `coassembly_megahit`, `metagenomics_penguin`,
   `metatranscriptomics_megahit`, and `metatranscriptomics_penguin`.
   The consolidation code consumes geNomad, VirSorter2 and VirALM candidates,
   with DeepMicroClass candidates added for coassemblies. The original poster
   notebook independently records multiple assembly-origin labels.
4. Vclust pools each sample's consolidated sequences. The archived clustering
   log records Leiden clustering at ANI 0.95 and query coverage 0.85, followed
   by extraction of representative vOTUs. Do not substitute another backend
   merely because its rules are present in the repository.
5. Archived `catalogues/mags_votu.fasta` and `mags_votu.genes.bed` are the common
   sequence and gene-coordinate references. The BWA rule indexes a catalogue
   once and maps MG and MT reads through the same configured FASTA.
   Archived MG CoverM metadata explicitly names the `mags_votu` alignments and
   shared index; the MT alignment directory contains run-resolved BAMs.
6. CoverM yields abundance/coverage tables. BED-guided gene coverage supplies
   the transcriptome count stream, which the canonical downstream notebook
   aggregates from 23 runs to 12 physical samples before full-universe edgeR.
   This downstream count aggregation is distinct from any read combination
   during upstream sample-specific assembly.
7. Host-link and population-genomic branches retain their own input contracts.
   The 86 candidate host-phage links must not be attributed to the restricted
   set of 607 classified high-quality vOTUs. The five-MAG population-genomic
   results remain descriptive and coverage-qualified.

Archive root used for read-only checks:
`/mnt/isilon/projects/bioinformatics_platform/projects/shared_references/scratch_archives/snarayanasamy/phage_uv_treatment_20260726_full_output/output/PRJEB79569/`.

## Low-level execution audit, 2026-09-09

`manuscript/upstream_execution_audit.qmd` retrieves a bounded set of archived
records over SSH on the Iris access node. It changes no remote files and does
not run analysis. Current evidence:
`derived/upstream_execution_audit_2026-09-09-v2/execution_audit.json`,
1031737 bytes, SHA256 `1f8ce69eec14c4aba98fde4840017589c60e693097b6a68e510eb036a9f7d548`.
It contains 35 fastp summaries with source hashes and 260 complete Snakemake
records, each with its archive path, hash, inputs, recorded shell command and
environment declaration. No selected record is missing. This is broader than
the representative-file checks above, but not a complete workflow archive.

- All 12 MG and 23 MT fastp reports record version 1.3.3, minimum length 36
  and paired-end adapter detection. The source rules retain the historical
  filename `trimmomatic.smk`; that filename does not mean Trimmomatic ran.
- All 23 paired and 23 unpaired SortMeRNA records use
  `smr_v4.3_default_db.fasta`. Their environment declaration pins 4.3.6;
  it is not an independently recovered installed-package record. Do not
  substitute the eight reference files listed as current code defaults.
- All 12 binning inputs concatenate the DeepMicroClass prokaryote,
  prokaryotic-virus and plasmid sequence classes. Each sample's refinement
  table pools CONCOCT, MaxBin2, MetaBAT2, SemiBin2 single-sample, Vamb and
  SemiBin2 multisample assignments. This is six input streams from five tools,
  not six independent algorithms. All 12 refinements and the multisample
  SemiBin2 run have complete metadata. MetaBAT2, MaxBin2, SemiBin2 and Vamb
  commands use a 1500-base minimum contig setting; Vamb also uses
  `--minfasta 200000`. All 12 CONCOCT splitting commands use
  `cut_up_fasta.py -c 1000 -o 0 --merge_last`, followed by clustering with
  `-l 1500`. These are the executed settings, not an endorsement of their
  optimality. The earlier 236-record v1 is preserved.
- All 35 catalogue-mapping records use BWA-MEM `-M`, separately mapping
  paired/unpaired inputs and merging/sorting them with SAMtools. Recorded
  environment declarations pin BWA 0.7.17 and SAMtools 1.9; no independent
  runtime-version claim is made from those declarations alone.
- All 23 gene-coverage records use `bedtools coverage -a BED -b BAM`.
  The BED6-based count is column seven. It is an unstranded alignment-overlap
  count, not a strand-specific count or unique-fragment assignment. The
  recorded pipeline adds no MAPQ threshold or secondary-alignment exclusion.
  The documented default overlap threshold is one base. Read-to-multiple-gene
  assignment is possible; its observed extent and sensitivity have not been
  measured here. Do not equate summed gene counts with unique molecules.
- The archived BEDTools command omits the later code snapshot's `-sorted -g`.
  Execution metadata takes precedence for the manuscript. No count tables or
  fitted analyses were altered by this audit.

The live Methods extension is recorded in
`manuscript/revisions/2026-09-09-read-processing-and-counting.md`.
Four cited read-processing/counting references are integrated as native
suggestions. The subsequent `2026-09-09-genome-recovery.md` payload adds the
five binning-tool references, Cenote-Taker 3's published 2026 paper and the
coordinate-construction description. Readback `20260909T143027Z` verifies
these paragraphs and references separately, once each, in Normal text.

## Catalogue coordinate and dereplication audit, 2026-09-09

`manuscript/catalogue_coordinate_audit.qmd` is a read-only archive audit.
Current evidence: `derived/catalogue_coordinate_audit_2026-09-09-v3/coordinate_audit.json`,
5347 bytes, SHA256 `b946b4bd58620806045f17a0b10886236f64e98646431c74c07e5c41facb638a`.
All three checks pass. Seven archived source files have recorded byte counts
and SHA256 hashes, and the audit records the producing notebook's hash.

- The combined BED's row multiset exactly equals the MAG plus viral BED
  multisets. Ordering differs, so byte-concatenation is not the right check.
- All 766,445 viral records reconcile with the annotation/name-map sources
  using zero-based starts and prophage chunk offsets. 30,666 records require
  offsets. There are no missing, unexpected or unmapped records.
- The 1,734,193 combined rows contain 1,734,019 unique records and 174 exact
  duplicates. All 23 existing transcriptome run audits report removal of
  exactly 174 identical records. Position-aware feature IDs preserve repeated
  names at different coordinates; names alone must not be deduplicated.
- Three representative MAG genes match Bakta GFF start-minus-one conversion.
  This is explicitly not a full per-MAG GFF verification.
- Archived dRep arguments record completeness 75%, contamination 25%,
  primary/secondary ANI 0.90/0.95 and tertiary clustering. These permissive
  eligibility settings do not make every retained MAG high quality. Do not
  replace them with conventional 90/5 thresholds. The actual contamination
  distribution and interpretation sensitivity remain to evaluate.

The superseded v1 coordinate audit assumed byte-concatenation and omitted
chunk offsets. Its failed assumptions did not establish source corruption;
v2/v3 use the correct multiset and chunk-aware checks. All versions remain.
`tests/test_catalogue_coordinate_audit.py` verifies the current artifact and
agreement with the existing 23-run count audit. No counts or models were
changed. Ambiguous/overlapping alignment sensitivity remains unresolved.

## Remaining provenance limitation

The viromics dirty execution state is not yet a single archived, versioned
commit. Workflow topology is supported by both code and archived outputs,
but a full package/version reproducibility claim requires preserving that
execution diff and the untracked clustering sources. No checkout was cleaned,
reset, committed, or otherwise modified during this audit.
