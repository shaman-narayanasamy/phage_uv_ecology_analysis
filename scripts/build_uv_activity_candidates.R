#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(data.table)
  library(ggplot2)
  library(scales)
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
gene_categories <- unique(hits[
  entity_type == "MAG",
  .(gene_id, signature_tier, signature_category)
])
uv_gene_ids <- unique(gene_categories$gene_id)

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

read_uv_counts <- function(path) {
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
  counts <- counts[gene_id %chin% uv_gene_ids]
  counts <- gene_categories[counts, on = "gene_id", allow.cartesian = TRUE]
  summary <- counts[, .(category_reads = sum(read_count, na.rm = TRUE)), by = .(
    signature_tier,
    signature_category
  )]
  summary[, `:=`(
    sample_code = sample_code,
    run_accession = run_accession,
    library_total = library_total
  )]
  summary[]
}

run_counts <- rbindlist(lapply(coverage_files, read_uv_counts), use.names = TRUE)
setcolorder(
  run_counts,
  c(
    "sample_code",
    "run_accession",
    "library_total",
    "signature_tier",
    "signature_category",
    "category_reads"
  )
)
fwrite(run_counts, file.path(tables_dir, "uv_mt_run_category_counts.tsv"), sep = "\t")

sample_counts <- run_counts[, .(
  library_total = sum(library_total),
  category_reads = sum(category_reads)
), by = .(sample_code, signature_tier, signature_category)]
sample_counts[, condition := fifelse(substr(sample_code, 1L, 1L) == "C", "control", "treatment")]
sample_counts[, phase := fifelse(grepl("BF", sample_code, fixed = TRUE), "backflush", "initial")]
sample_counts[, cycle := as.integer(sub(".*([123])$", "\\1", sample_code))]
sample_counts[, stratum := paste(phase, cycle, sep = "_cycle")]
sample_counts[, cpm := category_reads / library_total * 1e6]
sample_counts[, condition := factor(condition, levels = c("control", "treatment"))]
sample_counts[, phase := factor(phase, levels = c("initial", "backflush"))]
fwrite(sample_counts, file.path(tables_dir, "uv_mt_sample_category_cpm.tsv"), sep = "\t")

effect_wide <- dcast(
  sample_counts,
  phase + cycle + stratum + signature_tier + signature_category ~ condition,
  value.var = "cpm"
)
effect_wide[, log2_treatment_control := log2((treatment + 0.1) / (control + 0.1))]
fwrite(effect_wide, file.path(tables_dir, "uv_mt_paired_treatment_effect.tsv"), sep = "\t")

category_order <- c(
  "nucleotide_excision_repair",
  "photoreactivation",
  "recombination_repair",
  "SOS_response",
  "oxidative_stress",
  "redox_stress",
  "base_excision_oxidative_repair",
  "general_stress"
)
category_labels <- c(
  nucleotide_excision_repair = "Nucleotide excision repair",
  photoreactivation = "Photoreactivation",
  recombination_repair = "Recombination repair",
  SOS_response = "SOS response",
  oxidative_stress = "Oxidative stress",
  redox_stress = "Redox stress",
  base_excision_oxidative_repair = "Base-excision / oxidative repair",
  general_stress = "General stress"
)

sample_counts[, signature_category := factor(signature_category, levels = category_order)]
effect_wide[, signature_category := factor(signature_category, levels = category_order)]

p_activity <- ggplot(
  sample_counts,
  aes(
    x = condition,
    y = cpm,
    group = stratum,
    colour = condition,
    shape = phase
  )
) +
  geom_line(colour = "#C7C7C7", linewidth = 0.35) +
  geom_point(size = 2.2, alpha = 0.9) +
  scale_colour_manual(
    values = phage_uv_condition_colours[c("control", "treatment")],
    labels = c(control = "Control", treatment = "Phage-UV")
  ) +
  scale_shape_manual(values = phage_uv_phase_shapes) +
  scale_x_discrete(labels = c(control = "Control", treatment = "Phage-UV")) +
  scale_y_log10(labels = label_number()) +
  facet_wrap(
    vars(signature_category),
    scales = "free_y",
    ncol = 4,
    labeller = as_labeller(category_labels)
  ) +
  labs(
    x = NULL,
    y = "UV-response transcript abundance (CPM, log scale)",
    colour = "Condition",
    shape = "Phase"
  ) +
  theme_phage_uv() +
  theme(
    axis.text.x = element_text(angle = 20, hjust = 1),
    panel.grid.major.y = element_line(colour = "#E6E6E6", linewidth = 0.25),
    legend.position = "bottom"
  )
save_candidate("uv-transcription-paired-condition", p_activity, 9.2, 5.6)

p_effect <- ggplot(
  effect_wide,
  aes(
    x = signature_category,
    y = log2_treatment_control,
    shape = phase,
    group = interaction(phase, cycle)
  )
) +
  geom_hline(yintercept = 0, colour = "#777777", linewidth = 0.35) +
  geom_point(
    colour = phage_uv_condition_colours[["treatment"]],
    fill = phage_uv_condition_colours[["treatment"]],
    size = 2.2,
    alpha = 0.88,
    position = position_jitter(width = 0.09, height = 0)
  ) +
  stat_summary(
    aes(group = signature_category),
    fun = median,
    geom = "crossbar",
    width = 0.55,
    colour = "#222222",
    linewidth = 0.35
  ) +
  scale_shape_manual(values = phage_uv_phase_shapes) +
  scale_x_discrete(labels = category_labels) +
  labs(
    x = NULL,
    y = expression(log[2]("phage-UV / control transcript abundance")),
    shape = "Phase"
  ) +
  theme_phage_uv() +
  theme(
    axis.text.x = element_text(angle = 35, hjust = 1),
    panel.grid.major.y = element_line(colour = "#E6E6E6", linewidth = 0.25),
    legend.position = "bottom"
  )
save_candidate("uv-transcription-treatment-effect", p_effect, 8.8, 4.8)

effect_summary <- effect_wide[, .(
  n_pairs = .N,
  n_positive_pairs = sum(log2_treatment_control > 0),
  median_log2_treatment_control = median(log2_treatment_control),
  min_log2_treatment_control = min(log2_treatment_control),
  max_log2_treatment_control = max(log2_treatment_control),
  sign_test_p = binom.test(
    sum(log2_treatment_control > 0),
    .N,
    p = 0.5,
    alternative = "two.sided"
  )$p.value
), by = .(signature_tier, signature_category)]
effect_summary[, sign_test_padj_bh := p.adjust(sign_test_p, method = "BH")]
fwrite(effect_summary, file.path(tables_dir, "uv_mt_treatment_effect_summary.tsv"), sep = "\t")

message("Wrote UV-activity candidate figures to: ", figures_dir)
