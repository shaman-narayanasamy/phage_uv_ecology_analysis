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

compare_path <- file.path(
  data_root,
  "community_uv_response",
  "variant_analysis",
  "instrain_priority_20",
  "tables",
  "priority20_instrain_compare_summary.tsv"
)
comparisons <- fread(compare_path)

# These thresholds are coverage/QC rules, not biological-effect filters.
qc_min_compared_bases <- 1e6
qc_min_compared_fraction <- 0.50
qc_min_valid_pairs <- 10L
qc_min_observed_samples <- 6L

comparisons[, consensus_differences_per_mbp :=
  consensus_SNPs / compared_bases_count * 1e6]
comparisons[, pair_passes_qc :=
  compared_bases_count >= qc_min_compared_bases &
    percent_compared >= qc_min_compared_fraction]

safe_median <- function(x) if (length(x)) median(x, na.rm = TRUE) else NA_real_
safe_min <- function(x) if (length(x)) min(x, na.rm = TRUE) else NA_real_
safe_max <- function(x) if (length(x)) max(x, na.rm = TRUE) else NA_real_

mag_qc <- comparisons[, {
  valid <- pair_passes_qc
  valid_samples <- unique(c(sample_a[valid], sample_b[valid]))
  .(
    total_pairs = .N,
    valid_pairs = sum(valid),
    observed_samples = length(valid_samples),
    median_compared_bases = safe_median(as.numeric(compared_bases_count[valid])),
    minimum_compared_fraction = safe_min(percent_compared[valid]),
    median_consensus_differences_per_mbp = safe_median(
      consensus_differences_per_mbp[valid]
    ),
    minimum_consensus_differences_per_mbp = safe_min(
      consensus_differences_per_mbp[valid]
    ),
    maximum_consensus_differences_per_mbp = safe_max(
      consensus_differences_per_mbp[valid]
    )
  )
}, by = MAG_ID]
mag_qc[valid_pairs == 0L, c(
  "median_compared_bases",
  "minimum_compared_fraction",
  "median_consensus_differences_per_mbp",
  "minimum_consensus_differences_per_mbp",
  "maximum_consensus_differences_per_mbp"
) := NA_real_]
mag_qc[, eligible_for_descriptive_panel :=
  valid_pairs >= qc_min_valid_pairs &
    observed_samples >= qc_min_observed_samples]
mag_qc[, selection_rule := paste0(
  "pair QC: compared bases >= ", format(qc_min_compared_bases, scientific = FALSE),
  " and compared fraction >= ", qc_min_compared_fraction,
  "; MAG QC: valid pairs >= ", qc_min_valid_pairs,
  " and observed samples >= ", qc_min_observed_samples
)]

taxonomy_path <- file.path(tables_dir, "mag_taxonomy_crosswalk.tsv")
if (!file.exists(taxonomy_path)) {
  stop("Missing taxonomy crosswalk. Run build_candidate_ecology_figures.R first.")
}
taxonomy <- fread(taxonomy_path)[, .(MAG_ID, phylum, genus, species)]
mag_qc <- taxonomy[mag_qc, on = "MAG_ID"]
setorder(mag_qc, -eligible_for_descriptive_panel, -valid_pairs, MAG_ID)

fwrite(
  comparisons,
  file.path(tables_dir, "population_genomics_pair_qc.tsv"),
  sep = "\t"
)
fwrite(
  mag_qc,
  file.path(tables_dir, "population_genomics_mag_qc.tsv"),
  sep = "\t"
)

eligible_mags <- mag_qc[eligible_for_descriptive_panel == TRUE]$MAG_ID
eligible_pairs <- comparisons[
  MAG_ID %chin% eligible_mags & pair_passes_qc == TRUE
]

sample_order <- c(
  "CI1", "CI2", "CI3", "CBF1", "CBF2", "CBF3",
  "TI1", "TI2", "TI3", "TBF1", "TBF2", "TBF3"
)
sample_labels <- c(
  CI1 = "C I1", CI2 = "C I2", CI3 = "C I3",
  CBF1 = "C BF1", CBF2 = "C BF2", CBF3 = "C BF3",
  TI1 = "P I1", TI2 = "P I2", TI3 = "P I3",
  TBF1 = "P BF1", TBF2 = "P BF2", TBF3 = "P BF3"
)

mirrored_pairs <- rbindlist(list(
  eligible_pairs[, .(
    MAG_ID,
    sample_x = sample_a,
    sample_y = sample_b,
    consensus_differences_per_mbp,
    percent_compared,
    compared_bases_count,
    popANI
  )],
  eligible_pairs[, .(
    MAG_ID,
    sample_x = sample_b,
    sample_y = sample_a,
    consensus_differences_per_mbp,
    percent_compared,
    compared_bases_count,
    popANI
  )]
))

grid <- CJ(
  MAG_ID = eligible_mags,
  sample_x = sample_order,
  sample_y = sample_order,
  unique = TRUE
)
grid <- mirrored_pairs[grid, on = .(MAG_ID, sample_x, sample_y)]
grid[sample_x == sample_y, consensus_differences_per_mbp := 0]
grid[, display_value := log10(consensus_differences_per_mbp + 1)]

panel_labels <- mag_qc[
  MAG_ID %chin% eligible_mags,
  .(
    MAG_ID,
    panel_label = paste0(
      sub("_MAGScoT_cleanbin_", " bin ", MAG_ID),
      "\n",
      fifelse(is.na(phylum) | phylum == "", "Unclassified", phylum)
    )
  )
]
grid <- panel_labels[grid, on = "MAG_ID"]
panel_levels <- panel_labels[match(eligible_mags, MAG_ID)]$panel_label
grid[, panel_label := factor(panel_label, levels = panel_levels)]
grid[, sample_x := factor(sample_x, levels = sample_order, labels = sample_labels)]
grid[, sample_y := factor(sample_y, levels = rev(sample_order), labels = rev(sample_labels))]

legend_values <- c(0, 10, 100, 1000, 10000)
p <- ggplot(grid, aes(x = sample_x, y = sample_y)) +
  geom_tile(fill = "#EEEEEE", colour = "white", linewidth = 0.15) +
  geom_tile(
    data = grid[!is.na(display_value)],
    aes(fill = display_value),
    colour = "white",
    linewidth = 0.15
  ) +
  facet_wrap(vars(panel_label), ncol = 2L) +
  scale_fill_gradientn(
    colours = c("#F7FBFF", "#C6DBEF", "#6BAED6", "#2171B5", "#08306B"),
    breaks = log10(legend_values + 1),
    labels = label_number(big.mark = ",")(legend_values),
    limits = range(log10(c(0, 10000) + 1)),
    oob = squish
  ) +
  labs(
    x = "Sample (C = control; P = phage-UV)",
    y = "Sample",
    fill = "Consensus SNP differences\nper Mbp compared"
  ) +
  theme_phage_uv(base_size = 8.5) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.spacing = grid::unit(1.2, "lines"),
    legend.position = "bottom"
  )

save_candidate("population-genomics-pairwise-landscape", p, 9.0, 10.0)

message(
  "Wrote descriptive population-genomics panel for ",
  length(eligible_mags),
  " coverage-qualified MAGs."
)
