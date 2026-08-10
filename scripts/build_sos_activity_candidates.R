#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(data.table)
  library(ggplot2)
})

args <- commandArgs(trailingOnly = TRUE)
data_root <- if (length(args) >= 1L) args[[1L]] else Sys.getenv("PHAGE_UV_DATA_ROOT")
out_root <- if (length(args) >= 2L) args[[2L]] else file.path(data_root, "derived", "manuscript_candidates")

if (!nzchar(data_root) || !dir.exists(data_root)) {
  stop("Provide the PRJEB79569 data root as the first argument or PHAGE_UV_DATA_ROOT.")
}

script_arg <- grep("^--file=", commandArgs(), value = TRUE)
script_path <- normalizePath(sub("^--file=", "", script_arg[[1L]]))
repo_root <- dirname(dirname(script_path))
source(file.path(repo_root, "R", "figure_style.R"))

tables_dir <- file.path(out_root, "tables")
figures_dir <- file.path(out_root, "figures")
dir.create(tables_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(figures_dir, recursive = TRUE, showWarnings = FALSE)

save_candidate <- function(name, plot, width, height) {
  ggsave(
    file.path(figures_dir, paste0(name, ".pdf")),
    plot,
    width = width,
    height = height,
    units = "in",
    device = grDevices::pdf,
    useDingbats = FALSE
  )
  ggsave(
    file.path(figures_dir, paste0(name, ".png")),
    plot,
    width = width,
    height = height,
    units = "in",
    dpi = 300,
    bg = "white"
  )
}

hits <- fread(file.path(data_root, "community_uv_response", "uv_signature_hits.tsv"))
sos_map <- unique(hits[
  entity_type == "MAG" & signature_category == "SOS_response",
  .(gene_id, MAG_ID, signature_gene_symbol)
])
sos_gene_ids <- unique(sos_map$gene_id)

coverage_dir <- file.path(
  data_root,
  "quantification",
  "mags_votu",
  "gene_coverage",
  "metatranscriptomics"
)
coverage_files <- sort(list.files(
  coverage_dir,
  pattern = "_metatranscriptomics\\.tsv$",
  full.names = TRUE
))

read_sos_counts <- function(path) {
  run_name <- sub("_metatranscriptomics\\.tsv$", "", basename(path))
  fields <- strsplit(run_name, "__", fixed = TRUE)[[1L]]
  sample_code <- fields[[1L]]
  run_accession <- fields[[3L]]

  counts <- fread(
    path,
    select = c(4L, 7L),
    col.names = c("gene_id", "read_count"),
    showProgress = FALSE
  )
  library_total <- sum(counts$read_count, na.rm = TRUE)
  counts <- counts[gene_id %chin% sos_gene_ids]
  counts <- sos_map[counts, on = "gene_id", allow.cartesian = TRUE]
  counts[, `:=`(
    sample_code = sample_code,
    run_accession = run_accession,
    library_total = library_total
  )]
  counts[]
}

run_gene_counts <- rbindlist(lapply(coverage_files, read_sos_counts), use.names = TRUE)
fwrite(run_gene_counts, file.path(tables_dir, "sos_mt_run_gene_counts.tsv"), sep = "\t")

sample_gene_counts <- run_gene_counts[, .(
  library_total = sum(unique(library_total)),
  read_count = sum(read_count)
), by = .(sample_code, gene_id, MAG_ID, signature_gene_symbol)]
sample_gene_counts[, condition := fifelse(substr(sample_code, 1L, 1L) == "C", "control", "treatment")]
sample_gene_counts[, phase := fifelse(grepl("BF", sample_code, fixed = TRUE), "backflush", "initial")]
sample_gene_counts[, cycle := as.integer(sub(".*([123])$", "\\1", sample_code))]
sample_gene_counts[, stratum := paste(phase, cycle, sep = "_cycle")]
sample_gene_counts[, cpm := read_count / library_total * 1e6]
fwrite(sample_gene_counts, file.path(tables_dir, "sos_mt_sample_gene_cpm.tsv"), sep = "\t")

symbol_counts <- sample_gene_counts[, .(
  cpm = sum(cpm),
  read_count = sum(read_count)
), by = .(sample_code, condition, phase, cycle, stratum, signature_gene_symbol)]
symbol_effect <- dcast(
  symbol_counts,
  phase + cycle + stratum + signature_gene_symbol ~ condition,
  value.var = "cpm"
)
symbol_effect[, log2_treatment_control := log2((treatment + 0.1) / (control + 0.1))]
fwrite(symbol_effect, file.path(tables_dir, "sos_mt_symbol_treatment_effect.tsv"), sep = "\t")

symbol_summary <- symbol_effect[, .(
  n_pairs = .N,
  median_log2_treatment_control = median(log2_treatment_control),
  n_positive_pairs = sum(log2_treatment_control > 0),
  min_log2_treatment_control = min(log2_treatment_control),
  max_log2_treatment_control = max(log2_treatment_control),
  sign_test_p = binom.test(
    sum(log2_treatment_control > 0),
    .N,
    p = 0.5,
    alternative = "two.sided"
  )$p.value
), by = signature_gene_symbol][order(-median_log2_treatment_control)]
symbol_summary[, sign_test_padj_bh := p.adjust(sign_test_p, method = "BH")]
fwrite(symbol_summary, file.path(tables_dir, "sos_mt_symbol_effect_summary.tsv"), sep = "\t")

symbol_order <- symbol_summary$signature_gene_symbol
symbol_effect[, signature_gene_symbol := factor(signature_gene_symbol, levels = symbol_order)]
symbol_effect[, phase := factor(phase, levels = c("initial", "backflush"))]

p_symbol <- ggplot(
  symbol_effect,
  aes(x = signature_gene_symbol, y = log2_treatment_control, shape = phase)
) +
  geom_hline(yintercept = 0, colour = "#777777", linewidth = 0.35) +
  geom_point(
    colour = phage_uv_condition_colours[["treatment"]],
    fill = phage_uv_condition_colours[["treatment"]],
    size = 2.3,
    alpha = 0.88,
    position = position_jitter(width = 0.09, height = 0)
  ) +
  stat_summary(
    aes(group = signature_gene_symbol),
    fun = median,
    geom = "crossbar",
    width = 0.55,
    colour = "#222222",
    linewidth = 0.35
  ) +
  scale_shape_manual(values = phage_uv_phase_shapes) +
  labs(
    x = "SOS-response marker",
    y = expression(log[2]("phage-UV / control transcript abundance")),
    shape = "Phase"
  ) +
  theme_phage_uv() +
  theme(
    panel.grid.major.y = element_line(colour = "#E6E6E6", linewidth = 0.25),
    legend.position = "bottom"
  )
save_candidate("sos-transcription-marker-effects", p_symbol, 7.4, 4.5)

message("Wrote SOS-response candidate figure to: ", figures_dir)
