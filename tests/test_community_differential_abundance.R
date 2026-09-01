#!/usr/bin/env Rscript

abort <- function(...) stop(sprintf(...), call. = FALSE)
expect <- function(value, message) if (!isTRUE(value)) abort("FAILED: %s", message)
read_tsv <- function(path) read.delim(
  path, sep = "\t", quote = "", comment.char = "", check.names = FALSE,
  stringsAsFactors = FALSE
)

args <- commandArgs(trailingOnly = TRUE)
output_dir <- if (length(args)) args[[1L]] else
  "/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/community_differential_abundance"

required <- c(
  "figures/community-differential-abundance.pdf",
  "tables/analysis_summary.tsv", "tables/community_restricted_permanova.tsv",
  "tables/community_pcoa.tsv", "tables/mag_deseq2_condition_only.tsv",
  "tables/mag_deseq2_phase_cycle_adjusted.tsv", "tables/mag_matched_clr.tsv",
  "tables/votu_deseq2_condition_only.tsv",
  "tables/votu_deseq2_phase_cycle_adjusted.tsv", "tables/votu_matched_clr.tsv",
  "README.md", "output_checksums.md5.tsv"
)
paths <- file.path(output_dir, required)
expect(all(file.exists(paths)), "all community differential-abundance artifacts exist")
expect(all(file.info(paths)$size > 0), "all artifacts are non-empty")

summary <- read_tsv(file.path(output_dir, "tables/analysis_summary.tsv"))
expect(nrow(summary) == 4L, "summary contains two models for both communities")
expect(setequal(summary$community, c("MAG", "vOTU")), "summary covers MAGs and vOTUs")
expect(all(grepl("confounded with membrane identity", summary$boundary, fixed = TRUE)),
       "all model summaries preserve the experimental-unit warning")
poster_mag <- summary[summary$community == "MAG" & summary$model == "poster_condition_only", ]
expect(nrow(poster_mag) == 1L && poster_mag$fdr05 == 0L,
       "condition-only MAG result reproduces the poster's null community result")

permanova <- read_tsv(file.path(output_dir, "tables/community_restricted_permanova.tsv"))
expect(nrow(permanova) == 2L && all(permanova$permutations == 64L),
       "paired PERMANOVA exhausts all 2^6 label swaps")
expect(all(permanova$exact_p >= 1 / 64 & permanova$exact_p <= 1),
       "paired PERMANOVA exact p-values are valid")

pcoa <- read_tsv(file.path(output_dir, "tables/community_pcoa.tsv"))
expect(nrow(pcoa) == 24L && all(table(pcoa$community) == 12L),
       "ordination retains 12 physical samples per community")

mag_adjusted <- read_tsv(file.path(output_dir, "tables/mag_deseq2_phase_cycle_adjusted.tsv"))
votu_adjusted <- read_tsv(file.path(output_dir, "tables/votu_deseq2_phase_cycle_adjusted.tsv"))
expect(length(unique(mag_adjusted$feature_id)) == nrow(mag_adjusted), "MAG features are unique")
expect(length(unique(votu_adjusted$feature_id)) == nrow(votu_adjusted), "vOTU features are unique")

for (file in c("mag_matched_clr.tsv", "votu_matched_clr.tsv")) {
  x <- read_tsv(file.path(output_dir, "tables", file))
  expect(all(x$matched_cells == 6L), sprintf("%s uses all six matched cells", file))
  expect(all(x$exact_signflip_p >= 1 / 64 & x$exact_signflip_p <= 1),
         sprintf("%s has valid exhaustive sign-flip p-values", file))
}

checksums <- read_tsv(file.path(output_dir, "output_checksums.md5.tsv"))
for (i in seq_len(nrow(checksums))) {
  path <- file.path(output_dir, checksums$path[[i]])
  expect(file.exists(path), sprintf("checksummed artifact exists: %s", checksums$path[[i]]))
  expect(unname(tools::md5sum(path)) == checksums$md5[[i]],
         sprintf("checksum matches: %s", checksums$path[[i]]))
}

cat("Community differential-abundance tests passed.\n")
