#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(data.table))

repo_root <- normalizePath(getwd())
analysis_registry <- fread(file.path(repo_root, "manuscript", "analysis_registry.tsv"))
claim_registry <- fread(file.path(repo_root, "manuscript", "claim_evidence_registry.tsv"))
data_manifest <- fread(file.path(repo_root, "manifests", "data_manifest.tsv"))

manifest_path <- function(id) {
  hit <- data_manifest[data_id == id]
  stopifnot(nrow(hit) == 1L)
  normalizePath(hit$path[[1L]], mustWork = TRUE)
}

stopifnot(
  !anyDuplicated(analysis_registry$analysis_id),
  !anyDuplicated(claim_registry$claim_id),
  identical(
    claim_registry[claim_id %chin% c("C03", "C04"), unique(allocation)],
    "working_Figure_1"
  ),
  identical(
    claim_registry[claim_id %chin% c("C05", "C06", "C08"), unique(allocation)],
    "working_Figure_2"
  ),
  claim_registry[claim_id == "C09", allocation] == "working_Figure_3",
  claim_registry[claim_id == "C10", allocation] == "working_Figure_4",
  claim_registry[claim_id == "C12", allocation] == "working_Figure_5_reserved",
  all(
    analysis_registry[status == "deprecated_superseded", manuscript_use] ==
      "provenance_only"
  ),
  analysis_registry[analysis_id == "16s_integration", status] ==
    "delegated_external",
  analysis_registry[analysis_id == "host_phage_links", status] ==
    "verified_deferred"
)

de_root <- manifest_path("full_transcriptome_de_results")
interpretation_root <- manifest_path("full_de_interpretation")

filtering <- fread(file.path(de_root, "tables", "filtering_summary.tsv"))
condition <- fread(file.path(de_root, "tables", "de_condition_adjusted.tsv"))
category <- fread(file.path(
  interpretation_root,
  "tables",
  "functional_category_enrichment.tsv"
))
mag <- fread(file.path(interpretation_root, "tables", "mag_coherence.tsv"))
candidates <- fread(file.path(
  interpretation_root,
  "tables",
  "predeclared_gene_candidates.tsv"
))

supported_condition <- condition[FDR < 0.05]
sos_condition <- category[
  coefficient == "condition_adjusted" & set_id == "SOS_response"
]
mag_condition <- mag[
  coefficient == "condition_adjusted" & eligible == TRUE & FDR < 0.05
]

stopifnot(
  filtering$input_features == 1734019L,
  filtering$retained_features == 361907L,
  nrow(supported_condition) == 7703L,
  supported_condition[abs(logFC) >= 1, .N] == 7699L,
  supported_condition[abs(logFC) >= 1 & logFC > 0, .N] == 3694L,
  supported_condition[abs(logFC) >= 1 & logFC < 0, .N] == 4005L,
  nrow(sos_condition) == 1L,
  sos_condition$NGenes == 523L,
  abs(sos_condition$FDR - 0.002067955) < 1e-9,
  uniqueN(mag[eligible == TRUE]$MAG_ID) == 340L,
  nrow(mag_condition) == 175L,
  mag_condition[Direction == "Up", .N] == 100L,
  mag_condition[Direction == "Down", .N] == 75L,
  candidates[recurrence_class == "recurrent_treatment_higher", .N] == 3334L,
  candidates[recurrence_class == "recurrent_control_higher", .N] == 3651L
)

message("Manuscript registries and quantitative claims verified.")
