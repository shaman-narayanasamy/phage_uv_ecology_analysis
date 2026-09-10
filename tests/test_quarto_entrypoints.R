#!/usr/bin/env Rscript

args_all <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args_all, value = TRUE)
if (length(file_arg) != 1L) {
  stop("Could not resolve this test file", call. = FALSE)
}

test_path <- normalizePath(sub("^--file=", "", file_arg), mustWork = TRUE)
repo_root <- normalizePath(file.path(dirname(test_path), ".."), mustWork = TRUE)
scripts_dir <- file.path(repo_root, "scripts")

expected <- sort(c(
  "build_16s_ena_manifests.qmd",
  "build_candidate_ecology_figures.qmd",
  "build_community_figure_one.qmd",
  "build_host_phage_network_figure.qmd",
  "build_mag_genomic_variation_dossiers.qmd",
  "build_manuscript_figure_candidates.qmd",
  "build_population_genomics_descriptive.qmd",
  "build_recurrent_gene_candidate.qmd",
  "build_remaining_manuscript_figures.qmd",
  "build_story_reorganized_figures.qmd",
  "build_sos_activity_candidates.qmd",
  "build_taxonomic_context_figures.qmd",
  "build_temporal_response_analysis.qmd",
  "build_uv_activity_candidates.qmd",
  "build_votu_replication_inputs.qmd",
  "build_workflow_metro.qmd",
  "check_mgnify_prjeb79569.qmd",
  "compare_taxonomic_timeseries_layouts.qmd",
  "evaluate_temporal_cluster_stability.qmd",
  "explore_taxonomic_resolution_figures.qmd",
  "integrate_16s_and_workflow.qmd",
  "interpret_full_transcriptome_de.qmd",
  "run_full_transcriptome_edger.qmd",
  "run_community_differential_abundance.qmd",
  "run_sos_edger_sensitivity.qmd"
))

observed <- sort(basename(list.files(
  scripts_dir,
  pattern = "[.]qmd$",
  full.names = TRUE
)))
stopifnot(identical(observed, expected))

documentation_paths <- c(
  file.path(repo_root, "README.md"),
  file.path(repo_root, "docs", "codex_context.md"),
  file.path(repo_root, "notes", "handoff-2026-08-27-full-manuscript-draft.md")
)
documentation_text <- vapply(
  documentation_paths,
  function(path) paste(readLines(path, warn = FALSE), collapse = "\n"),
  character(1L)
)
stopifnot(
  all(grepl("25", documentation_text, fixed = TRUE)),
  !any(grepl("20 standalone", documentation_text, fixed = TRUE)),
  !any(grepl("all 20 no-execute", documentation_text, fixed = TRUE))
)

standalone_r <- list.files(scripts_dir, pattern = "[.]R$", full.names = TRUE)
stopifnot(length(standalone_r) == 0L)

code_manifest <- read.delim(
  file.path(repo_root, "manifests", "code_manifest.tsv"),
  sep = "\t",
  quote = "",
  check.names = FALSE,
  stringsAsFactors = FALSE
)
qmd_rows <- code_manifest[grepl("^scripts/.*[.]qmd$", code_manifest$path), ]
stopifnot(
  identical(sort(basename(qmd_rows$path)), expected),
  all(grepl("^Quarto;knitr;", qmd_rows$environment)),
  any(code_manifest$path == "scripts/run_qmd.sh"),
  any(code_manifest$path == "tests/test_quarto_entrypoints.R")
)

if (!requireNamespace("knitr", quietly = TRUE)) {
  stop("The knitr package is required for Quarto entrypoint validation", call. = FALSE)
}

for (notebook_name in expected) {
  notebook <- file.path(scripts_dir, notebook_name)
  lines <- readLines(notebook, warn = FALSE)

  stopifnot(
    length(lines) > 10L,
    identical(lines[[1L]], "---"),
    sum(lines == "---") >= 2L,
    any(grepl("^execute:$", lines)),
    any(grepl("^[[:space:]]+enabled: false$", lines)),
    sum(grepl("^```[{]r.*[}]$", lines)) == 1L
  )

  extracted <- tempfile(fileext = ".R")
  on.exit(unlink(extracted), add = TRUE)
  knitr::purl(notebook, output = extracted, quiet = TRUE)
  stopifnot(file.exists(extracted), file.info(extracted)$size > 0L)
  unlink(extracted)
}

runner <- file.path(scripts_dir, "run_qmd.sh")
stopifnot(file.exists(runner), file.access(runner, mode = 1L) == 0L)

cat(sprintf("Validated %d canonical Quarto entrypoints and their runner.\n", length(expected)))
