# Handoff: PRJEB79569 Project Continuation

Date: 2026-07-25

This is the compact continuation context for the phage-UV ecology manuscript work. It is meant for a fresh Codex/agent session to resume without relying on chat history. Keep using repo documents and local staged tables as source of truth.

## Current Objective

Move from foundational data staging into local manuscript analyses for ENA study `PRJEB79569` / `ERP163720`.

The manuscript framing is ecological: repeated phage-UV treatment of anaerobic membrane biofilms, with emphasis on community response, phage-host interactions, UV/DNA-damage response potential/activity, and strain-level divergence.

Do not recenter the work as an engineering/treatment-performance paper. The engineering/treatment manuscript exists as context, but this analysis is the new ecology/phage-UV layer.

## Main Paths

Project data root:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment`

Local PRJEB79569 table/output cache:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569`

Analysis repo:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/repo_checkouts/phage_uv_ecology_analysis`

Current analysis branch:

`feature/prjeb79569-cluster-analysis-ingest`

Community UV module repo:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/repo_checkouts/community_uv_response`

Canonical HPC archive root:

`/mnt/isilon/projects/bioinformatics_platform/projects/shared_references/scratch_archives/snarayanasamy/phage_uv_treatment_20260726_full_output/output/PRJEB79569`

SSH alias:

`iris-cluster`

## Isilon Archive Status

The full-output archive is complete and the Isilon copy is now canonical.

- Historical scratch source:
  `/mnt/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569`
- Canonical Isilon destination:
  `/mnt/isilon/projects/bioinformatics_platform/projects/shared_references/scratch_archives/snarayanasamy/phage_uv_treatment_20260726_full_output/output/PRJEB79569`
- Successful resume log:
  `/mnt/isilon/projects/bioinformatics_platform/projects/shared_references/scratch_archives/snarayanasamy/phage_uv_treatment_20260726_full_output/rsync_resume_20260728.log`

On 2026-07-28, the PRJEB79569 archive was resumed from Iris `access1` with a
direct standard `rsync -a --info=progress2` command. The resume copied
898,748,998,548 bytes across 24,379 files and ended with
`to-chk=0/122863`; the log contains no rsync errors.

Verification before scratch deletion:

- the rsync metadata dry-run produced a zero-byte difference list;
- source and Isilon both contained 106,645 regular files, 9,640 directories
  including the `output` root, and 6,578 symlinks;
- both contained 2,891,411,082,235 logical regular-file bytes;
- `quantification` contained 398 files on both sides;
- `viromics` contained 23,969 files on both sides;
- one 257,426,432-byte `.contigs...v8VrZe` rsync temporary file left by the
  failed transfer was identified as destination-only and removed.

After these checks, the exact scratch tree
`/mnt/scratch/users/snarayanasamy/phage_uv_treatment/output` was deleted and
confirmed absent. Immediate Lustre quota usage fell from 9.449 T to 9.108 T;
quota measures allocated blocks rather than the archive's logical byte total.
Do not use the historical scratch paths in commands. Use the Isilon archive.

The successful rsync provides its normal transfer-integrity checking, and the
post-transfer structural/metadata comparison is recorded above. A separate
persistent full-tree SHA-256 manifest was not generated.

## Existing Source Context

Use these before asking the user to restate context:

- Main project strategy:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/manuscript_publication_strategy.md`
- Poster-derived source/context:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/Narayanasamy_et_al_poster.md`
- Prior detailed analysis text:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/Narayanasamy_et_al_analysis.md`
- Engineering/treatment manuscript:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/Myshkevych_et_al.md`
- Analysis repo context:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/repo_checkouts/phage_uv_ecology_analysis/docs/codex_context.md`
- Host-phage integration contract:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/repo_checkouts/phage_uv_ecology_analysis/docs/host_phage_linking_integration.md`
- HPC job-agent protocol:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/repo_checkouts/phage_uv_ecology_analysis/docs/hpc_job_agent_protocol.md`

Note: `docs/instrain_status_2026-07-24.md` records an earlier incomplete state. It is stale after the scoped priority-20 repair described below.

## Sample Metadata

Canonical sample metadata:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/repo_checkouts/phage_uv_ecology_analysis/metadata/sample_metadata.tsv`

It maps 12 physical samples with:

- `condition`: control/treatment
- `phase`: initial/backflush
- `cycle`: 1-3
- `analysis_group`: condition-cycle group
- ENA accessions for amplicon, metagenome, and metatranscriptome data

Project convention:

- retain `phase` as metadata and QC context,
- use `analysis_group` / condition-cycle summaries for main manuscript interpretation where valid,
- do not collapse phase blindly if QC shows contradictory phase-level patterns.

## Data Staged Locally

### UV/DNA-Damage Signature Tables

Directory:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/community_uv_response`

Key files:

- `uv_signature_hits.tsv`
- `uv_signature_entity_summary.tsv`
- `uv_signature_mag_summary.tsv`

Validated local line counts:

- `uv_signature_entity_summary.tsv`: 4,805 lines
- `uv_signature_mag_summary.tsv`: 2,198 lines

### Host-Phage Linkage

Directory:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/host_phage_linking/full/summary_data`

Key files:

- `host_phage_links.tsv`: 149 lines
- `spacepharer_spacer_alignment_results.tsv`: 1,667 lines
- `host_phage_link_summary.tsv`: 8 lines

