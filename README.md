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
