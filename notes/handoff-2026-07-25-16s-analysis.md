# Handoff: PRJEB79569 16S Analysis

Date: 2026-07-25

This handoff is for a high-competence microbiome/bioinformatics analyst and their agents. Treat it as context, constraints, and known paths, not as a locked implementation recipe. The analyst has autonomy to choose the statistically and biologically defensible route.

## Project Context

The study is ENA `PRJEB79569` / `ERP163720`, focused on repeated phage-UV treatment of anaerobic membrane biofilms.

The main manuscript analysis is not trying to reproduce the already-submitted engineering/treatment manuscript verbatim. The current study reframes the data around:

- biofilm community response under repeated phage-UV exposure,
- phage-host interactions,
- UV/DNA-damage response potential and activity,
- strain-level divergence from scoped inStrain analysis,
- 16S community profiles as supporting ecological context.

Main project-local data root:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569`

Main analysis repo:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/repo_checkouts/phage_uv_ecology_analysis`

Current analysis branch:

`feature/prjeb79569-cluster-analysis-ingest`

## Ownership And Handoff Status

This workstream has already been handed to a high-competence microbiome/bioinformatics collaborator and their agents. It is **delegated, not blocked**. The main project-continuation agent should not take it over or describe it as waiting on the main analysis.

Input discovery is the delegated collaborator's first technical task. That collaborator has autonomy to locate existing processed artifacts, retrieve raw ENA reads if needed, and choose a reproducible QIIME2/DADA2 or equivalent route.

## Relevant Existing Context Files

- Project source/context note:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/manuscript_publication_strategy.md`
- Poster-derived manuscript/context source:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/Narayanasamy_et_al_poster.md`
- Prior analysis text:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/Narayanasamy_et_al_analysis.md`
- Engineering/treatment manuscript text:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/Myshkevych_et_al.md`
- Codex/project context:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/repo_checkouts/phage_uv_ecology_analysis/docs/codex_context.md`
- Canonical sample metadata:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/repo_checkouts/phage_uv_ecology_analysis/metadata/sample_metadata.tsv`

## 16S Input Status

The analysis repo has the canonical sample map, including amplicon ENA run accessions. As of this handoff, local ASV/OTU/BIOM/phyloseq artifacts were not found in the local PRJEB79569 table cache.

The analyst should first decide whether to:

1. locate already-produced QIIME2/DADA2 16S outputs from the project/HPC/collaborators, or
2. pull the 16S raw amplicon reads from ENA and process them reproducibly.

Do not assume the 16S feature table already exists locally.

The Iris scratch output tree is currently the authoritative HPC search location:

`/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569`

A resumable Isilon copy exists at the path below, but it stopped at the `bioinformatics_platform` project quota before full transfer and verification. Do not treat it as a complete search space until a later handoff records a verified PASS:

`/mnt/isilon/projects/bioinformatics_platform/projects/shared_references/scratch_archives/snarayanasamy/phage_uv_treatment_20260726_full_output/output/PRJEB79569`

The scratch source remains intact. The archive state and exact inventory are recorded in `notes/handoff-2026-07-25-project-continuation.md` and `manifests/data_manifest.tsv`.

Amplicon accessions are in `metadata/sample_metadata.tsv` under `amplicon_run_accession`.

There are 12 physical samples:

- control/treatment,
- initial/backflush phase,
- cycles 1-3.

The project-wide downstream simplification is to keep `phase` as metadata while using `analysis_group = condition_cycle` for main narrative summaries where appropriate. For 16S, the analyst should check whether phase effects are strong enough that they need explicit modeling or separate supplementary QC rather than blind collapsing.

## Published/Submitted 16S Methods Context

The engineering/treatment manuscript text says 16S amplicons were generated from cDNA to assess active biofilm community composition. It describes 515F/907R primers, Illumina MiSeq sequencing, QIIME2 v2022.11, DADA2 denoising/chimera removal, ASVs/OTUs, rarefaction depth 23,800, and SILVA 138 taxonomy with q2-feature-classifier.

Use this as methodological provenance, not as an obligation to exactly repeat every choice. If reprocessing raw reads, justify any deviations from the submitted methods.

Relevant section:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/Myshkevych_et_al.md`

Search terms: `16S rRNA gene-based amplicon sequencing`, `QIIME 2`, `DADA2`, `Silva 138`.

## EnSE314 Guide

The user mentioned an `ense` course repo as a guide. The likely repo is:

`https://github.com/shaman-narayanasamy/EnSE314`

Relevant file:

`data_analysis.qmd`

The important pattern is:

