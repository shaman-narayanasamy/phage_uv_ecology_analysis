#!/usr/bin/env Rscript

abort <- function(...) stop(sprintf(...), call. = FALSE)
expect <- function(value, message) if (!isTRUE(value)) abort("FAILED: %s", message)
read_tsv <- function(path) read.delim(
  path, sep = "\t", quote = "", comment.char = "", check.names = FALSE,
  stringsAsFactors = FALSE
)

output_dir <- if (length(commandArgs(trailingOnly = TRUE))) {
  commandArgs(trailingOnly = TRUE)[[1L]]
} else {
  "/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/manuscript_figure_candidates"
}

required <- c(
  "figures/global-transcriptome-structure.pdf",
  "figures/functional-organism-restructuring.pdf",
  "figures/recurrent-gene-structure.pdf",
  "figures/population-genomic-heterogeneity.pdf",
  "figures/mag-taxonomic-context.pdf",
  "figures/votu-taxonomic-context.pdf",
  "figures/supplementary-model-diagnostics.pdf",
  "figures/supplementary-cycle-interaction-landscape.pdf",
  "figures/supplementary-functional-coefficients.pdf",
  "figures/supplementary-mag-coherence.pdf",
  "figures/supplementary-population-genomics.pdf",
  "tables/mds_coordinates.tsv",
  "tables/figure_summary.tsv",
  "tables/functional_condition_panel.tsv",
  "tables/top_mag_condition_panel.tsv",
  "tables/recurrence_selection_funnel.tsv",
  "tables/recurrence_direction_concordance.tsv",
  "tables/recurrent_gene_heatmap_selection.tsv",
  "tables/recurrent_gene_heatmap_cells.tsv",
  "tables/population_genomics_cluster_panel.tsv",
  "tables/population_genomics_summary_panel.tsv",
  "tables/population_genomics_propionicimonas_panel.tsv",
  "tables/supplementary_model_diagnostics.tsv",
  "tables/supplementary_interaction_feature_counts.tsv",
  "tables/supplementary_functional_coefficients.tsv",
  "tables/supplementary_mag_coherence_counts.tsv",
  "tables/supplementary_population_genomics_cells.tsv",
  "tables/mag_taxonomic_context.tsv",
  "tables/mag_taxonomic_context_summary.tsv",
  "tables/votu_taxonomic_context_groups.tsv",
  "tables/votu_taxonomic_context_realm_summary.tsv",
  "tables/votu_taxonomic_context_filter_summary.tsv",
  "trees/mag_taxonomic_context.nwk",
  "trees/votu_taxonomic_context.nwk",
  "candidate_figure_registry.tsv",
  "output_checksums.md5.tsv"
)
required_paths <- file.path(output_dir, required)
expect(all(file.exists(required_paths)), "all candidate artifacts exist")
expect(all(file.info(required_paths)$size > 0), "all candidate artifacts are non-empty")
expect(length(Sys.glob(file.path(output_dir, ".recurrent-gene-staging-*"))) == 0L,
       "recurrence builder leaves no hidden staging directories")
expect(length(Sys.glob(file.path(dirname(output_dir), ".remaining-figure-staging-*"))) == 0L,
       "remaining-figure builder leaves no hidden staging directories")
expect(length(Sys.glob(file.path(dirname(output_dir), ".taxonomic-context-staging-*"))) == 0L,
       "taxonomic-context builder leaves no hidden staging directories")

