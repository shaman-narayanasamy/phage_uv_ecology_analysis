#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(data.table)
  library(ggplot2)
  library(patchwork)
})

abort <- function(...) stop(sprintf(...), call. = FALSE)

repo_root <- function() {
  root <- normalizePath(getwd(), mustWork = TRUE)
  if (!file.exists(file.path(root, "R", "figure_style.R"))) {
    abort("Run this script from the phage_uv_ecology_analysis repository root")
  }
  root
}

shorten_label <- function(x, width = 44L) {
  x <- trimws(as.character(x))
  too_long <- nchar(x) > width
  x[too_long] <- paste0(substr(x[too_long], 1L, width - 3L), "...")
  x
}

write_output_checksums <- function(output_dir) {
  files <- list.files(output_dir, recursive = TRUE, full.names = TRUE)
  files <- files[file.info(files)$isdir %in% FALSE]
  files <- files[basename(files) != "output_checksums.md5.tsv"]
  relative <- substring(normalizePath(files), nchar(normalizePath(output_dir)) + 2L)
  checksum_table <- data.table(
    path = relative,
    bytes = file.info(files)$size,
    md5 = unname(tools::md5sum(files))
  )
  setorder(checksum_table, path)
  fwrite(checksum_table, file.path(output_dir, "output_checksums.md5.tsv"), sep = "\t")
}

args <- commandArgs(trailingOnly = TRUE)
root <- repo_root()
project_data <- "/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569"
interpretation_root <- file.path(project_data, "derived", "full_de_interpretation")
output_dir <- if (length(args)) args[[1L]] else file.path(
  project_data, "derived", "manuscript_figure_candidates"
)

if (!dir.exists(output_dir)) {
  abort("Build the first two manuscript candidates before adding recurrence: %s", output_dir)
}

source(file.path(root, "R", "figure_style.R"))

paths <- list(
  annotated = file.path(interpretation_root, "tables", "full_de_gene_annotation_taxonomy.tsv.gz"),
  recurrence = file.path(interpretation_root, "tables", "gene_six_cell_recurrence.tsv.gz"),
  candidates = file.path(interpretation_root, "tables", "predeclared_gene_candidates.tsv"),
  registry = file.path(output_dir, "candidate_figure_registry.tsv")
)
missing_inputs <- names(paths)[!file.exists(unlist(paths))]
if (length(missing_inputs)) abort("Missing inputs: %s", paste(missing_inputs, collapse = ", "))

annotated <- fread(paths$annotated)
recurrence <- fread(paths$recurrence)
candidates <- fread(paths$candidates)

if (nrow(annotated) != 361907L || uniqueN(annotated$feature_id) != nrow(annotated)) {
  abort("Annotated input is not the frozen 361,907-feature universe")
}
if (nrow(recurrence) != nrow(annotated) || uniqueN(recurrence$feature_id) != nrow(recurrence)) {
  abort("Six-cell recurrence input does not match the frozen tested universe")
}

recurrence_classes <- c("recurrent_control_higher", "recurrent_treatment_higher")
joined <- merge(
  annotated,
  recurrence[, .(
    feature_id, recurrence_class, dominant_direction_cells,
    median_cell_log2cpm_difference
  )],
  by = "feature_id", all.x = TRUE, sort = FALSE
)
joined[, `:=`(
  passes_effect = FDR < 0.05 & abs(logFC) >= 1,
  passes_detection = n_samples_detected >= 6,
  has_annotation = !is.na(annotation) & nzchar(annotation),
  passes_recurrence = recurrence_class %chin% recurrence_classes
)]

funnel <- data.table(
  stage = factor(
    c(
      "Complete tested universe",
      "BH FDR < 0.05 and |log2FC| >= 1",
      "Detected in at least 6 samples",
      "Non-empty gene annotation",
      "Recurrent in at least 5 of 6 cells"
    ),
    levels = rev(c(
      "Complete tested universe",
      "BH FDR < 0.05 and |log2FC| >= 1",
      "Detected in at least 6 samples",
      "Non-empty gene annotation",
      "Recurrent in at least 5 of 6 cells"
    ))
  ),
  features = c(
    nrow(joined),
    joined[passes_effect == TRUE, .N],
    joined[passes_effect == TRUE & passes_detection == TRUE, .N],
    joined[passes_effect == TRUE & passes_detection == TRUE & has_annotation == TRUE, .N],
    joined[
      passes_effect == TRUE & passes_detection == TRUE &
        has_annotation == TRUE & passes_recurrence == TRUE,
      .N
    ]
  )
)
funnel[, `:=`(
  step = rev(seq_len(.N)),
  count_label = format(features, big.mark = ","),
  stage_short = c(
    "Complete tested universe",
    "BH FDR < 0.05 and |log2FC| >= 1",
    "Detected in >= 6 samples",
    "Non-empty gene annotation",
    "Recurrent in >= 5 of 6 cells"
  )
)]

expected_funnel <- c(361907L, 7699L, 7603L, 7141L, 6985L)
if (!identical(as.integer(funnel$features), expected_funnel)) {
  abort("Selection funnel changed: %s", paste(funnel$features, collapse = ", "))
}

