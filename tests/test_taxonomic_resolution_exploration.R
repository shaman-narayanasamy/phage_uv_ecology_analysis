#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
output_dir <- if (length(args)) args[[1L]] else file.path(
  "/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569",
  "derived",
  "taxonomic_resolution_exploration"
)

expect <- function(condition, message) {
  if (!isTRUE(condition)) stop(message, call. = FALSE)
}

required_pdfs <- file.path(output_dir, "figures", c(
  "family-top25-stacked-microshades.pdf",
  "genus-top25-stacked-microshades.pdf",
  "species-top25-stacked-microshades.pdf",
  "taxonomic-rank-retention.pdf",
  "family-top25-heat-tree-timeseries.pdf"
))
expect(all(file.exists(required_pdfs)), "all five exploration PDFs exist")
expect(all(file.info(required_pdfs)$size > 5000), "all exploration PDFs are non-empty")

retention <- read.delim(
  file.path(output_dir, "tables", "rank_information_retention.tsv"),
  sep = "\t", check.names = FALSE, stringsAsFactors = FALSE
)
expected_ranks <- c("phylum", "class", "order", "family", "genus", "species")
expect(identical(as.character(retention$rank), expected_ranks), "rank audit follows taxonomic depth")

focus <- retention[match(c("family", "genus", "species"), retention$rank), ]
expect(all(abs(focus$unclassified_mean - c(
  0.0827307353243435, 0.266943672100078, 0.530922592400567
)) < 1e-10), "unclassified abundance increases at the verified family-genus-species rates")
expect(all(abs(focus$unnamed_at_rank_mean - c(
  0.471931159219105, 0.585799492206385, 0.705876888362379
)) < 1e-10), "top-25 unnamed fractions match the verified resolution loss")
expect(all(diff(focus$unnamed_at_rank_mean) > 0), "resolution loss increases from family to species")
expect(all(focus$hierarchical_global_gray_mean < focus$unnamed_at_rank_mean),
       "phylum-hued microshades remainders reduce literal global grey without changing information loss")

for (rank in c("family", "genus", "species")) {
  profile <- read.delim(
    file.path(output_dir, "tables", paste0(rank, "_top25_community_profile.tsv")),
    sep = "\t", check.names = FALSE, stringsAsFactors = FALSE
  )
  sums <- aggregate(relative_abundance ~ sample_title, profile, sum)
  expect(nrow(sums) == 12L && all(abs(sums$relative_abundance - 1) < 1e-12),
         paste(rank, "profiles contain 12 complete compositions"))
  positions <- unique(profile[, c("condition", "sample_label")])
  expect(all(table(positions$sample_label, positions$condition) == 1L),
         paste(rank, "profiles share aligned cycle-phase positions"))

  colour_key <- read.delim(
    file.path(output_dir, "tables", paste0(rank, "_microshades_colour_key.tsv")),
    sep = "\t", check.names = FALSE, stringsAsFactors = FALSE
  )
  expect(sum(colour_key$category_type == "top25 named") == 25L,
         paste(rank, "colour key contains 25 named taxa"))
  expect(all(grepl("^#[0-9A-Fa-f]{6}$", colour_key$colour)),
         paste(rank, "colour key contains valid hexadecimal colours"))
}

checksums <- read.delim(
  file.path(output_dir, "output_checksums.md5.tsv"),
  sep = "\t", check.names = FALSE, stringsAsFactors = FALSE
)
observed <- unname(tools::md5sum(file.path(output_dir, checksums$path)))
expect(identical(observed, checksums$md5), "exploration output checksum inventory is current")

cat("Taxonomic-resolution exploration tests passed.\n")
