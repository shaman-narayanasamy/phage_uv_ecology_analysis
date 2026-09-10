#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(data.table))

repo_root <- normalizePath(getwd())
analysis_registry <- fread(file.path(repo_root, "manuscript", "analysis_registry.tsv"))
claim_registry <- fread(file.path(repo_root, "manuscript", "claim_evidence_registry.tsv"))
data_manifest <- fread(file.path(repo_root, "manifests", "data_manifest.tsv"))
manuscript_text <- paste(
  readLines(file.path(repo_root, "manuscript", "manuscript_skeleton.md")),
  collapse = "\n"
)

manifest_path <- function(id) {
  hit <- data_manifest[data_id == id]
  stopifnot(nrow(hit) == 1L)
  normalizePath(hit$path[[1L]], mustWork = TRUE)
}

stopifnot(
  !anyDuplicated(analysis_registry$analysis_id),
  !anyDuplicated(claim_registry$claim_id),
  grepl("one control membrane and one phage-UV membrane", manuscript_text),
  grepl("do not provide independent treatment replication", manuscript_text),
  !grepl("independent view of community", manuscript_text, fixed = TRUE),
  !grepl(
    "observed for 663 phage-UV-higher and 942 control-higher",
    manuscript_text,
    fixed = TRUE
  ),
  !grepl(
    "sos-transcription-marker-effects|uv-transcription-treatment-effect|trajectory-clusters|community-rna-dna-temporal-response",
    manuscript_text
  ),
  claim_registry[claim_id == "C03", allocation] == "working_Figure_2_and_S1",
  claim_registry[claim_id == "C04", allocation] == "working_Figure_2",
  claim_registry[claim_id == "C14", allocation] == "working_Figure_1",
  identical(
    claim_registry[claim_id %chin% c("C05", "C06", "C08"), unique(allocation)],
    "working_Figure_3"
  ),
  claim_registry[claim_id == "C09", allocation] == "working_Figure_4",
  claim_registry[claim_id == "C10", allocation] == "working_Figure_5",
  claim_registry[claim_id == "C12", allocation] ==
    "working_Supplementary_Figure_S10",
  claim_registry[claim_id == "C22", allocation] ==
    "working_Supplementary_Figure_S10",
  claim_registry[claim_id == "C29", allocation] ==
    "working_Supplementary_Figure_S10D",
  all(
    analysis_registry[status == "deprecated_superseded", manuscript_use] ==
      "provenance_only"
  ),
  analysis_registry[analysis_id == "16s_integration", status] ==
    "verified_descriptive",
  analysis_registry[analysis_id == "host_phage_links", status] ==
    "verified_deferred"
)

de_root <- manifest_path("full_transcriptome_de_results")
interpretation_root <- manifest_path("full_de_interpretation")
figure_root <- manifest_path("manuscript_figure_candidates")
population_root <- dirname(dirname(manifest_path("population_genomics_descriptive")))

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
run_audit <- fread(file.path(de_root, "tables", "run_file_audit.tsv"))
sample_audit <- fread(file.path(de_root, "tables", "sample_metadata_audit.tsv"))
interaction_counts <- fread(file.path(
  figure_root,
  "tables",
  "supplementary_interaction_feature_counts.tsv"
))
functional_effects <- fread(file.path(
  interpretation_root,
  "tables",
  "functional_category_effect_summary.tsv"
))
category_membership <- fread(file.path(
  interpretation_root,
  "tables",
  "tested_feature_category_membership.tsv"
))
mag_interactions <- fread(file.path(
  figure_root,
  "tables",
  "supplementary_mag_coherence_counts.tsv"
))
recurrence_funnel <- fread(file.path(
  figure_root,
  "tables",
  "recurrence_selection_funnel.tsv"
))
recurrence_concordance <- fread(file.path(
  figure_root,
  "tables",
  "recurrence_direction_concordance.tsv"
))
population_mag_qc <- fread(file.path(
  population_root,
  "tables",
  "population_genomics_mag_qc.tsv"
))
population_clusters <- fread(file.path(
  figure_root,
  "tables",
  "population_genomics_cluster_panel.tsv"
))

supported_condition <- condition[FDR < 0.05]
sos_condition <- category[
  coefficient == "condition_adjusted" & set_id == "SOS_response"
]
mag_condition <- mag[
  coefficient == "condition_adjusted" & eligible == TRUE & FDR < 0.05
]
sos_effect <- functional_effects[
  coefficient == "condition_adjusted" & category == "SOS_response"
]
eligible_population <- population_mag_qc[eligible_for_descriptive_panel == TRUE]
propionicimonas <- population_clusters[grepl("Propionicimonas", panel_label)]

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
  candidates[recurrence_class == "recurrent_control_higher", .N] == 3651L,
  nrow(run_audit) == 23L,
  uniqueN(sample_audit$sample_title) == 12L,
  interaction_counts[coefficient == "cycle2:conditiontreatment", supported_features] == 1L,
  interaction_counts[coefficient == "cycle3:conditiontreatment", supported_features] == 11L,
  interaction_counts[coefficient == "condition_cycle_omnibus", supported_features] == 357L,
  uniqueN(category_membership$feature_id) == 4119L,
  uniqueN(category_membership$category) == 8L,
  nrow(sos_effect) == 1L,
  abs(sos_effect$median_logFC - 0.1362612005) < 1e-9,
  abs(sos_effect$fraction_positive - 0.5793499044) < 1e-9,
  mag_interactions[coefficient_label == "Cycle 2 interaction" & Direction == "Up", MAGs] == 68L,
  mag_interactions[coefficient_label == "Cycle 2 interaction" & Direction == "Down", MAGs] == 65L,
  mag_interactions[coefficient_label == "Cycle 3 interaction" & Direction == "Up", MAGs] == 73L,
  mag_interactions[coefficient_label == "Cycle 3 interaction" & Direction == "Down", MAGs] == 59L,
  recurrence_funnel[stage_short == "Detected in >= 6 samples", features] == 7603L,
  recurrence_funnel[stage_short == "Non-empty gene annotation", features] == 7141L,
  recurrence_funnel[stage_short == "Recurrent in >= 5 of 6 cells", features] == 6985L,
  recurrence_concordance[higher_in == "Phage-UV" & concordance == "6 of 6 cells", features] == 2671L,
  recurrence_concordance[higher_in == "Control" & concordance == "6 of 6 cells", features] == 2709L,
  recurrence_concordance[higher_in == "Phage-UV" & concordance == "5 of 6 cells", features] == 663L,
  recurrence_concordance[higher_in == "Control" & concordance == "5 of 6 cells", features] == 942L,
  nrow(eligible_population) == 5L,
  round(min(eligible_population$median_consensus_differences_per_mbp), 1) == 29.4,
  round(max(eligible_population$median_consensus_differences_per_mbp), 1) == 1114.1,
  propionicimonas[
    sample_label %chin% c("C I1", "C I2", "C I3", "P I1", "P I2", "P I3"),
    unique(strain_cluster)
  ] == "S1",
  propionicimonas[sample_label == "C BF3", strain_cluster] == "S3",
  propionicimonas[sample_label == "P BF3", strain_cluster] == "S2"
)

message("Manuscript registries and quantitative claims verified.")