if (nrow(candidates) != 6985L || !setequal(candidates$feature_id, joined[
  passes_effect == TRUE & passes_detection == TRUE &
    has_annotation == TRUE & passes_recurrence == TRUE,
  feature_id
])) {
  abort("Predeclared candidate table does not match the frozen sequential criteria")
}

candidates[, higher_in := factor(
  fifelse(recurrence_class == "recurrent_control_higher", "Control", "Phage-UV"),
  levels = c("Control", "Phage-UV")
)]
candidates[, concordance := factor(
  paste0(dominant_direction_cells, " of 6 cells"),
  levels = c("5 of 6 cells", "6 of 6 cells")
)]
concordance <- candidates[, .(features = .N), by = .(higher_in, concordance)]
setorder(concordance, higher_in, concordance)
concordance[, label_x := fifelse(
  concordance == "6 of 6 cells",
  features / 2,
  features / 2 + sum(features[concordance == "6 of 6 cells"])
), by = higher_in]

expected_direction <- candidates[, .N, by = higher_in]
observed_direction <- setNames(expected_direction$N, as.character(expected_direction$higher_in))
if (!identical(as.integer(observed_direction[c("Control", "Phage-UV")]),
               c(3651L, 3334L))) {
  abort("Recurrent candidate direction counts changed")
}

candidates[, absolute_logFC := abs(logFC)]
setorder(candidates, higher_in, FDR, -absolute_logFC, feature_id)
selected <- candidates[, head(.SD, 12L), by = higher_in]
if (nrow(selected) != 24L || any(selected[, .N, by = higher_in]$N != 12L)) {
  abort("Heatmap selection is not balanced at 12 candidates per direction")
}

selected[, short_mag := sub(
  "^([^_]+)_MAGScoT_cleanbin_0*", "\\1-", MAG_ID
)]
selected[, label_core := fifelse(
  !is.na(gene_symbol) & nzchar(gene_symbol),
  paste0(gene_symbol, ": ", annotation),
  annotation
)]
selected[, gene_label := paste0(shorten_label(label_core), " [", short_mag, "]")]
selected[, gene_label := make.unique(gene_label, sep = " #")]
selected[, selection_rank := seq_len(.N), by = higher_in]

cell_columns <- grep("^log2cpm_difference_", names(recurrence), value = TRUE)
expected_cell_columns <- paste0(
  "log2cpm_difference_",
  c(
    "initial_cycle1", "initial_cycle2", "initial_cycle3",
    "backflush_cycle1", "backflush_cycle2", "backflush_cycle3"
  )
)
if (!identical(cell_columns, expected_cell_columns)) abort("Six-cell effect columns changed")

heat <- recurrence[
  selected[, .(feature_id, gene_label, higher_in, selection_rank)],
  on = "feature_id", nomatch = 0L
]
heat <- melt(
  heat,
  id.vars = c("feature_id", "gene_label", "higher_in", "selection_rank"),
  measure.vars = expected_cell_columns,
  variable.name = "cell", value.name = "log2cpm_difference"
)
cell_levels <- sub("^log2cpm_difference_", "", expected_cell_columns)
cell_labels <- c(
  "Initial\ncycle 1", "Initial\ncycle 2", "Initial\ncycle 3",
  "Backflush\ncycle 1", "Backflush\ncycle 2", "Backflush\ncycle 3"
)
cell_axis_labels <- setNames(cell_labels, cell_levels)
heat[, cell := factor(sub("^log2cpm_difference_", "", cell), levels = cell_levels)]
heat[, direction_order := fifelse(higher_in == "Control", 1L, 2L)]
row_order <- unique(heat[order(direction_order, selection_rank), gene_label])
heat[, gene_label := factor(gene_label, levels = rev(row_order))]

condition_values <- c(
  Control = phage_uv_condition_colours[["control"]],
  `Phage-UV` = phage_uv_condition_colours[["treatment"]]
)

p_funnel <- ggplot(funnel, aes(y = step)) +
  geom_segment(
    data = funnel[step > 1],
    aes(x = 0.78, xend = 0.78, y = step - 0.28, yend = step - 0.72),
    colour = "#8A8A8A", linewidth = 0.45,
    arrow = grid::arrow(length = grid::unit(0.08, "inches"), type = "closed")
  ) +
  geom_label(
    aes(x = 0.78, label = count_label),
    size = 3.0, linewidth = 0.22, label.padding = grid::unit(0.15, "lines"),
    fill = "#F5F5F5", colour = "#222222"
  ) +
  geom_text(
    aes(x = 1.48, label = stage_short),
    hjust = 0, size = 2.75, colour = "#222222"
  ) +
  coord_cartesian(xlim = c(0.2, 4.9), ylim = c(0.55, 5.45), clip = "off") +
  labs(x = NULL, y = NULL, tag = "A") +
  theme_phage_uv(base_size = 8.5) +
  theme(
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    axis.text = element_blank(),
    plot.tag = element_text(face = "bold", size = 11)
  )

