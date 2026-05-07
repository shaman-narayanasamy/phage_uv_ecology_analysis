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
