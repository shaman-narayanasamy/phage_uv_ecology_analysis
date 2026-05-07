# Phage-UV membrane biofilm manuscript workspace

This workspace organizes the manuscript-grade analysis for phage-UV ecology and strain-level adaptation in anaerobic membrane biofilms.

Canonical public dataset:

- ENA study accession: `PRJEB79569`
- ENA secondary study accession: `ERP163720`

The current implementation creates the reproducibility layer first:

- `metadata/sample_metadata.tsv`: ENA-derived physical sample map with `condition`, `phase`, `cycle`, and `analysis_group`.
- `resources/uv_resistance_signatures.tsv`: curated UV/DNA-damage resistance signature table.
- `manifests/data_manifest.tsv`: data staging checklist for ENA, HPC/Isilon, local downstream, MGnify, and manuscript artifacts.
- `manifests/code_manifest.tsv`: code provenance checklist for existing repositories, local QMDs, and new wrapper scripts.
- `analysis/phage_uv_ecology.qmd`: downstream analysis scaffold that reads manifest-configured inputs.
- `manuscript/manuscript_skeleton.md`: venue-neutral manuscript skeleton and claim hierarchy.

MGnify checks use MGnifyR through `scripts/check_mgnify_prjeb79569.R` and the wrapper `scripts/check_mgnify_prjeb79569.sh`.

Heavy primary workflows should run on HPC scratch. Durable derived outputs should be staged on Isilon and then consumed locally through the manifest paths.

## Codex handoff

Future Codex sessions should start with `docs/codex_context.md`. It records the
project paths, current metadata state, preprocessing decisions, and next steps
for launching the multiomics pipeline on ULHPC.

Track implementation history in `CHANGELOG.md`.

## Project setup

HPC project directory:

```sh
/scratch/users/snarayanasamy/phage_uv_treatment
```

Create the project metadata directory:

```sh
mkdir -p /scratch/users/snarayanasamy/phage_uv_treatment/metadata
```

Resolve ENA study metadata into the multiomics pipeline sample-sheet format:

```sh
python /mnt/aiongpfs/users/snarayanasamy/repositories/multiomics_pipeline/scripts/ena/resolve_ena_study.py PRJEB79569 /scratch/users/snarayanasamy/phage_uv_treatment/metadata/PRJEB79569_multiomics_samples.tsv --metadata /scratch/users/snarayanasamy/phage_uv_treatment/metadata/sample_metadata.tsv --require-library-strategy WGS
```

Generated metadata file:

```sh
/scratch/users/snarayanasamy/phage_uv_treatment/metadata/PRJEB79569_multiomics_samples.tsv
```

The optional curated metadata file
`/scratch/users/snarayanasamy/phage_uv_treatment/metadata/sample_metadata.tsv`
was not present when this was generated, so condition, phase, cycle, and
analysis group columns are empty. Amplicon runs were skipped by the
`--require-library-strategy WGS` filter.

## Preprocessing launch

Project-specific ULHPC Snakemake config and launchers are kept in this
repository:

```sh
config/PRJEB79569_ulhpc_config.yml
config/ulhpc_cluster_config.yml
launchers/sbatch_mg_preprocessing.sh
launchers/sbatch_mt_preprocessing.sh
```

Run metagenomics preprocessing first:

```sh
bash launchers/sbatch_mg_preprocessing.sh --dry-run
bash launchers/sbatch_mg_preprocessing.sh
```

Run metatranscriptomics preprocessing only after SortMeRNA and human mRNA
references are present under the shared reference root:

```sh
bash launchers/sbatch_mt_preprocessing.sh --dry-run
bash launchers/sbatch_mt_preprocessing.sh
```