These outputs came from the `host_phage_linking` pipeline and should be joined to MAG/vOTU summaries, UV signatures, and candidate rMAGs.

### vOTU Poster-Replication Outputs

Directory:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/poster_replication`

Useful subdirectories:

- `tables/`
- `figures/`
- `trees/`

These support the vOTU overview/tree panels and are already suitable as a starting point for manuscript figure cleanup.

### Scoped inStrain Priority-20 Outputs

Directory:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/community_uv_response/variant_analysis/instrain_priority_20`

This is no longer a blocker.

Staged/validated outputs:

- all 12 scoped sample profile PASS sentinels exist under `logs/`
- compare PASS sentinel exists:
  `logs/instrain_compare_5555559.PASS`
- raw compare tables:
  `compare/all_samples/output/all_samples_comparisonsTable.tsv`
  `compare/all_samples/output/all_samples_genomeWide_compare.tsv`
  `compare/all_samples/output/all_samples_strain_clusters.tsv`
- manuscript-facing parsed tables:
  `tables/priority20_instrain_compare_summary.tsv`
  `tables/priority20_rmag_snv_divergence.tsv`

Validated local line counts:

- `priority20_instrain_compare_summary.tsv`: 192 lines
- `priority20_rmag_snv_divergence.tsv`: 43 lines

Interpretation rule:

Do not claim UV-caused mutations. Frame this as strain-level divergence or microdiversity under repeated phage-UV exposure.

### MT Gene-Coverage Tables

Directory:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/quantification/mags_votu/gene_coverage/metatranscriptomics`

Staged on 2026-07-25 from Iris.

Validated:

- 23 metatranscriptomic run-level TSVs
- 1,734,193 rows per TSV
- total local footprint around 4 GB

Provenance note:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/quantification/mags_votu/gene_coverage/metatranscriptomics/STAGING_PROVENANCE.md`

These are bed-guided gene coverage/count tables over the MAG/vOTU catalogue. Build local expression summaries and DE models from these; do not run DESeq2 on the cluster.

## 16S Handoff

A separate 16S-specific handoff was created for another analyst:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/repo_checkouts/phage_uv_ecology_analysis/notes/handoff-2026-07-25-16s-analysis.md`

Ownership/status:

The 16S work is already delegated to a high-competence microbiome/bioinformatics collaborator and their agents. It is **not a blocker assigned to the main continuation agent**. The delegated collaborator owns input discovery and the reproducible analysis route.

The analysis repo has 12 amplicon ENA run accessions in `metadata/sample_metadata.tsv`. Ready-to-use local ASV/OTU/BIOM/phyloseq artifacts were not found during the prior local check, so locating existing QIIME2/DADA2 outputs—or reproducibly processing the ENA inputs—is the delegated collaborator's first technical task, not evidence that the project handoff failed.

The `EnSE314` repo is only a methodological guide for the phyloseq/DESeq2 pattern:

`https://github.com/shaman-narayanasamy/EnSE314`

## Immediate Next Analysis Work

Recommended next local work:

1. Build a compact local analysis table registry for the staged outputs.
2. Produce a MAG/rMAG candidate table joining:
   - MAG taxonomy/quality,
   - MAG/vOTU abundance,
   - UV signature summaries,
   - host-phage links,
   - scoped inStrain divergence summaries.
3. Build MT gene-expression matrices from the 23 run-level gene-coverage TSVs.
   - combine MT technical sequencing replicates at biological-sample level after count extraction,
   - keep run-level provenance,
   - model locally in R.
4. Generate first-pass figures:
   - vOTU/rMAG overview and host-phage links,
   - UV signature potential/activity across condition-cycle groups,
   - scoped inStrain divergence panel,
   - prioritized MAG panel integrating UV response, phage linkage, and strain divergence.
5. Keep 16S separate until the delegated analyst returns usable outputs.

## Important Working Rules

- Generated data outputs stay under:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569`
- Reproducible code, manifests, and docs stay in:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/repo_checkouts/phage_uv_ecology_analysis`
- Do not copy BAM/FASTQ/raw inStrain profile data locally unless explicitly needed.
- Do not burn agent context with tight Slurm polling. Use sentinels, logs, summaries, and GitHub issue comments.
- Run bulk storage transfers on the Iris access node, not a Slurm compute node.
- The Isilon archive is complete and canonical. The historical scratch output tree was deleted after verification.
- Ask the user before assuming missing HPC/collaborator paths.
- Preserve branch state and avoid destructive git commands.

## Current Git State At Handoff

Analysis repo branch:

`feature/prjeb79569-cluster-analysis-ingest`

Tracked durable handoff files:

- `notes/handoff-2026-07-25-16s-analysis.md`
- `notes/handoff-2026-07-25-project-continuation.md`

Use the branch and these repo files as the handoff surface; do not rely on chat history. Check the current local and remote heads before making further changes rather than treating this dated section as a live Git status report.

## Suggested Skills For Agentic Work

- `mattpocock-skills:handoff` before context transitions.
- `mattpocock-skills:diagnose` for data-shape or modeling failures.
- `mattpocock-skills:review` before merging analysis changes.
- `spreadsheets:Spreadsheets` for TSV/CSV validation and compact matrices.
- `mattpocock-skills:grill-me` when choosing modeling formulas or deciding how much to collapse phase/cycle.
