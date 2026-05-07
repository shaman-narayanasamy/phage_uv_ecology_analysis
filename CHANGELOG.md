# Changelog

## Unreleased

- Added durable Codex context in `docs/codex_context.md` and linked it from
  the README.
- Generated ENA metadata for `PRJEB79569` under the HPC project metadata
  directory.
- Planned and began the preprocessing adaptation for ULHPC:
  - project-specific config and launchers live in this repository
  - Snakemake driver environment is `snakemake_env` with the latest available
    Snakemake from conda
  - per-rule conda environments use `/work/projects/bioinformatics_platform/cache/conda`
  - launch order is MG preprocessing first, then MT preprocessing
- Replaced the pipeline preprocessing trimmer from Trimmomatic to `fastp` while
  preserving existing downstream FASTQ output filenames.
- Created `snakemake_env` with latest available Snakemake from conda
  (`9.20.0` at creation time).
- Paused implementation before dry-runs because Snakemake 9 requires updating
  the launchers away from the old `--cluster-config`/`--cluster` interface.