p_concordance <- ggplot(
  concordance,
  aes(features, higher_in, fill = higher_in, alpha = concordance)
) +
  geom_col(width = 0.62, colour = "#222222", linewidth = 0.3) +
  geom_text(
    aes(x = label_x, label = format(features, big.mark = ",")),
    size = 2.8, colour = "#222222", alpha = 1, show.legend = FALSE
  ) +
  scale_fill_manual(values = condition_values, guide = "none") +
  scale_alpha_manual(values = c("5 of 6 cells" = 0.48, "6 of 6 cells" = 1), name = "Directional concordance") +
  scale_x_continuous(labels = scales::label_number(big.mark = ","), expand = expansion(mult = c(0, 0.08))) +
  labs(x = "Predeclared recurrent genes", y = "Higher expression", tag = "B") +
  theme_phage_uv(base_size = 8.5) +
  theme(
    legend.position = "bottom",
    plot.tag = element_text(face = "bold", size = 11)
  )

heat_limit <- ceiling(max(abs(heat$log2cpm_difference), na.rm = TRUE))
p_heat <- ggplot(heat, aes(cell, gene_label, fill = log2cpm_difference)) +
  geom_tile(colour = "white", linewidth = 0.25) +
  geom_vline(xintercept = 3.5, colour = "#444444", linewidth = 0.45) +
  facet_grid(rows = vars(higher_in), scales = "free_y", space = "free_y", switch = "y") +
  scale_fill_gradient2(
    low = condition_values[["Control"]], mid = "white", high = condition_values[["Phage-UV"]],
    midpoint = 0, limits = c(-heat_limit, heat_limit),
    name = "Phage-UV - control\nlog2 CPM"
  ) +
  scale_x_discrete(labels = cell_axis_labels) +
  labs(x = NULL, y = NULL, tag = "C") +
  theme_phage_uv(base_size = 8.1) +
  theme(
    axis.text.x = element_text(size = 7.5),
    axis.text.y = element_text(size = 6.6),
    legend.position = "bottom",
    strip.placement = "outside",
    strip.text.y.left = element_text(angle = 0, face = "plain", size = 8),
    panel.spacing.y = grid::unit(0.7, "lines"),
    plot.tag = element_text(face = "bold", size = 11)
  )

top_row <- (p_funnel | p_concordance) +
  plot_layout(widths = c(0.82, 1.18))
figure_recurrence <- top_row / p_heat +
  plot_layout(heights = c(0.72, 1.72))

write_recurrence_outputs <- function() {
  stage_dir <- file.path(output_dir, sprintf(".recurrent-gene-staging-%s", Sys.getpid()))
  dir.create(file.path(stage_dir, "figures"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(stage_dir, "tables"), recursive = TRUE, showWarnings = FALSE)
  on.exit(if (dir.exists(stage_dir)) unlink(stage_dir, recursive = TRUE), add = TRUE)

  figure_name <- "recurrent-gene-structure.pdf"
  figure_stage <- file.path(stage_dir, "figures", figure_name)
  ggsave(figure_stage, figure_recurrence, width = 11, height = 9, device = grDevices::pdf)
  if (!file.exists(figure_stage) || file.info(figure_stage)$size == 0) abort("Recurrence PDF was not rendered")

  fwrite(funnel, file.path(stage_dir, "tables", "recurrence_selection_funnel.tsv"), sep = "\t")
  fwrite(concordance, file.path(stage_dir, "tables", "recurrence_direction_concordance.tsv"), sep = "\t")
  fwrite(selected, file.path(stage_dir, "tables", "recurrent_gene_heatmap_selection.tsv"), sep = "\t")
  fwrite(heat, file.path(stage_dir, "tables", "recurrent_gene_heatmap_cells.tsv"), sep = "\t")

  dir.create(file.path(output_dir, "figures"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(output_dir, "tables"), recursive = TRUE, showWarnings = FALSE)
  files_to_promote <- list.files(stage_dir, recursive = TRUE, full.names = TRUE)
  files_to_promote <- files_to_promote[file.info(files_to_promote)$isdir %in% FALSE]
  relative_paths <- substring(files_to_promote, nchar(stage_dir) + 2L)
  destinations <- file.path(output_dir, relative_paths)
  if (!all(file.copy(files_to_promote, destinations, overwrite = TRUE))) {
    abort("Failed to promote one or more recurrence artifacts")
  }

  registry <- fread(paths$registry)
  registry <- registry[artifact != figure_name]
  registry <- rbind(
    registry,
    data.table(
      artifact = figure_name,
      status = "candidate_unallocated",
      panels = paste(
        "sequential selection provenance; recurrence direction and cell concordance;",
        "balanced top-gene six-cell effect heatmap"
      ),
      boundary = paste(
        "Descriptive recurrence only; one membrane per condition;",
        "12 genes per direction selected deterministically by FDR then absolute log2FC"
      )
    ),
    fill = TRUE
  )
  fwrite(registry, paths$registry, sep = "\t")
  write_output_checksums(output_dir)

  cat(sprintf("Created unnumbered recurrence candidate in %s\n", file.path(output_dir, "figures", figure_name)))
}

write_recurrence_outputs()
