# Codex Context: phage_uv_ecology_analysis

This file is the first stop for future Codex sessions. It records the stable
paths, decisions, and next steps needed to resume without re-reading the full
repositories or chat history.

## Repositories And Paths

- Analysis repository: `/mnt/aiongpfs/users/snarayanasamy/repositories/phage_uv_ecology_analysis`
- User-facing alias: `/home/users/snarayanasamy/repositories/phage_uv_ecology_analysis`
- Multiomics pipeline repository: `/mnt/aiongpfs/users/snarayanasamy/repositories/multiomics_pipeline`
- HPC project directory: `/scratch/users/snarayanasamy/phage_uv_treatment`
- Metadata directory: `/scratch/users/snarayanasamy/phage_uv_treatment/metadata`
- Output root to use for pipeline results: `/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569`
- Temporary directory to use for pipeline work: `/scratch/users/snarayanasamy/phage_uv_treatment/tmp`
- ENA staged reads directory: `/scratch/users/snarayanasamy/phage_uv_treatment/staged_reads`
- Shared reusable reference root: `/mnt/isilon/projects/bioinformatics_platform/projects/shared_references/multiomics_pipeline`
- Implementation history: `CHANGELOG.md`

## Current State

- ENA study: `PRJEB79569`
- Local desktop table cache:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569`
- Generated sample sheet:
  `/scratch/users/snarayanasamy/phage_uv_treatment/metadata/PRJEB79569_multiomics_samples.tsv`
- Sample counts in the generated sheet: 12 MG rows and 23 MT rows.
- The optional curated metadata file
  `/scratch/users/snarayanasamy/phage_uv_treatment/metadata/sample_metadata.tsv`
  was not present when the sample sheet was generated, so condition, phase,
  cycle, and analysis group columns are empty.
- Amplicon runs were skipped with `--require-library-strategy WGS`.
- `snakemake_env` was created with latest available Snakemake from conda:
  Snakemake `9.20.0`.
- Important pending compatibility issue: Snakemake 9 no longer uses the old
  Snakemake 7-style `--cluster-config` plus `--cluster "sbatch ..."` launcher
  interface by default. The current launchers were initially written in that
  older style and must be adapted to Snakemake 9 Slurm execution before real
  submission.

## Cluster Table Import On 2026-07-19

- Desktop branch for downstream import/analysis work:
  `feature/prjeb79569-cluster-analysis-ingest`.
- Iris source root inspected:
  `/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569`.
- Local destination used for table cache:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569`.
- A broad CSV/TSV-only `rsync` was started and then intentionally stopped when
  it reached very large intermediate matrix tables such as CONCOCT/SemiBin
  `data.csv` files. No non-table files were present after the interrupt, and no
  hidden rsync partials remained.
- Local table files present after the broad partial fetch: 1,058 files, mostly
  Bakta annotation tables (`annotation/`) plus 14 binning tables.
- Targeted compact community UV-response tables were fetched and checksummed in
  `manifests/data_manifest.tsv`:
  - `community_uv_response/uv_signature_hits.tsv`
  - `community_uv_response/uv_signature_entity_summary.tsv`
  - `community_uv_response/uv_signature_mag_summary.tsv`
  - `community_uv_response/instrain_profile_manifest.tsv`
  - `community_uv_response/variant_analysis/mags_votu_metagenomic_bams.tsv`
  - `community_uv_response/variant_analysis/variant_analysis_input_audit.tsv`
- The UV signature summaries are ready for local downstream figure work. The
  fetched inStrain manifest marks 12 sample profiles as `ready`, but no
  `inStrain compare` output table was found under `community_uv_response`.
- Caveat before interpreting variant data: the fetched BAM manifest reports
  `bam_exists=true` and `bai_exists=false` for the quantification BAM paths,
  while the variant input audit reports 12 indexed BAMs in the audited input
  set. Resolve this path/index convention on Iris before running or trusting
  `inStrain compare`.

Open decision before the next fetch:

- Either continue a broad all-CSV/TSV sync, accepting multi-GB intermediate
  tables such as CoverM full outputs, vClust ANI, geNomad feature/gene tables,
  and SemiBin matrices.
- Or switch to a curated manuscript-table sync that fetches summary tables,
  manifests, quantification summaries, quality/taxonomy outputs, phage-host
  link tables, and final UV/inStrain summaries while excluding raw intermediate
  matrices.

Resolution: use the curated manuscript/poster-replication table sync first.

Curated fetch contract:

- Manifest:
  `manifests/cluster_curated_table_manifest.tsv`