mds <- read_tsv(file.path(output_dir, "tables", "mds_coordinates.tsv"))
summary <- read_tsv(file.path(output_dir, "tables", "figure_summary.tsv"))
functional <- read_tsv(file.path(output_dir, "tables", "functional_condition_panel.tsv"))
top_mag <- read_tsv(file.path(output_dir, "tables", "top_mag_condition_panel.tsv"))
funnel <- read_tsv(file.path(output_dir, "tables", "recurrence_selection_funnel.tsv"))
concordance <- read_tsv(file.path(output_dir, "tables", "recurrence_direction_concordance.tsv"))
heatmap_selection <- read_tsv(file.path(output_dir, "tables", "recurrent_gene_heatmap_selection.tsv"))
heatmap_cells <- read_tsv(file.path(output_dir, "tables", "recurrent_gene_heatmap_cells.tsv"))
population_clusters <- read_tsv(file.path(output_dir, "tables", "population_genomics_cluster_panel.tsv"))
population_summary <- read_tsv(file.path(output_dir, "tables", "population_genomics_summary_panel.tsv"))
propionicimonas <- read_tsv(file.path(output_dir, "tables", "population_genomics_propionicimonas_panel.tsv"))
model_diagnostics <- read_tsv(file.path(output_dir, "tables", "supplementary_model_diagnostics.tsv"))
interaction_counts <- read_tsv(file.path(output_dir, "tables", "supplementary_interaction_feature_counts.tsv"))
functional_all <- read_tsv(file.path(output_dir, "tables", "supplementary_functional_coefficients.tsv"))
mag_counts <- read_tsv(file.path(output_dir, "tables", "supplementary_mag_coherence_counts.tsv"))
population_cells <- read_tsv(file.path(output_dir, "tables", "supplementary_population_genomics_cells.tsv"))
mag_context <- read_tsv(file.path(output_dir, "tables", "mag_taxonomic_context.tsv"))
votu_groups <- read_tsv(file.path(output_dir, "tables", "votu_taxonomic_context_groups.tsv"))
votu_realms <- read_tsv(file.path(output_dir, "tables", "votu_taxonomic_context_realm_summary.tsv"))
votu_filter <- read_tsv(file.path(output_dir, "tables", "votu_taxonomic_context_filter_summary.tsv"))
registry <- read_tsv(file.path(output_dir, "candidate_figure_registry.tsv"))
checksums <- read_tsv(file.path(output_dir, "output_checksums.md5.tsv"))

expect(nrow(mds) == 12L && !anyDuplicated(mds$sample_title), "MDS contains 12 unique physical samples")
expect(all(table(mds$condition, mds$phase, mds$cycle) == 1L), "MDS preserves the 2 x 2 x 3 design")

expected_summary <- c(
  input_features = 1734019,
  retained_features = 361907,
  supported_features = 7703,
  supported_abs_logFC_1 = 7699,
  control_higher_fdr_features = 4006,
  phage_uv_higher_fdr_features = 3697,
  control_higher_fdr_abs_logFC_1_features = 4005,
  phage_uv_higher_fdr_abs_logFC_1_features = 3694,
  eligible_MAGs = 340,
  supported_MAGs = 175,
  control_higher_MAGs = 75,
  phage_uv_higher_MAGs = 100
)
observed_summary <- setNames(summary$value, summary$metric)
expect(identical(as.numeric(observed_summary[names(expected_summary)]), as.numeric(expected_summary)),
       "figure summary matches verified full-universe results")

expect(nrow(functional) == 8L, "functional panel retains all eight frozen categories")
expect(identical(functional$set_id[functional$supported], "SOS_response"),
       "SOS response is the only supported adjusted-condition category")
expect(abs(functional$FDR[functional$set_id == "SOS_response"] - 0.00206795469244894) < 1e-12,
       "SOS-response FDR is stable")

expect(nrow(top_mag) == 24L, "organism panel contains 12 MAGs per direction")
expect(all(top_mag$FDR < 0.05), "all displayed MAGs pass the declared BH threshold")
expect(all(table(top_mag$Direction) == 12L), "displayed MAG directions are balanced by construction")

expect(identical(funnel$features, c(361907L, 7699L, 7603L, 7141L, 6985L)),
       "recurrence selection funnel matches the predeclared sequential criteria")
direction_totals <- aggregate(features ~ higher_in, concordance, sum)
observed_direction_totals <- setNames(direction_totals$features, direction_totals$higher_in)
expect(identical(as.integer(observed_direction_totals[c("Control", "Phage-UV")]), c(3651L, 3334L)),
       "recurrent candidate directions match the verified result")
expect(nrow(heatmap_selection) == 24L && all(table(heatmap_selection$higher_in) == 12L),
       "heatmap contains 12 deterministically selected genes per direction")
expect(nrow(heatmap_cells) == 144L && all(table(heatmap_cells$feature_id) == 6L),
       "each selected gene contributes all six phase-by-cycle effects")
expect(all(heatmap_selection$FDR < 0.05 & abs(heatmap_selection$logFC) >= 1),
       "every heatmap gene passes the complete-universe effect criteria")
expect(all(heatmap_selection$n_samples_detected >= 6L & heatmap_selection$dominant_direction_cells >= 5L),
       "every heatmap gene passes detection and recurrence criteria")

expect(nrow(population_clusters) == 60L,
       "population-genomics strain panel spans five MAGs and twelve samples")
expect(nrow(population_summary) == 5L && all(population_summary$valid_pairs >= 10L) &&
         all(population_summary$observed_samples >= 6L),
       "population-genomics summary retains exactly the five coverage-qualified MAGs")
