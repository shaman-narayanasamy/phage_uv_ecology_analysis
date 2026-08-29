# PRJEB79569 phage-UV ecology analysis

Active manuscript-analysis workspace for the PRJEB79569 anaerobic membrane
biofilm experiment (ENA secondary accession `ERP163720`). This repository owns
analysis code, metadata contracts, provenance manifests, figures, and
manuscript scaffolding; large primary and derived data remain in managed
project storage.

## Current analysis state

The transcriptome-wide model, its functional, taxonomic, MAG-resolved, and
six-cell recurrence interpretation, and the manuscript workflow rebuild are
complete. Six unnumbered manuscript candidates and five supplementary
candidates are built and visually verified; two of the manuscript candidates
are descriptive taxonomic-context options that remain unallocated, and the
delegated 16S figure remains the only reserved external insertion. A complete
venue-neutral first draft,
descriptive legend set, Zotero-importable bibliography, and machine-readable
claim audit are ready for scientific and voice review. No subset-first
expression model is valid.

The experimental design contains one control membrane and one treated membrane
sampled across three cycles and two phases. Condition is therefore confounded
with membrane identity; contrasts are reported as system-specific comparisons,
not general causal treatment effects.

Population-genomic variation is descriptive and coverage-qualified. The 16S
workstream is delegated separately; this repository provides its verified input
contract and expert handoff without absorbing it into the manuscript workstream.

## Start here

- `notes/handoff-2026-08-27-full-manuscript-draft.md`: controlling scientific
  handoff and current author-review state;
- `notes/handoff-2026-08-20-16s-collaborator.md`: delegated expert 16S package,
  including exact ENA input manifests and analytical boundaries;
- `manuscript/manuscript_skeleton.md`: complete working manuscript draft;
- `manuscript/figure_legends.md`: descriptive main and supplementary legends;
- `manuscript/references.bib`: bibliography for import into Zotero;
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
scripts/      Quarto analysis notebooks, runners, and validation helpers
```

## Quarto notebook workflow

The 20 standalone R analysis entrypoints are maintained as Quarto notebooks in
`scripts/*.qmd`. Open a notebook in RStudio to run individual lines or its R
chunk while inspecting objects inline. Automatic execution during rendering is
disabled because several notebooks write or replace project outputs.

For the exact command-line behaviour of the former `Rscript` entrypoints,
including positional arguments, use the repository runner:

```sh
bash scripts/run_qmd.sh scripts/run_full_transcriptome_edger.qmd --help
```

The runner extracts the R source into a temporary directory, supplies the
notebook path for repository discovery, executes it with `Rscript`, and removes
the temporary extraction. Files in `R/` remain sourceable modules and files in
`tests/` remain automated R tests; they are not standalone notebooks.

## Validation

Build the first three unnumbered manuscript candidates into a fresh external
output directory, add the population-genomics and supplementary suite, then
validate the exact counts, tables, registry, and checksums:

```sh
bash scripts/run_qmd.sh scripts/build_manuscript_figure_candidates.qmd /path/to/fresh/output
bash scripts/run_qmd.sh scripts/build_recurrent_gene_candidate.qmd /path/to/fresh/output
bash scripts/run_qmd.sh scripts/build_remaining_manuscript_figures.qmd /path/to/fresh/output
bash scripts/run_qmd.sh scripts/build_taxonomic_context_figures.qmd /path/to/fresh/output
Rscript tests/test_manuscript_figure_candidates.R /path/to/fresh/output
```

The recurrence builder adds only its own vector PDF and source tables to an
existing candidate directory. It does not refit the differential-expression
model or change the frozen recurrence thresholds.

The remaining-figure builder adds one coverage-qualified population-genomics
candidate and five supplementary vector PDFs from canonical result tables. It
uses staged promotion and refreshes the registry and checksum inventory only
after all six PDFs render successfully.

The taxonomic-context builder adds descriptive MAG and vOTU candidates. Both
trees are taxonomy-derived dendrograms rather than sequence phylogenies. The
MAG figure places completeness and contamination before the post-model
biological overlays and adds a 12-sample family-level metagenomic community
profile. The vOTU panel is a descriptive catalogue view and carries no
treatment or host-phage inference.

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
