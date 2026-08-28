# Handoff: PRJEB79569 Phage-UV Ecology Project

Date: 2026-07-28; statistical update 2026-07-30

> Historical handoff. The controlling continuation is now
> `notes/handoff-2026-08-10-full-transcriptome-de-reset.md`. All subset-first
> SOS/UV/DNA-repair expression analyses and their numerical results in this
> file are quarantined quick checks; see `docs/expression_quarantine.md`.

This is the compact entry point for the next session. Stay within the
`PRJEB79569` phage-UV ecology project. Do not branch into unrelated storage,
projects, or infrastructure cleanup.

## Scientific Objective

Develop the ecology-focused manuscript analysis for repeated phage-UV treatment
of anaerobic membrane biofilms:

- community response;
- transcriptional ecology;
- descriptive population-genomic stability and turnover;
- integrated MAG/rMAG interpretation.

Do not recenter the work as an engineering or treatment-performance paper.
inStrain is not a DNA-damage assay: never describe its differences as lesions,
UV-caused mutations, mutagenesis, adaptation, or mutation accumulation.

## Canonical Paths

- Project data root:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment`
- Local analysis cache:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569`
- Analysis repo:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/repo_checkouts/phage_uv_ecology_analysis`
- Branch:
  `feature/prjeb79569-cluster-analysis-ingest`
- Complete canonical HPC archive:
  `/mnt/isilon/projects/bioinformatics_platform/projects/shared_references/scratch_archives/snarayanasamy/phage_uv_treatment_20260726_full_output/output/PRJEB79569`

The historical scratch output tree was deleted after verification. Do not use
old `/scratch/.../output/PRJEB79569` paths as live inputs.

## Durable State

The archive is complete and canonical. Its manifest row is
`prjeb79569_full_output_archive` in `manifests/data_manifest.tsv`.

Verification recorded before scratch deletion:

- 106,645 regular files;
- 9,640 directories including the `output` root;
- 6,578 symlinks;
- 2,891,411,082,235 logical regular-file bytes;
- zero differences in an rsync metadata dry-run.

The local analysis substrate already includes:

- UV-signature summary tables;
- host-phage linkage tables;
- vOTU poster-replication outputs;
- completed scoped priority-20 inStrain summaries;
- 23 metatranscriptomic run-level gene-coverage tables.

Use `notes/handoff-2026-07-25-project-continuation.md` for exact paths, validated
line counts, interpretation constraints, and detailed next-analysis tasks.

## Workstream Ownership

The 16S workstream is already delegated to a high-competence
microbiome/bioinformatics collaborator and their agents. It is not a blocker
owned by the main continuation agent. Its durable handoff is
`notes/handoff-2026-07-25-16s-analysis.md`.

Keep the main session focused on the integrated phage-UV analysis. Incorporate
16S results when the delegated collaborator returns them.

## Immediate Next Work

1. Inspect the coverage-qualified descriptive population-genomics panel without
   imposing treatment or DNA-damage claims.
2. Reassess the ecological and transcriptional results without using DNA damage
   as the organizing hypothesis.
3. Keep the longitudinal design limitation explicit throughout the manuscript.
4. Integrate the delegated 16S results when the collaborator returns them.
5. Keep host-phage integration deferred unless it clarifies a supported result.

## Current Figure Work

All candidate plots are intentionally unnumbered and unallocated. The shared
visual grammar is in `docs/figure_visual_grammar.md`, with executable mappings
in `R/figure_style.R`. Phage-UV treatment is fixed to violet and control to
pastel green across main and supplementary work.

Reproducible candidate builders and statistical audits:

- `scripts/build_candidate_ecology_figures.qmd`
- `scripts/build_uv_activity_candidates.qmd`
- `scripts/build_sos_activity_candidates.qmd`
- `scripts/build_temporal_response_analysis.qmd`
- `scripts/evaluate_temporal_cluster_stability.qmd`
- `scripts/run_sos_edger_sensitivity.qmd`
- `scripts/build_population_genomics_descriptive.qmd`

Generated outputs are outside the repo under:

`PRJEB79569/derived/manuscript_candidates/`

The following subset-first expression paragraphs are historical quick-check
provenance only. Their interpretations are withdrawn; do not quote their
numbers or use their apparent directions in downstream analysis.

There is no supported DNA-damage story. SOS transcription is not a DNA-damage
assay and the exploratory direction result does not survive BH correction.

There is no supported monotonic temporal trend. The SOS slope is -0.234 log2
units per cycle (exact phase-blocked p = 0.333; BH-adjusted p = 0.667). An edgeR
technical-model sensitivity finds 26 of 807 SOS genes at FDR <= 0.05 for the
condition coefficient, but no genes for either condition-by-cycle interaction.
Because there is one control membrane and one treated membrane, those p-values
do not create independent biological replication.

Organism trajectory clustering was tested across 60 configurations spanning two
feature spaces, three algorithms, five values of k, and two response modules.
Zero configurations passed the predeclared silhouette and stability criteria.
Cluster membership and taxonomic enrichment outputs are diagnostic only. Use
the continuous ranked heatmap
`sos-mag-continuous-response-heatmap` instead.

The former inferential inStrain comparison is retired. The only retained use is
a qualitative population-genomic landscape restricted by predeclared coverage
criteria. It describes heterogeneous stability or turnover; it does not test
condition, cycle, phase, damage, or mutation accumulation.

The category gene sets are not mutually exclusive. For example, a repair gene
may contribute to both a recombination and an SOS signature. The current CPM
and RNA:DNA figures are quarantined quick checks; neither may be preferred for
manuscript interpretation.

Two useful null or cautionary observations:

- deduplicated host-phage links are sparse, with one or two linked vOTUs for
  most connected hosts;
- scoped condition-associated SNV distances are not generally larger than
  cycle-associated distances.

The complete design, test-family, multiplicity, and null-result record is in
`docs/temporal_analysis_rigor.md`.

The retained qualitative use of the DNA data, its coverage rules, selection
bias, caption, and prohibited interpretations are in
`docs/population_genomics_descriptive.md`.

## Working Rules

- Generated outputs belong under the external project data root.
- Reproducible code, manifests, and documentation belong in this repo.
- Never create Conda or Mamba environments under project scratch. Use the
  shared prefix `/work/projects/bioinformatics_platform/cache/conda`; follow
  `docs/hpc_environment_lifecycle.md`.
- Prefer local analysis from staged tables.
- Do not copy large raw data locally unless explicitly required.
- Do not inventory, modify, or discuss unrelated projects.
- Avoid tight polling loops for any HPC work.
- Preserve the ecological framing and the delegated 16S boundary.

## Scratch Inode Cleanup: 2026-08-04

The project scratch tree was reduced from 259,420 to 143,575 entries without
removing scientific outputs. Deleted items were the inactive `inStrain`
environment, seven Snakemake hash-named environments with matching recreation
YAMLs, and the completed SpacePHARER temporary tree. The user's Lustre inode
usage fell from 715,215 to 599,629 files.

Before deletion, all environment specifications and histories were exported to
the checksummed Isilon archive recorded as `environment_specs_archive` in
`manifests/data_manifest.tsv`. The viromics environments (`checkv`, `vcontact3`,
and `cenotetaker3`) and `catbat_db_tools` remain on scratch pending an explicit
keep-or-rebuild decision. Do not delete them without authorization.

## Authoritative References

- Detailed continuation:
  `notes/handoff-2026-07-25-project-continuation.md`
- Delegated 16S workstream:
  `notes/handoff-2026-07-25-16s-analysis.md`
- Data manifest:
  `manifests/data_manifest.tsv`
- Main project strategy:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/manuscript_publication_strategy.md`
- MT staging provenance:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/quantification/mags_votu/gene_coverage/metatranscriptomics/STAGING_PROVENANCE.md`

## Suggested Skills

- `mattpocock-skills:handoff` before another context transition.
- `mattpocock-skills:diagnose` for data-shape or modeling failures.
- `mattpocock-skills:review` before merging analysis changes.
- `spreadsheets:Spreadsheets` for TSV validation and compact analysis matrices.
