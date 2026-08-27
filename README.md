# PRJEB79569 phage-UV ecology analysis

Active manuscript-analysis workspace for the PRJEB79569 anaerobic membrane
biofilm experiment (ENA secondary accession `ERP163720`). This repository owns
analysis code, metadata contracts, provenance manifests, figures, and
manuscript scaffolding; large primary and derived data remain in managed
project storage.

## Current analysis state

The transcriptome-wide model, its functional, taxonomic, MAG-resolved, and
six-cell recurrence interpretation, and the manuscript workflow rebuild are
complete. A proposed manuscript and machine-readable claim audit are ready for
scientific and voice review. No subset-first expression model is valid.

The experimental design contains one control membrane and one treated membrane
sampled across three cycles and two phases. Condition is therefore confounded
with membrane identity; contrasts are reported as system-specific comparisons,
not general causal treatment effects.

Population-genomic variation is descriptive and coverage-qualified. The 16S
workstream is delegated separately; this repository provides its verified input
contract and expert handoff without absorbing it into the manuscript workstream.

## Start here

- `notes/handoff-2026-08-10-manuscript-rebuild.md`: controlling scientific
  handoff and next decision;
- `notes/handoff-2026-08-20-16s-collaborator.md`: delegated expert 16S package,
  including exact ENA input manifests and analytical boundaries;
- `manuscript/manuscript_skeleton.md`: proposed manuscript draft for review;
- `manuscript/claim_evidence_registry.tsv`: claim-by-claim evidence audit;
- `manuscript/analysis_registry.tsv`: current, descriptive, delegated,
  deferred, and prohibited workflow registry;
- `analysis/phage_uv_ecology.qmd`: executable manuscript audit surface;
- `docs/full_de_interpretation_results.md`: concise verified result summary;
- `docs/full_de_interpretation_plan.md`: frozen #23 methods and thresholds;
- `docs/manuscript_figure_plan.md`: unnumbered candidate architecture and
  manuscript-use boundaries;
- `docs/expression_quarantine.md`: binding boundary around earlier subset-first
  exploratory analyses;
- `docs/codex_context.md`: compact project orientation;
- `manifests/data_manifest.tsv`: external data and derived-artifact provenance;
- `manifests/code_manifest.tsv`: analysis code provenance and reuse status;
- `metadata/sample_metadata.tsv`: physical-sample design metadata.

Older handoffs and subset-oriented scripts are retained for provenance where
the quarantine document says so. They are not current manuscript evidence.

## Repository layout

```text
R/            shared plotting and analysis helpers
analysis/     reproducible analysis documents
config/       project and HPC configuration
docs/         scientific boundaries and analysis decisions
hpc/          cluster-side integration assets
launchers/    canonical project workflow entrypoints
manifests/    data and code provenance
manuscript/   manuscript scaffold
metadata/     versioned sample metadata
notes/        durable handoffs
scripts/      reproducible analysis and validation scripts
```

## Validation

Build the first three unnumbered manuscript candidates into a fresh external
output directory, then validate their exact counts, tables, registry, and
checksums:

```sh
Rscript scripts/build_manuscript_figure_candidates.R /path/to/fresh/output
Rscript scripts/build_recurrent_gene_candidate.R /path/to/fresh/output
Rscript tests/test_manuscript_figure_candidates.R /path/to/fresh/output
```

The recurrence builder adds only its own vector PDF and source tables to an
existing candidate directory. It does not refit the differential-expression
model or change the frozen recurrence thresholds.

Validate manifest structure after changing tracked inputs or outputs:

```sh
bash scripts/validate_manifests.sh
```

Use `git diff --check` before committing. Generated tables, figures, logs,
caches, workflow state, and large datasets belong outside Git unless a manifest
explicitly records a small versioned artifact.

## Related repositories

- `multiomics_pipeline`: upstream MG/MT processing;
- `host_phage_linking`: optional host-phage evidence;
- `community_uv_response`: optional signature annotation and descriptive
  population-genomics utilities;
- `membrane_cleaning`: legacy provenance only.