- Fetch script:
  `scripts/fetch_curated_cluster_tables.sh`
- Default local data root:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569`
- Default Iris alias:
  `iris-cluster`

Curated tranche fetched successfully on 2026-07-19:

- dRep tables:
  `Widb.csv`, `genomeInfo.csv`, `Cdb.csv`, `Bdb.csv`, `Ndb.csv`, `Sdb.csv`
- MAG/vOTU read-count matrices:
  `quantification/mags_votu/coverage/metagenomics/coverm/output-Read_Count.tsv`
  and
  `quantification/mags_votu/coverage/metatranscriptomics/coverm/output-Read_Count.tsv`
- vOTU catalogue tables:
  `viromics/votu_clustering/cluster_summary.tsv`,
  `viromics/votu_clustering/clusters.tsv`,
  `viromics/annotation/PRJEB79569_vOTUs/vclust_catalogue/checkv/quality_summary.tsv`,
  `viromics/annotation/PRJEB79569_vOTUs/vclust_catalogue/checkv/complete_genomes.tsv`,
  `viromics/annotation/PRJEB79569_vOTUs/vclust_catalogue/cenotetaker3/output/output_virus_summary.tsv`,
  and
  `viromics/annotation/PRJEB79569_vOTUs/vclust_catalogue/cenotetaker3/output/output_prune_summary.tsv`.

Curated validation notes:

- No hidden rsync partial files remained after the curated fetch.
- Every `fetch_now=yes` entry in
  `manifests/cluster_curated_table_manifest.tsv` exists locally.
- `bash -n scripts/fetch_curated_cluster_tables.sh` passed.
- `bash scripts/validate_manifests.sh` passed.
- Large deferred tables remain intentionally unfetched:
  vContact3 `final_assignments.csv` and NeoRdRp `output.tsv`.
- Missing replication inputs from the current Iris tree:
  CRISPR/SpacePHARER host-phage link tables, legacy biofilm summaries, and
  legacy DE summary tables. Rebuild these from canonical pipeline outputs or
  point Codex to the separate host-phage pipeline output if it lives elsewhere.

Update on 2026-07-21:

- Iris rejected SSH command sessions with a general maintenance banner, so live
  verification/fetching of additional tables is temporarily blocked.
- Gene-level BED-guided quantification is likely present on Iris based on the
  previous remote listing under
  `quantification/mags_votu/gene_coverage/metatranscriptomics/*.tsv`, but those
  large per-run tables were not part of the first curated local fetch.
- Queued GitHub issue:
  https://github.com/shaman-narayanasamy/phage_uv_ecology_analysis/issues/19
- Once Iris returns, fetch or compact:
  `community_uv_response/uv_signature_gene_coverage_run_level.tsv`,
  `community_uv_response/uv_signature_gene_coverage_sample_summary.tsv`, and the
  all-gene MT expression table needed to reproduce legacy DE/expression logic.

Host-phage linking is required before the full biological picture is complete.
Use `docs/host_phage_linking_integration.md` as the integration contract for
`https://github.com/shaman-narayanasamy/host_phage_linking`. The minimum
required staged output is a manifest-backed MAG/rMAG-to-vOTU/phage edge table
plus CRISPR-Cas host summaries.

For future HPC-side Codex sessions, use
`docs/hpc_job_agent_protocol.md`. Agents must not burn context with tight Slurm
polling loops; they should use sentinels, logs, expected-output checks, GitHub
issues/PR comments, and explicit failure debugging.

## Decisions

- Keep project-specific configs and launchers in this analysis repository, not
  in the pipeline repository.
- Use the multiomics pipeline repository as the workflow source.
- Replace Trimmomatic with `fastp` for preprocessing, while preserving the
  existing downstream output contract:
  - `{sample}/{sample}_R1.processed.fastq.gz`
  - `{sample}/{sample}_R2.processed.fastq.gz`
  - `{sample}/{sample}_SE.processed.fastq.gz`
- Use `fastp` HTML and JSON reports per sample.
- Run preprocessing in this order:
  1. metagenomics preprocessing
  2. metatranscriptomics preprocessing after reference setup is verified
- Use a conda environment named `snakemake_env` for the Snakemake driver. If it
  is absent, create it with conda.
- Use Snakemake-managed per-rule conda environments under
  `/work/projects/bioinformatics_platform/cache/conda`.
- Reusable references should live under
  `/mnt/isilon/projects/bioinformatics_platform/projects/shared_references/multiomics_pipeline`
  to avoid duplication across projects.

## Actual Analysis Plan

1. Update the multiomics pipeline trimming implementation:
   - add `envs/fastp_env.yml`
   - replace MG and MT Trimmomatic rules with `fastp` rules
   - keep the same processed FASTQ filenames
   - emit per-sample fastp HTML/JSON reports
   - status: implemented
2. Add project-specific orchestration files in this repo:
   - `config/PRJEB79569_ulhpc_config.yml`
   - `config/ulhpc_cluster_config.yml`
   - `launchers/sbatch_mg_preprocessing.sh`
   - `launchers/sbatch_mt_preprocessing.sh`
   - status: implemented, but launchers need Snakemake 9 Slurm executor update
3. Configure ULHPC execution:
   - partition: `batch`
   - qos: `normal`
   - account: `michael.heneka`
   - conservative initial Snakemake parallelism: 32 jobs
   - Snakemake driver env: `snakemake_env`
4. Configure ENA staging:
   - `data_source.mode: ena_stage`
   - `data_source.stage_dir: /scratch/users/snarayanasamy/phage_uv_treatment/staged_reads`
   - `data_source.keep_staged: false`
5. Prepare MT references before launching MT:
   - SortMeRNA rRNA FASTAs under the shared reference root
   - human mRNA FASTA under the shared reference root
   - human genome FASTA can reuse:
     `/work/projects/bioinformatics_platform/ref/ensembl/Homo_sapiens/Homo_sapiens.GRCh38.dna.primary_assembly.fa`
6. Run dry-runs before actual submission:
   - MG preprocessing dry-run
   - MT preprocessing dry-run only after reference paths exist
   - status: pending; blocked until launchers are updated for Snakemake 9
7. Launch MG preprocessing first, monitor logs and outputs, then proceed to MT.
   - status: pending

## Resume Notes From Interrupted Implementation

- Fastp replacement has been applied in the pipeline repo:
  - `envs/fastp_env.yml` added
  - MG trimming rule now uses `fastp`
  - MT trimming rule now uses `fastp`
  - downstream processed FASTQ filenames are preserved
  - fastp HTML/JSON report outputs are added
- Project orchestration files have been added:
  - `config/PRJEB79569_ulhpc_config.yml`
  - `config/ulhpc_cluster_config.yml`
  - `launchers/sbatch_mg_preprocessing.sh`
  - `launchers/sbatch_mt_preprocessing.sh`
  - `CHANGELOG.md`
- Launchers were made executable.
- `bash -n` passed for both launchers.
- YAML validation was not completed in the original `codex_env` because PyYAML
  was missing there.
- `snakemake_env` creation completed with Snakemake `9.20.0`.
- Before continuing, inspect Snakemake 9 Slurm support. Likely next step:
  install/use `snakemake-executor-plugin-slurm` and replace old cluster flags
  in the project launchers with Snakemake 9 executor/profile options.
- Do not submit jobs until the MG dry-run passes with the updated Snakemake 9
  launcher.

## Known Repo State

- Analysis repo currently has a modified `README.md` from metadata provenance
  documentation.
- Multiomics pipeline repo is on `feature/ena-read-staging` and has local state
  from earlier work:
  - modified `scripts/ena/resolve_ena_study.py`
  - untracked `metadata/`
  - untracked `scripts/ena/__pycache__/`
- Do not clean or revert these unless the user explicitly asks.

## Useful Commands

Create the Snakemake environment if absent:

```sh
conda create -n snakemake_env -c conda-forge -c bioconda snakemake mamba pandas pyyaml
```

Activate it:

```sh
conda activate snakemake_env
```

Check the installed Snakemake version:

```sh
conda run -n snakemake_env snakemake --version
```

Generate the current sample sheet:

```sh
python /mnt/aiongpfs/users/snarayanasamy/repositories/multiomics_pipeline/scripts/ena/resolve_ena_study.py PRJEB79569 /scratch/users/snarayanasamy/phage_uv_treatment/metadata/PRJEB79569_multiomics_samples.tsv --metadata /scratch/users/snarayanasamy/phage_uv_treatment/metadata/sample_metadata.tsv --require-library-strategy WGS
```

Check sample counts:

```sh
awk -F '\t' 'NR==1{for(i=1;i<=NF;i++) h[$i]=i; next} $h["MG_R1"]!=""{mg++} $h["MT_R1"]!=""{mt++} END{print "MG", mg+0; print "MT", mt+0}' /scratch/users/snarayanasamy/phage_uv_treatment/metadata/PRJEB79569_multiomics_samples.tsv
```
