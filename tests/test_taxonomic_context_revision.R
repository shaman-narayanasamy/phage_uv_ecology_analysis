#!/usr/bin/env Rscript
suppressPackageStartupMessages(library(data.table))
args <- commandArgs(trailingOnly = TRUE)
base <- "/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived"
output <- if (length(args)) args[[1L]] else file.path(base, "taxonomic_context_revision_2026-09-09-v2")
old <- file.path(base, "manuscript_figure_candidates")
unchanged <- c("trees/mag_taxonomic_context.nwk", "trees/votu_taxonomic_context.nwk",
               "tables/mag_taxonomic_context.tsv", "tables/mag_taxonomic_context_summary.tsv",
               "tables/votu_taxonomic_context_groups.tsv", "tables/votu_taxonomic_context_realm_summary.tsv",
               "tables/votu_taxonomic_context_filter_summary.tsv")
stopifnot(all(unname(tools::md5sum(file.path(output, unchanged))) == unname(tools::md5sum(file.path(old, unchanged)))))
profile <- fread(file.path(output, "tables/mag_family_community_profile.tsv"))
source_profile <- fread(file.path(base, "taxonomic_resolution_exploration/tables/family_top25_community_profile.tsv"))
comparison <- merge(profile, source_profile, by.x = c("sample_title", "family_display"),
                    by.y = c("sample_title", "display_category"), all = TRUE)
stopifnot(!anyNA(comparison$relative_abundance.x), !anyNA(comparison$relative_abundance.y),
          all(comparison$relative_abundance.x == comparison$relative_abundance.y),
          uniqueN(profile$sample_title) == 12L,
          all(abs(profile[, sum(relative_abundance), by = sample_title]$V1 - 1) < 1e-8))
key <- fread(file.path(output, "tables/mag_family_colour_key.tsv"))
source_key <- fread(file.path(base, "taxonomic_resolution_exploration/tables/family_microshades_colour_key.tsv"))
stopifnot(sum(source_key$category_type == "top25 named") == 25L,
          identical(key$family_display, source_key$display_category),
          identical(key$colour, source_key$colour))
layout <- fread(file.path(output, "tables/mag_taxonomic_context_layout.tsv"))
stopifnot(layout[element == "completeness", radial_order] == 1L,
          layout[element == "contamination", radial_order] == 2L)
inventory <- fread(file.path(output, "output_checksums.md5.tsv"))
stopifnot(all(file.info(file.path(output, inventory$path))$size == inventory$bytes),
          all(unname(tools::md5sum(file.path(output, inventory$path))) == inventory$md5))
cat("Taxonomic revision verified: top25 values and colours match Figure1; MAG/vOTU tables and trees unchanged; all checksums match.\n")