- build/read a `phyloseq` object,
- attach sample metadata,
- do ecological summaries,
- use `phyloseq_to_deseq2()` for differential abundance,
- join significant features back to taxonomy.

This is a guide only. Do not copy course code blindly. The analyst and their agents should adapt the workflow to this study's design, metadata, and sample size.

## Recommended Analysis Shape

Minimum useful 16S analysis:

- Produce a reproducible 16S object or table set:
  - count table,
  - taxonomy table,
  - sample metadata,
  - optional phylogenetic tree if defensible/available,
  - saved `phyloseq` object if using R/phyloseq.
- Confirm all samples map to ENA `PRJEB79569` and to `metadata/sample_metadata.tsv`.
- Summarize sequencing depth and feature retention after filtering.
- Alpha diversity:
  - report by condition, cycle, phase, and `analysis_group`.
  - avoid overclaiming given the small design.
- Beta diversity:
  - ordination from an appropriate compositional/ecological distance.
  - PERMANOVA with care; consider `phase` and `cycle`.
- Taxonomic composition:
  - show dominant taxa across condition-cycle groups.
  - consider including the engineering-paper genera of interest as supporting context: `Acinetobacter`, `Cloacibacterium`, `Pseudomonas`, and `Clostridium`.
- Differential abundance:
  - use local R analysis, not the cluster.
  - `phyloseq_to_deseq2()` is appropriate for 16S-style count data.
  - do not rarefy before DESeq2.
  - apply defensible low-count/low-prevalence filtering before modeling.
  - start simple, then expand only if the design supports it.

Possible model directions:

- conservative first pass: `~ phase + cycle + condition`
- condition-cycle exploration: test within-cycle treatment vs control contrasts if power is acceptable
- interaction model only if the analyst judges the design supports it

The final biological framing should be ecological support for the phage-UV manuscript, not a standalone 16S paper.

## Suggested Outputs

Place code in the analysis repo, not in the external data directory:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/repo_checkouts/phage_uv_ecology_analysis`

Place generated outputs under the external data root:

`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/16s_analysis`

Suggested final artifacts:

- `tables/16s_sample_qc.tsv`
- `tables/16s_feature_table_filtered.tsv` or equivalent BIOM/RDS artifact
- `tables/16s_taxonomy.tsv`
- `tables/16s_alpha_diversity.tsv`
- `tables/16s_beta_permanova.tsv`
- `tables/16s_deseq_results.tsv`
- `figures/16s_depth_qc.*`
- `figures/16s_alpha_diversity.*`
- `figures/16s_ordination.*`
- `figures/16s_taxonomic_composition.*`
- `figures/16s_target_genera.*`
- `objects/phyloseq_16s.rds` if using phyloseq

## Integration Points With The Main Manuscript

The 16S analysis should eventually be integrated with:

- vOTU summaries:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/poster_replication`
- host-phage linkage:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/host_phage_linking/full/summary_data`
- UV signature summaries:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/community_uv_response`
- scoped inStrain outputs:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/community_uv_response/variant_analysis/instrain_priority_20/tables`
- MT gene-coverage tables:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/quantification/mags_votu/gene_coverage/metatranscriptomics`

16S is supporting evidence. It does not need to carry the full novelty of the manuscript.

## Known Caveats

- The local cache currently appears to lack ready-to-use 16S ASV/OTU/phyloseq outputs.
- Raw amplicon reads are in ENA, but the user generally prefers not to pull raw data unless needed.
- The published/submitted manuscript's 16S processing choices are useful provenance but should not override better current practice if the analyst documents the reason.
- Small sample size means differential abundance should be framed cautiously.
- Phase can be biologically meaningful; do not collapse initial/backflush without QC.
- The EnSE314 repository is pedagogical guidance, not project source of truth.

## Suggested Skills For Agentic Work

- `mattpocock-skills:diagnose` if input discovery or QIIME2/DADA2 import fails.
- `mattpocock-skills:handoff` when passing the analysis onward again.
- `mattpocock-skills:review` before merging a 16S analysis PR.
- `spreadsheets:Spreadsheets` if validating TSV/CSV matrices or producing compact review tables.

## First Practical Step

The delegated collaborator should start by opening `metadata/sample_metadata.tsv`, extracting the 12 `amplicon_run_accession` values, and checking whether corresponding processed 16S artifacts already exist on Iris or in collaborator outputs. Search the intact scratch source rather than relying on the incomplete Isilon copy. If artifacts are not found, create a small reproducible 16S processing branch in `phage_uv_ecology_analysis` and process/fetch from ENA with clear provenance.
