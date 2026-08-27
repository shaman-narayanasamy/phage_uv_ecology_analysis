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
  "tables/mds_coordinates.tsv",
  "tables/figure_summary.tsv",
  "tables/functional_condition_panel.tsv",
  "tables/top_mag_condition_panel.tsv",
  "candidate_figure_registry.tsv",
  "output_checksums.md5.tsv"
)
required_paths <- file.path(output_dir, required)
expect(all(file.exists(required_paths)), "all candidate artifacts exist")
expect(all(file.info(required_paths)$size > 0), "all candidate artifacts are non-empty")

mds <- read_tsv(file.path(output_dir, "tables", "mds_coordinates.tsv"))
summary <- read_tsv(file.path(output_dir, "tables", "figure_summary.tsv"))
functional <- read_tsv(file.path(output_dir, "tables", "functional_condition_panel.tsv"))
top_mag <- read_tsv(file.path(output_dir, "tables", "top_mag_condition_panel.tsv"))
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
expect(nrow(registry) == 2L && all(registry$status == "candidate_unallocated"),
       "both PDFs remain unnumbered and unallocated")

for (i in seq_len(nrow(checksums))) {
  path <- file.path(output_dir, checksums$path[[i]])
  expect(file.exists(path), sprintf("checksummed artifact exists: %s", checksums$path[[i]]))
  expect(unname(tools::md5sum(path)) == checksums$md5[[i]],
         sprintf("checksum matches: %s", checksums$path[[i]]))
}

cat("Manuscript figure candidate tests passed.\n")
