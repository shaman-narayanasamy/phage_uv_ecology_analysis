#!/usr/bin/env Rscript

args_all <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args_all, value = TRUE)
if (length(file_arg) != 1L) stop("Could not resolve this test file", call. = FALSE)
test_path <- normalizePath(sub("^--file=", "", file_arg), mustWork = TRUE)
repo_root <- normalizePath(file.path(dirname(test_path), ".."), mustWork = TRUE)
args <- commandArgs(trailingOnly = TRUE)
output_dir <- if (length(args)) normalizePath(args[[1L]], mustWork = TRUE) else
  "/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/16s_manuscript_integration"

required <- file.path(output_dir, c(
  "figures/16s-longitudinal-community-context.pdf",
  "figures/study-analysis-workflow.pdf",
  "tables/sample_contract_validation.tsv",
  "tables/longitudinal_turnover.tsv",
  "tables/within_cycle_phase_distance.tsv",
  "tables/16s_effect_size_audit.tsv",
  "tables/16s_family_top12_profile.tsv",
  "tables/16s_family_colour_key.tsv",
  "tables/workflow_node_registry.tsv",
  "tables/workflow_edge_registry.tsv",
  "tables/input_provenance.tsv",
  "output_checksums.md5.tsv"
))
stopifnot(all(file.exists(required)))

contract <- read.delim(file.path(output_dir, "tables/sample_contract_validation.tsv"), check.names = FALSE)
stopifnot(
  nrow(contract) == 12L,
  all(contract$present_in_canonical),
  all(contract$present_in_return),
  all(contract$fields_match),
  length(unique(contract$sample_title)) == 12L
)

turnover <- read.delim(file.path(output_dir, "tables/longitudinal_turnover.tsv"), check.names = FALSE)
stopifnot(
  nrow(turnover) == 8L,
  setequal(turnover$condition, c("control", "treatment")),
  setequal(turnover$phase, c("initial", "backflush")),
  setequal(turnover$transition, c("C1 to C2", "C2 to C3")),
  all(turnover$bray_curtis >= 0 & turnover$bray_curtis <= 1)
)
wide <- reshape(
  turnover[, c("condition", "phase", "transition", "bray_curtis")],
  idvar = c("condition", "phase"), timevar = "transition", direction = "wide"
)
stopifnot(all(wide[["bray_curtis.C2 to C3"]] < wide[["bray_curtis.C1 to C2"]]))

effect <- read.delim(file.path(output_dir, "tables/16s_effect_size_audit.tsv"), check.names = FALSE)
stopifnot(
  nrow(effect) == 6L,
  setequal(effect$metric, c("bray_curtis", "aitchison")),
  setequal(effect$term, c("cycle", "phase", "condition")),
  all(effect$inferential_status == "effect_size_only"),
  all(grepl("unrestricted permutations", effect$reason, fixed = TRUE))
)

profile <- read.delim(file.path(output_dir, "tables/16s_family_top12_profile.tsv"), check.names = FALSE)
profile_sums <- aggregate(relative_abundance ~ sample_title, profile, sum)
stopifnot(
  length(unique(profile$sample_title)) == 12L,
  max(abs(profile_sums$relative_abundance - 1)) < 1e-5,
  all(c("Other classified families", "Unclassified at family level") %in% profile$display_family)
)

colours <- read.delim(file.path(output_dir, "tables/16s_family_colour_key.tsv"), check.names = FALSE)
source(file.path(repo_root, "R", "figure_style.R"))
shared <- intersect(colours$display_family, names(phage_uv_family_colours))
stopifnot(
  length(shared) == nrow(colours),
  identical(
    unname(colours$colour[match(shared, colours$display_family)]),
    unname(phage_uv_family_colours[shared])
  )
)

nodes <- read.delim(file.path(output_dir, "tables/workflow_node_registry.tsv"), check.names = FALSE)
edges <- read.delim(file.path(output_dir, "tables/workflow_edge_registry.tsv"), check.names = FALSE)
stopifnot(
  nrow(nodes) == 10L,
  nrow(edges) == 9L,
  all(edges$from %in% nodes$node_id),
  all(edges$to %in% nodes$node_id),
  all(c("Study design", "Data layers", "Processing", "Evidence products") %in% nodes$stage)
)

pdfs <- required[grepl("[.]pdf$", required)]
stopifnot(all(file.info(pdfs)$size > 5000L))
for (pdf in pdfs) {
  con <- file(pdf, open = "rb")
  signature <- rawToChar(readBin(con, "raw", n = 5L))
  close(con)
  stopifnot(signature == "%PDF-")
}

checksums <- read.delim(file.path(output_dir, "output_checksums.md5.tsv"), check.names = FALSE)
for (i in seq_len(nrow(checksums))) {
  target <- file.path(output_dir, checksums$path[[i]])
  stopifnot(
    file.exists(target),
    unname(tools::md5sum(target)) == checksums$md5[[i]],
    file.info(target)$size == checksums$bytes[[i]]
  )
}

cat("Returned 16S manuscript integration and workflow figures verified.\n")
