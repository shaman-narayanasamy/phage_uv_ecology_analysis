#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(data.table))

full_de_notebook <- normalizePath("scripts/run_full_transcriptome_edger.qmd")
full_de_source <- tempfile("run-full-transcriptome-edger-", fileext = ".R")
old_notebook_path <- Sys.getenv("PHAGE_UV_NOTEBOOK_PATH")
Sys.setenv(PHAGE_UV_NOTEBOOK_PATH = full_de_notebook)
tryCatch({
  knitr::purl(full_de_notebook, output = full_de_source, quiet = TRUE)
  source(full_de_source, local = .GlobalEnv)
}, finally = {
  unlink(full_de_source)
  if (nzchar(old_notebook_path)) {
    Sys.setenv(PHAGE_UV_NOTEBOOK_PATH = old_notebook_path)
  } else {
    Sys.unsetenv("PHAGE_UV_NOTEBOOK_PATH")
  }
})

expect_true <- function(value, message) {
  if (!isTRUE(value)) stop(message, call. = FALSE)
}

expect_error <- function(expression, pattern) {
  error <- tryCatch({
    force(expression)
    NULL
  }, error = identity)
  if (is.null(error) || !grepl(pattern, conditionMessage(error))) {
    stop(sprintf("Expected error matching %s", pattern), call. = FALSE)
  }
}

tmp <- tempfile("full-de-test-")
dir.create(tmp)
on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

fixture <- data.table(
  contig = c("CI1_MAGScoT_cleanbin_000001_contig_1", "unbinned_contig_2"),
  start = c(1L, 50L),
  end = c(40L, 100L),
  gene_id = c("GENE_1", "GENE_2"),
  score = 0L,
  strand = c("+", "-"),
  read_count = c(7L, 11L),
  covered_bases = c(30L, 45L),
  gene_length = c(39L, 50L),
  covered_fraction = c(30 / 39, 0.9)
)
fixture_path <- file.path(tmp, "CI1__MT__ERR13801948_metatranscriptomics.tsv")
fwrite(fixture, fixture_path, sep = "\t", col.names = FALSE)

read_fixture <- read_count_file(fixture_path)
expect_true(nrow(read_fixture$data) == 2L, "Headerless parser dropped the first feature")
expect_true(read_fixture$data$gene_id[[1]] == "GENE_1", "First feature was not preserved")
expect_true(read_fixture$duplicate_record_count == 0L, "Unexpected duplicate count")
expect_true(
  read_fixture$data$feature_id[[1]] == "CI1_MAGScoT_cleanbin_000001_contig_1|1|40|GENE_1|+",
  "Feature ID is not traceable"
)
expect_true(
  derive_mag_id(read_fixture$data$contig)[[1]] == "CI1_MAGScoT_cleanbin_000001",
  "MAG ID extraction failed"
)
expect_true(is.na(derive_mag_id(read_fixture$data$contig)[[2]]), "Unbinned contig received a MAG ID")

annotation_features <- data.table(
  feature_id = c("feature_a", "feature_b", "feature_c"),
  MAG_ID = c("MAG_A", "MAG_B", NA_character_),
  gene_id = c("SHARED_GENE", "SHARED_GENE", "NON_MAG_GENE")
)
annotation_fixture <- data.table(
  MAG_ID = c("MAG_A", "MAG_B"),
  gene_id = c("SHARED_GENE", "SHARED_GENE"),
  gene_symbol = c("alpha", "beta"),
  product = c("product A", "product B"),
  feature_type = "cds",
  dbxrefs = c("DB:1", "DB:2")
)
annotation_path <- file.path(tmp, "annotations.tsv")
fwrite(annotation_fixture, annotation_path, sep = "\t")
joined_annotation <- read_annotations(annotation_path, annotation_features)
expect_true(
  joined_annotation[feature_id == "feature_a", annotation] == "product A" &&
    joined_annotation[feature_id == "feature_b", annotation] == "product B",
  "MAG_ID + gene_id annotation join crossed MAGs"
)
expect_true(
  joined_annotation[feature_id == "feature_c", annotation_match_status] == "unmatched_non_MAG_feature",
  "Non-MAG annotation status is wrong"
)

fwrite(rbind(fixture, fixture[1]), fixture_path, sep = "\t", col.names = FALSE)
deduplicated <- read_count_file(fixture_path)
expect_true(nrow(deduplicated$data) == 2L, "Exact duplicate was not removed")
expect_true(deduplicated$duplicate_record_count == 1L, "Exact duplicate audit is wrong")

conflict <- copy(fixture[1])
conflict[, covered_bases := covered_bases + 1L]
fwrite(rbind(fixture, conflict), fixture_path, sep = "\t", col.names = FALSE)
expect_error(read_count_file(fixture_path), "conflicting duplicate")

metadata <- data.table(
  sample_title = sprintf("sample_%02d", 1:12),
  condition = rep(c("control", "treatment"), 6),
  phase = rep(rep(c("initial", "backflush"), each = 2), 3),
  cycle = rep(1:3, each = 4)
)
metadata[, condition := factor(condition, levels = c("control", "treatment"))]
metadata[, phase := factor(phase, levels = c("initial", "backflush"))]
metadata[, cycle := factor(cycle, levels = 1:3)]
designs <- build_designs(metadata)
expect_true(qr(designs$main)$rank == ncol(designs$main), "Main design is rank deficient")
expect_true(qr(designs$interaction)$rank == ncol(designs$interaction), "Interaction design is rank deficient")
expect_true(
  identical(designs$interaction_coefficients, c("cycle2:conditiontreatment", "cycle3:conditiontreatment")),
  "Interaction coefficients changed"
)

