# Handoff: PRJEB79569 Phage-UV Ecology Project

Date: 2026-07-28

This is the compact entry point for the next session. Stay within the
`PRJEB79569` phage-UV ecology project. Do not branch into unrelated storage,
projects, or infrastructure cleanup.

## Scientific Objective

Develop the ecology-focused manuscript analysis for repeated phage-UV treatment
of anaerobic membrane biofilms:

- community response;
- phage-host interactions;
- UV/DNA-damage response potential and activity;
- strain-level divergence and microdiversity;
- integrated MAG/rMAG and vOTU interpretation.

Do not recenter the work as an engineering or treatment-performance paper. Do
not describe inStrain differences as UV-caused mutations.

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

1. Build a compact registry for the locally staged analysis tables.
2. Join MAG/rMAG taxonomy and quality, abundance, UV signatures, host-phage
   links, and scoped inStrain divergence into a candidate table.
3. Build biological-sample expression matrices from the 23 MT run-level
   gene-coverage tables while preserving run provenance.
4. Model expression locally in R; do not run DESeq2 on the cluster.
5. Generate first-pass integrated manuscript figures for vOTUs/rMAGs,
   host-phage links, UV potential/activity, and strain divergence.

## Working Rules

- Generated outputs belong under the external project data root.
- Reproducible code, manifests, and documentation belong in this repo.
- Prefer local analysis from staged tables.
- Do not copy large raw data locally unless explicitly required.
- Do not inventory, modify, or discuss unrelated projects.
- Avoid tight polling loops for any HPC work.
- Preserve the ecological framing and the delegated 16S boundary.

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
