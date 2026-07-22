#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(data.table)
  library(ggplot2)
  library(ape)
  library(ggtree)
})

args <- commandArgs(trailingOnly = TRUE)
data_root <- if (length(args) >= 1) args[[1]] else Sys.getenv(
  "PHAGE_UV_DATA_ROOT",
  "/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569"
)
out_dir <- if (length(args) >= 2) args[[2]] else file.path(data_root, "derived", "poster_replication")

tables_dir <- file.path(out_dir, "tables")
figures_dir <- file.path(out_dir, "figures")
trees_dir <- file.path(out_dir, "trees")
dir.create(tables_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(figures_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(trees_dir, recursive = TRUE, showWarnings = FALSE)

path <- function(...) file.path(data_root, ...)
required <- c(
  path("viromics/annotation/PRJEB79569_vOTUs/vclust_catalogue/checkv/quality_summary.tsv"),
  path("viromics/annotation/PRJEB79569_vOTUs/vclust_catalogue/cenotetaker3/output/output_virus_summary.tsv"),
  path("viromics/votu_clustering/cluster_summary.tsv"),
  path("community_uv_response/uv_signature_mag_summary.tsv"),
  path("community_uv_response/uv_signature_entity_summary.tsv")
)
missing <- required[!file.exists(required)]
if (length(missing) > 0) {
  stop("Missing required input(s):\n", paste(missing, collapse = "\n"), call. = FALSE)
}

clean_taxon <- function(x, rank = NA_character_) {
  x <- trimws(x)
  x[x == "" | is.na(x)] <- NA_character_
  x <- sub("^-_", "", x)
  prefix <- rep(ifelse(is.na(rank), "taxon", substr(rank, 1, 1)), length(x))
  needs_prefix <- !is.na(x) & !grepl("^[a-z]_", x)
  x[needs_prefix] <- paste0(prefix[needs_prefix], "_", x[needs_prefix])
  x <- gsub("[^A-Za-z0-9_.-]+", "_", x)
  x
}

newick_label <- function(x) {
  x <- gsub("[^A-Za-z0-9_.-]+", "_", x)
  x <- gsub("^_+|_+$", "", x)
  ifelse(is.na(x) | x == "", "unknown", x)
}

children <- new.env(parent = emptyenv())
add_child <- function(parent, child) {
  current <- if (exists(parent, envir = children, inherits = FALSE)) get(parent, envir = children) else character()
  if (!(child %in% current)) {
    assign(parent, c(current, child), envir = children)
  }
}

to_newick <- function(node) {
  kids <- if (exists(node, envir = children, inherits = FALSE)) get(node, envir = children) else character()
  label <- newick_label(node)
  if (length(kids) == 0) {
    return(label)
  }
  paste0("(", paste(vapply(kids, to_newick, character(1)), collapse = ","), ")", label)
}

rank_names <- c("domain", "realm", "kingdom", "phylum", "class", "order", "family", "subfamily", "genus", "species")

message("Reading vOTU quality, annotation, and clustering tables...")
checkv <- fread(required[[1]], select = c(
  "contig_id", "contig_length", "gene_count", "viral_genes", "host_genes",
  "checkv_quality", "miuvig_quality", "completeness", "contamination"
))
cenote <- fread(required[[2]], select = c(
  "input_name", "organism", "virus_seq_length", "virion_hallmark_count",
  "rep_hallmark_count", "RDRP_hallmark_count", "taxonomy_hierarchy"
))
setnames(cenote, "input_name", "contig_id")
clusters <- fread(required[[3]], select = c("representative", "n_members", "sources"))

votu <- merge(cenote, checkv, by = "contig_id", all.x = TRUE)
votu <- merge(votu, clusters, by.x = "contig_id", by.y = "representative", all.x = TRUE)
votu[, n_members := fifelse(is.na(n_members), 1L, n_members)]
votu[, has_taxonomy := !is.na(taxonomy_hierarchy) & taxonomy_hierarchy != ""]
votu[, is_high_quality := miuvig_quality == "High-quality"]

fwrite(votu, file.path(tables_dir, "votu_catalogue_summary.tsv"), sep = "\t")

quality_summary <- votu[, .(
  n_votus = .N,
  n_cluster_members = sum(n_members, na.rm = TRUE),
  n_with_taxonomy = sum(has_taxonomy, na.rm = TRUE),
  median_length = median(contig_length, na.rm = TRUE),
  median_completeness = median(completeness, na.rm = TRUE)
), by = .(miuvig_quality, checkv_quality)][order(-n_votus)]
fwrite(quality_summary, file.path(tables_dir, "votu_quality_summary.tsv"), sep = "\t")

tax_split <- tstrsplit(votu$taxonomy_hierarchy, ";", fixed = TRUE, fill = NA_character_)
for (i in seq_along(rank_names)) {
  votu[, (rank_names[[i]]) := if (i <= length(tax_split)) clean_taxon(tax_split[[i]], rank_names[[i]]) else NA_character_]
}

tax_groups <- votu[
  is_high_quality == TRUE & has_taxonomy == TRUE,
  .(
    n_votus = .N,
    n_cluster_members = sum(n_members, na.rm = TRUE),
    median_length = median(contig_length, na.rm = TRUE),
    median_completeness = median(completeness, na.rm = TRUE),
    virion_hallmarks = sum(virion_hallmark_count, na.rm = TRUE),
    replication_hallmarks = sum(rep_hallmark_count, na.rm = TRUE),
    rdrp_hallmarks = sum(RDRP_hallmark_count, na.rm = TRUE)
  ),
  by = c("taxonomy_hierarchy", rank_names)
][order(-n_votus)]
tax_groups[, vOTU_group := sprintf("vOTU_group_%03d", seq_len(.N))]
setcolorder(tax_groups, c("vOTU_group", "taxonomy_hierarchy", rank_names, setdiff(names(tax_groups), c("vOTU_group", "taxonomy_hierarchy", rank_names))))
fwrite(tax_groups, file.path(tables_dir, "votu_high_quality_taxonomy_groups.tsv"), sep = "\t")

realm_summary <- tax_groups[, .(
  n_taxonomy_groups = .N,
  n_votus = sum(n_votus),
  n_cluster_members = sum(n_cluster_members)
), by = realm][order(-n_votus)]
fwrite(realm_summary, file.path(tables_dir, "votu_high_quality_realm_summary.tsv"), sep = "\t")

for (i in seq_len(nrow(tax_groups))) {
  row <- tax_groups[i]
  lineage <- unlist(row[, ..rank_names], use.names = FALSE)
  lineage <- lineage[!is.na(lineage) & lineage != ""]
  leaf <- row$vOTU_group
  parent <- "Viruses"
  for (taxon in lineage) {
    child <- paste(parent, taxon, sep = "|")
    add_child(parent, child)
    parent <- child
  }
  add_child(parent, leaf)
}

lineage_lookup <- tax_groups[, c("vOTU_group", rank_names, "n_votus", "n_cluster_members"), with = FALSE]
lineage_lookup[, display_taxon := apply(.SD, 1, function(values) {
  values <- values[!is.na(values) & values != ""]
  if (length(values) == 0) {
    return("unclassified")
  }
  sub("^[a-z]_", "", tail(values, 1))
}), .SDcols = rank_names]
lineage_lookup[, display_label := sprintf("%s (n=%s)", display_taxon, n_votus)]
fwrite(lineage_lookup, file.path(tables_dir, "votu_taxonomy_tree_tip_metadata.tsv"), sep = "\t")

tree_text <- paste0(to_newick("Viruses"), ";")
writeLines(tree_text, file.path(trees_dir, "votu_high_quality_taxonomy_tree.nwk"))
tree <- read.tree(text = tree_text)

tip_meta <- data.frame(label = lineage_lookup$vOTU_group, as.data.frame(lineage_lookup), check.names = FALSE)
rownames(tip_meta) <- tip_meta$vOTU_group
tree_plot <- ggtree(tree, layout = "daylight") %<+% tip_meta +
  geom_tippoint(aes(size = n_votus, color = realm), alpha = 0.9) +
  geom_tiplab(aes(label = display_label), size = 2.2, align = FALSE, linesize = 0.15) +
  scale_size_continuous(name = "vOTUs", range = c(2, 8)) +
  labs(color = "Realm", title = "High-quality vOTU taxonomy groups") +
  theme(legend.position = "right", plot.margin = margin(60, 180, 60, 180))

ggsave(file.path(figures_dir, "votu_high_quality_taxonomy_tree.png"), tree_plot, width = 20, height = 16, dpi = 300)
ggsave(file.path(figures_dir, "votu_high_quality_taxonomy_tree.pdf"), tree_plot, width = 20, height = 16)

quality_plot <- ggplot(quality_summary, aes(x = reorder(miuvig_quality, n_votus), y = n_votus, fill = miuvig_quality)) +
  geom_col(width = 0.72, color = "grey20", linewidth = 0.15) +
  coord_flip() +
  guides(fill = "none") +
  labs(x = NULL, y = "vOTUs", title = "vOTU quality distribution") +
  theme_minimal(base_size = 12)
ggsave(file.path(figures_dir, "votu_quality_distribution.png"), quality_plot, width = 8, height = 5, dpi = 300)
ggsave(file.path(figures_dir, "votu_quality_distribution.pdf"), quality_plot, width = 8, height = 5)

realm_plot <- ggplot(realm_summary[!is.na(realm)], aes(x = reorder(realm, n_votus), y = n_votus, fill = realm)) +
  geom_col(width = 0.72, color = "grey20", linewidth = 0.15) +
  coord_flip() +
  guides(fill = "none") +
  labs(x = NULL, y = "High-quality vOTUs", title = "High-quality vOTU taxonomy by realm") +
  theme_minimal(base_size = 12)
ggsave(file.path(figures_dir, "votu_high_quality_realm_summary.png"), realm_plot, width = 8, height = 5, dpi = 300)
ggsave(file.path(figures_dir, "votu_high_quality_realm_summary.pdf"), realm_plot, width = 8, height = 5)

uv_mag <- fread(required[[4]])
uv_entity <- fread(required[[5]])
uv_mag_summary <- uv_mag[, .(
  n_signature_gene_rows = sum(n_signature_genes, na.rm = TRUE),
  n_unique_signature_symbols = sum(n_unique_signature_symbols, na.rm = TRUE),
  n_categories = uniqueN(signature_category)
), by = MAG_ID][order(-n_unique_signature_symbols, -n_signature_gene_rows)]
uv_category_summary <- uv_entity[, .(
  n_entities = uniqueN(entity_id),
  n_mags = uniqueN(MAG_ID),
  n_signature_gene_rows = sum(n_signature_genes, na.rm = TRUE),
  n_unique_signature_symbols = sum(n_unique_signature_symbols, na.rm = TRUE)
), by = .(signature_tier, signature_category)][order(signature_tier, -n_unique_signature_symbols)]
fwrite(uv_mag_summary, file.path(tables_dir, "uv_signature_mag_rollup.tsv"), sep = "\t")
fwrite(uv_category_summary, file.path(tables_dir, "uv_signature_category_rollup.tsv"), sep = "\t")

uv_plot <- ggplot(uv_category_summary, aes(x = reorder(signature_category, n_unique_signature_symbols), y = n_unique_signature_symbols, fill = signature_tier)) +
  geom_col(width = 0.72, color = "grey20", linewidth = 0.15) +
  coord_flip() +
  labs(x = NULL, y = "Unique signature symbols", fill = "Tier", title = "UV/DNA-damage signature potential") +
  theme_minimal(base_size = 12)
ggsave(file.path(figures_dir, "uv_signature_category_rollup.png"), uv_plot, width = 8, height = 5, dpi = 300)
ggsave(file.path(figures_dir, "uv_signature_category_rollup.pdf"), uv_plot, width = 8, height = 5)

manifest <- data.table(
  artifact = c(
    "votu_catalogue_summary", "votu_quality_summary", "votu_high_quality_taxonomy_groups",
    "votu_high_quality_realm_summary", "votu_taxonomy_tree_tip_metadata",
    "votu_high_quality_taxonomy_tree", "uv_signature_mag_rollup", "uv_signature_category_rollup"
  ),
  path = c(
    file.path(tables_dir, "votu_catalogue_summary.tsv"),
    file.path(tables_dir, "votu_quality_summary.tsv"),
    file.path(tables_dir, "votu_high_quality_taxonomy_groups.tsv"),
    file.path(tables_dir, "votu_high_quality_realm_summary.tsv"),
    file.path(tables_dir, "votu_taxonomy_tree_tip_metadata.tsv"),
    file.path(trees_dir, "votu_high_quality_taxonomy_tree.nwk"),
    file.path(tables_dir, "uv_signature_mag_rollup.tsv"),
    file.path(tables_dir, "uv_signature_category_rollup.tsv")
  )
)
fwrite(manifest, file.path(out_dir, "poster_replication_manifest.tsv"), sep = "\t")

message("Wrote poster-replication vOTU/UV outputs to: ", out_dir)
