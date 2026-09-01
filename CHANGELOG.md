# Changelog

## Unreleased

- Added the author-selected Figure 1 describing microbial and phage community
  structure across the six aligned cycle-phase observations, with verified
  provenance, exploratory community statistics, and reproducibility tests.
- Reallocated the main story to community, global transcriptome, functional and
  organism-resolved structure, recurrence, and population genomics; detailed
  abundance testing is Supplementary Figure S9 and delegated 16S has no
  reserved figure number.
- Reconstructed the original poster's condition-only MAG community analysis
  and added phase/cycle-adjusted DESeq2, matched CLR, exact sign-flip, and
  paired restricted-permutation analyses for both 348 MAGs and 616
  high-quality vOTUs. The poster MAG null was reproduced; no abundance signal
  was robust across the adjusted, matched, and global analyses.
- Completed GitHub #22 with a transcriptome-wide edgeR quasi-likelihood
  workflow: 23 technical runs collapse to 12 physical samples, the full gene
  universe enters filtering and multiplicity correction, and outputs include
  complete coefficient tables, Bakta annotation matches, model diagnostics,
  compact QC figures, deterministic summaries, and an experimental-unit
  caveat. GitHub #23 is now the next analysis task.
- Quarantined all earlier SOS-, UV-, DNA-repair-, stress-, RNA:DNA-, and
  selected-module expression checks from manuscript inference; they are not
  null-result evidence or a feature-selection substrate for the global model.
- Documented the HPC environment lifecycle and the 2026-08-04 scratch inode
  cleanup; added the checksummed Isilon environment-specification archive to
  the data manifest.
- Added validation that rejects project-scratch Conda prefixes and confirms the
  shared Snakemake Conda prefix. Normal launches now honor Snakemake `temp()`
  cleanup instead of forcing `--notemp`.
- Reframed inStrain output as coverage-qualified descriptive population
  genomics only, retired the treatment/SNV inferential figure, and explicitly
  prohibited DNA-damage or mutagenesis interpretation.
- Added a qualitative pairwise population-genomic landscape with effect-neutral
  QC criteria and no statistical treatment comparison.
- Added an abundance-corrected longitudinal DNA-damage/SOS analysis with exact
  phase-blocked cycle tests, a continuous MAG response heatmap, scoped SNV
  sensitivity tests, and an explicit experimental-unit audit.
- Added a 60-configuration trajectory-cluster stability audit; no configuration
  passed the predeclared stability criteria, so cluster outputs are retained as
  diagnostics and excluded from biological interpretation.
- Added an explicitly exploratory edgeR sensitivity analysis with technical runs
  collapsed; condition-by-cycle effects were null after correction.
- Added `docs/temporal_analysis_rigor.md` with predefined comparison families,
  raw and BH-adjusted results, inference limits, and honest nulls.
- Added a manuscript-wide visual grammar with fixed condition, taxonomy,
  viral-realm, and UV-response mappings.
- Added reproducible builders for seven unallocated candidate figures covering
  taxonomy, host-phage links, inStrain context, UV-response potential, UV
  transcription, and SOS-response markers.
- Staged the canonical CAT/BAT GTDB lineage table and corrected manifest entries
  for taxonomy, metatranscriptomic counts, and completed scoped inStrain output.
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
