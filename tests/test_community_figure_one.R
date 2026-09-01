#!/usr/bin/env Rscript

abort <- function(...) stop(sprintf(...), call. = FALSE)
expect <- function(value, message) if (!isTRUE(value)) abort("FAILED: %s", message)
read_tsv <- function(path) read.delim(
  path, sep = "\t", quote = "", comment.char = "", check.names = FALSE,
  stringsAsFactors = FALSE
)

args <- commandArgs(trailingOnly = TRUE)
output_dir <- if (length(args)) args[[1L]] else
  "/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/community_figure_one"

required <- c(
  "figures/community-structure-figure-one.pdf",
  "tables/figure_one_panel_registry.tsv",
  "tables/figure_one_statistics.tsv",
  "tables/input_provenance.tsv",
  "output_checksums.md5.tsv"
)
paths <- file.path(output_dir, required)
expect(all(file.exists(paths)), "all Figure 1 artifacts exist")
expect(all(file.info(paths)$size > 0), "all Figure 1 artifacts are non-empty")

panels <- read_tsv(file.path(output_dir, "tables/figure_one_panel_registry.tsv"))
expect(identical(panels$panel, LETTERS[1:5]), "Figure 1 contains panels A-E")
expect(all(panels$status == "allocated_main_figure_1"), "all panels are allocated to main Figure 1")

stats <- read_tsv(file.path(output_dir, "tables/figure_one_statistics.tsv"))
expect(setequal(stats$community, c("MAG", "vOTU")), "statistics cover microbial and phage communities")
mag <- stats[stats$community == "MAG", ]
votu <- stats[stats$community == "vOTU", ]
expect(isTRUE(all.equal(mag$exact_p, 0.125)), "MAG paired Bray-Curtis exact p-value is stable")
expect(isTRUE(all.equal(votu$exact_p, 0.0625)), "vOTU paired Bray-Curtis exact p-value is stable")
expect(mag$fdr05 == 1L && votu$fdr05 == 0L, "adjusted differential-abundance counts are stable")
expect(mag$matched_fdr05 == 0L && votu$matched_fdr05 == 0L, "matched CLR results remain null after FDR")

checksums <- read_tsv(file.path(output_dir, "output_checksums.md5.tsv"))
for (i in seq_len(nrow(checksums))) {
  path <- file.path(output_dir, checksums$path[[i]])
  expect(file.exists(path), sprintf("checksummed artifact exists: %s", checksums$path[[i]]))
  expect(unname(tools::md5sum(path)) == checksums$md5[[i]],
         sprintf("checksum matches: %s", checksums$path[[i]]))
}

cat("Community Figure 1 tests passed.\n")
