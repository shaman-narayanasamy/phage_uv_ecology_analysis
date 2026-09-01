#!/usr/bin/env Rscript

root <- "/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/host_phage_network_review"
summary_path <- file.path(root, "tables", "host_phage_network_summary.tsv")
edge_path <- file.path(root, "tables", "deduplicated_host_phage_edges.tsv")
figure_path <- file.path(root, "figures", "host-phage-network-evidence-audit.pdf")
stopifnot(file.exists(summary_path), file.exists(edge_path), file.exists(figure_path))

summary <- read.delim(summary_path, sep = "\t", stringsAsFactors = FALSE)
edges <- read.delim(edge_path, sep = "\t", stringsAsFactors = FALSE)
value <- setNames(summary$value, summary$metric)

stopifnot(
  value[["raw_link_rows"]] == 148L,
  value[["exact_unique_rows"]] == 121L,
  value[["deduplicated_host_phage_pairs"]] == 86L,
  value[["linked_hosts"]] == 80L,
  value[["linked_phages"]] == 85L,
  value[["host_degree_two"]] == 6L,
  value[["shared_phages"]] == 1L,
  value[["linked_hosts_current_mag_supported"]] == 49L,
  value[["linked_phages_currently_annotated"]] == 12L,
  value[["linked_phages_passing_high_quality_classified_filter"]] == 0L,
  nrow(edges) == 86L,
  length(unique(edges$MAG_ID)) == 80L,
  length(unique(edges$phage_id)) == 85L,
  file.info(figure_path)$size > 10000L
)

message("Allocated Supplementary Figure S8 host-phage network verified.")