# Small end-to-end run: 23 technical runs must become 12 physical samples.
counts_dir <- file.path(tmp, "counts")
output_dir <- file.path(tmp, "output")
dir.create(counts_dir)
set.seed(22)
e2e_metadata <- data.table(
  sample_title = c(
    "control_initial_cycle1", "treatment_initial_cycle1",
    "control_initial_cycle2", "treatment_initial_cycle2",
    "control_initial_cycle3", "treatment_initial_cycle3",
    "control_backflush_cycle1", "treatment_backflush_cycle1",
    "control_backflush_cycle2", "treatment_backflush_cycle2",
    "control_backflush_cycle3", "treatment_backflush_cycle3"
  ),
  condition = rep(c("control", "treatment"), 6),
  phase = c(rep("initial", 6), rep("backflush", 6)),
  cycle = rep(1:3, 2, each = 2),
  analysis_group = rep(c("control_cycle1", "treatment_cycle1", "control_cycle2", "treatment_cycle2", "control_cycle3", "treatment_cycle3"), 2)
)
run_counter <- 1L
expected_collapsed <- numeric(nrow(e2e_metadata))
run_lists <- vector("list", nrow(e2e_metadata))
for (sample_index in seq_len(nrow(e2e_metadata))) {
  n_runs <- if (sample_index == nrow(e2e_metadata)) 1L else 2L
  accessions <- sprintf("ERR%08d", seq.int(run_counter, length.out = n_runs))
  run_counter <- run_counter + n_runs
  run_lists[[sample_index]] <- accessions
  for (run_index in seq_along(accessions)) {
    n_features <- 60L
    run_fixture <- data.table(
      contig = sprintf("CI1_MAGScoT_cleanbin_%06d_contig_%d", rep(1:3, each = 20), 1:n_features),
      start = seq.int(1L, by = 100L, length.out = n_features),
      end = seq.int(90L, by = 100L, length.out = n_features),
      gene_id = sprintf("GENE_%03d", 1:n_features),
      score = 0L,
      strand = rep(c("+", "-"), length.out = n_features),
      read_count = rpois(n_features, lambda = 20 + 3 * (e2e_metadata$condition[[sample_index]] == "treatment")),
      covered_bases = 80L,
      gene_length = 89L,
      covered_fraction = 80 / 89
    )
    expected_collapsed[[sample_index]] <- expected_collapsed[[sample_index]] + sum(run_fixture$read_count)
    file_name <- sprintf(
      "S%02d__MT__%s_metatranscriptomics.tsv", sample_index, accessions[[run_index]]
    )
    fwrite(run_fixture, file.path(counts_dir, file_name), sep = "\t", col.names = FALSE)
  }
}
e2e_metadata[, metatranscriptome_run_accessions := vapply(run_lists, paste, character(1), collapse = ";")]
metadata_path <- file.path(tmp, "sample_metadata.tsv")
fwrite(e2e_metadata, metadata_path, sep = "\t")
run_workflow(list(
  metadata = metadata_path,
  counts_dir = counts_dir,
  output_dir = output_dir,
  annotations = NA_character_,
  min_count = 10L,
  min_total_count = 15L,
  overwrite = FALSE
))
library_audit <- fread(file.path(output_dir, "tables", "library_sizes_and_normalization.tsv"))
expect_true(
  identical(as.numeric(library_audit$collapsed_library_size_before_filtering), expected_collapsed),
  "Pre-filter collapsed library sizes are incorrect"
)
raw_matrix <- fread(file.path(output_dir, "tables", "collapsed_raw_count_matrix.tsv"))
expect_true(nrow(raw_matrix) == 60L, "Raw whole-transcriptome matrix is incomplete")
expect_true(
  identical(names(raw_matrix)[-(1:4)], e2e_metadata$sample_title),
  "Raw matrix does not contain the 12 physical samples in metadata order"
)
condition_output <- fread(file.path(output_dir, "tables", "de_condition_adjusted.tsv"))
expect_true(
  nrow(condition_output) == 60L,
  "End-to-end condition result does not contain the complete filtered universe"
)
expect_true(!any(startsWith(names(condition_output), "i.")), "Result contains redundant join columns")
expect_true(
  nrow(fread(file.path(output_dir, "tables", "deterministic_result_summary.tsv"))) == 4L,
  "Interaction coefficients were not summarized separately"
)
diagnostics <- fread(file.path(output_dir, "tables", "model_fit_diagnostics.tsv"))
expect_true(
  setequal(diagnostics$model, c("main", "condition_cycle_interaction")),
  "Numeric model-fit diagnostics are incomplete"
)
expect_true(
  !anyNA(diagnostics[metric %in% c("ql_posterior_variance", "residual_df_after_zero_adjustment"), minimum]),
  "Version-aware edgeR diagnostics contain missing values"
)
expect_true(file.exists(file.path(output_dir, "EXPERIMENTAL_UNIT_CAVEAT.txt")), "Caveat is missing")
label_test <- place_mds_labels(c(0, 0.02, 1), c(0, 0.02, 1))
expect_true(uniqueN(label_test) == 3L, "Deterministic MDS label placement produced overlapping anchors")

cat("test_full_transcriptome_edger.R: PASS\n")
