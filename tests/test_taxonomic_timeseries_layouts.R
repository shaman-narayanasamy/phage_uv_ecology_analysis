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
  "/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/taxonomic_timeseries_layout_comparison"
}

required <- c(
  "figures/mag-taxonomy-family-bars.pdf",
  "figures/mag-taxonomy-family-area.pdf",
  "figures/votu-taxonomy-realm-bars.pdf",
  "figures/votu-taxonomy-realm-area.pdf",
  "tables/mag_family_top25_profile.tsv",
  "tables/votu_realm_profile.tsv",
  "tables/votu_realm_colour_key.tsv",
  "tables/votu_profile_summary.tsv",
  "layout_comparison_registry.tsv",
  "output_checksums.md5.tsv"
)
paths <- file.path(output_dir, required)
expect(all(file.exists(paths)), "all taxonomic layout artifacts exist")
expect(all(file.info(paths)$size > 0L), "all taxonomic layout artifacts are non-empty")
expect(length(Sys.glob(file.path(dirname(output_dir), ".taxonomic-layout-staging-*"))) == 0L,
       "builder leaves no hidden staging directories")

mag <- read_tsv(file.path(output_dir, "tables", "mag_family_top25_profile.tsv"))
votu <- read_tsv(file.path(output_dir, "tables", "votu_realm_profile.tsv"))
colours <- read_tsv(file.path(output_dir, "tables", "votu_realm_colour_key.tsv"))
summary <- read_tsv(file.path(output_dir, "tables", "votu_profile_summary.tsv"))
registry <- read_tsv(file.path(output_dir, "layout_comparison_registry.tsv"))
checksums <- read_tsv(file.path(output_dir, "output_checksums.md5.tsv"))

expect(length(unique(mag$sample_title)) == 12L, "MAG profile retains 12 physical samples")
mag_sums <- aggregate(relative_abundance ~ sample_title, mag, sum)
expect(all(abs(mag_sums$relative_abundance - 1) < 1e-10), "MAG profiles sum to one")
expect(length(unique(mag$display_category)) > 25L,
       "MAG profile contains named families and phylum-aware remainder categories")

expect(length(unique(votu$sample_title)) == 12L, "vOTU profile retains 12 physical samples")
votu_sums <- aggregate(relative_abundance ~ sample_title, votu, sum)
expect(all(abs(votu_sums$relative_abundance - 1) < 1e-10), "vOTU profiles sum to one")
expect(setequal(unique(votu$realm), colours$realm), "vOTU realm profile and colour key agree")
expect(all(votu$reads >= 0) && sum(votu$reads) > 0, "vOTU profiles contain mapped reads")

summary_values <- setNames(summary$value, summary$metric)
expect(summary_values[["selected_votus"]] == 607L, "profile uses the verified 607-vOTU set")
expect(summary_values[["physical_samples"]] == 12L, "profile summary records 12 samples")
expect(summary_values[["viral_realms"]] == length(unique(votu$realm)),
       "profile summary records the displayed realm count")

expect(nrow(registry) == 4L, "registry contains the four requested comparison PDFs")
expect(setequal(registry$profile_geometry, c("stacked bars", "stacked area")),
       "both profile geometries are represented")
expect(setequal(registry$organism_layer, c("MAG", "vOTU")),
       "both cellular and viral taxonomy layers are represented")
expect(all(registry$review_status[registry$profile_geometry == "stacked bars"] == "recommended") &&
         all(registry$review_status[registry$profile_geometry == "stacked area"] == "comparison_only"),
       "review recommendation favours discrete stacked bars")

for (i in seq_len(nrow(checksums))) {
  path <- file.path(output_dir, checksums$path[[i]])
  expect(file.exists(path), sprintf("checksummed artifact exists: %s", checksums$path[[i]]))
  expect(unname(tools::md5sum(path)) == checksums$md5[[i]],
         sprintf("checksum matches: %s", checksums$path[[i]]))
}

cat("Taxonomic time-series layout tests passed.\n")