expect(nrow(propionicimonas) == 64L && sum(propionicimonas$diagonal) == 8L,
       "Propionicimonas panel is an eight-sample square matrix")
expect(nrow(model_diagnostics) == 8L && all(c("filtering", "dispersion") %in% model_diagnostics$panel),
       "model supplement records filtering and both-model dispersion summaries")
observed_interactions <- setNames(interaction_counts$supported_features, interaction_counts$coefficient)
expect(identical(
  as.integer(observed_interactions[c(
    "cycle2:conditiontreatment", "cycle3:conditiontreatment", "condition_cycle_omnibus"
  )]),
  c(1L, 11L, 357L)
), "interaction supplement matches the verified feature counts")
expect(nrow(functional_all) == 32L && sum(functional_all$supported) == 2L,
       "functional supplement retains the frozen 8 by 4 comparison family")
observed_mag_counts <- setNames(mag_counts$MAGs, paste(mag_counts$coefficient, mag_counts$Direction, sep = ":"))
expect(identical(
  as.integer(observed_mag_counts[c(
    "condition_adjusted:Down", "condition_adjusted:Up",
    "cycle2_interaction:Down", "cycle2_interaction:Up",
    "cycle3_interaction:Down", "cycle3_interaction:Up"
  )]),
  c(75L, 100L, 65L, 68L, 59L, 73L)
), "MAG supplement preserves all verified coefficient-by-direction counts")
expect(nrow(population_cells) == 720L,
       "population-genomics supplement contains five complete 12 by 12 display grids")

expect(nrow(mag_context) == 348L && sum(mag_context$eligible) == 340L,
       "MAG taxonomic context contains all dereplicated MAGs and the verified eligible set")
expect(sum(mag_context$de_state %in% c("Phage-UV higher", "Control higher")) == 175L &&
         sum(mag_context$de_state == "Phage-UV higher") == 100L &&
         sum(mag_context$de_state == "Control higher") == 75L,
       "MAG taxonomic context preserves verified adjusted-membrane coherence counts")
expected_votu_filter <- c(
  catalogue_rows = 82615L,
  miuvig_high_quality = 624L,
  high_quality_with_taxonomy = 615L,
  high_quality_with_taxonomy_and_viral_genes = 607L,
  taxonomy_groups = 45L
)
observed_votu_filter <- setNames(votu_filter$value, votu_filter$criterion)
expect(identical(
  as.integer(observed_votu_filter[names(expected_votu_filter)]),
  as.integer(expected_votu_filter)
), "vOTU taxonomic-context filter contract is stable")
expect(nrow(votu_groups) == 45L && sum(votu_groups$n_votus) == 607L,
       "vOTU cladogram contains 45 taxonomy groups representing 607 vOTUs")
expected_realms <- c(
  Duplodnaviria = 462L,
  Riboviria = 103L,
  Unclassified = 32L,
  Floreoviria = 6L,
  Varidnaviria = 4L
)
observed_realms <- setNames(votu_realms$n_votus, votu_realms$realm_display)
expect(identical(as.integer(observed_realms[names(expected_realms)]), as.integer(expected_realms)),
       "vOTU realm composition is stable and unclassified labels are combined")

expect(nrow(registry) == 11L && sum(registry$status == "candidate_unallocated") == 6L &&
         sum(registry$status == "supplementary_unallocated") == 5L,
       "registry contains six manuscript candidates and five supplementary candidates")
expect(identical(registry$artifact, c(
  "global-transcriptome-structure.pdf",
  "functional-organism-restructuring.pdf",
  "recurrent-gene-structure.pdf",
  "population-genomic-heterogeneity.pdf",
  "supplementary-model-diagnostics.pdf",
  "supplementary-cycle-interaction-landscape.pdf",
  "supplementary-functional-coefficients.pdf",
  "supplementary-mag-coherence.pdf",
  "supplementary-population-genomics.pdf",
  "mag-taxonomic-context.pdf",
  "votu-taxonomic-context.pdf"
)), "candidate registry contains the expected PDFs in build order")

for (i in seq_len(nrow(checksums))) {
  path <- file.path(output_dir, checksums$path[[i]])
  expect(file.exists(path), sprintf("checksummed artifact exists: %s", checksums$path[[i]]))
  expect(unname(tools::md5sum(path)) == checksums$md5[[i]],
         sprintf("checksum matches: %s", checksums$path[[i]]))
}

cat("Manuscript figure candidate tests passed.\n")
