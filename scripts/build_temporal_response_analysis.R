#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(data.table)
  library(ggplot2)
  library(scales)
  library(cluster)
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

parse_sample <- function(x) {
  data.table(
    sample_code = x,
    condition = fifelse(substr(x, 1L, 1L) == "C", "control", "treatment"),
    phase = fifelse(grepl("BF", x, fixed = TRUE), "backflush", "initial"),
    cycle = as.integer(sub(".*([123])$", "\\1", x))
  )
}

all_permutations_3 <- rbind(
  c(1L, 2L, 3L),
  c(1L, 3L, 2L),
  c(2L, 1L, 3L),
  c(2L, 3L, 1L),
  c(3L, 1L, 2L),
  c(3L, 2L, 1L)
)

exact_phase_blocked_slope <- function(cycle, phase, value) {
  d <- data.table(cycle = as.numeric(cycle), phase = as.character(phase), value = as.numeric(value))
  d <- d[order(factor(phase, levels = c("initial", "backflush")), cycle)]
  if (nrow(d) != 6L || anyNA(d$value) || uniqueN(d$phase) != 2L) {
    return(list(slope = NA_real_, exact_p = NA_real_))
  }

  observed <- unname(coef(lm(value ~ cycle + factor(phase), data = d))[["cycle"]])
  null_slopes <- numeric(36L)
  cursor <- 1L
  for (i in seq_len(nrow(all_permutations_3))) {
    for (j in seq_len(nrow(all_permutations_3))) {
      permuted <- c(
        d$value[all_permutations_3[i, ]],
        d$value[3L + all_permutations_3[j, ]]
      )
      null_slopes[[cursor]] <- unname(coef(
        lm(permuted ~ d$cycle + factor(d$phase))
      )[[2L]])
      cursor <- cursor + 1L
    }
  }

  list(
    slope = observed,
    exact_p = mean(abs(null_slopes) >= abs(observed) - 1e-12)
  )
}

adjust_family <- function(x, family_columns) {
  x[, adjusted_p_bh := p.adjust(exact_p, method = "BH"), by = family_columns]
  x[]
}

taxonomy_path <- file.path(data_root, "annotation", "catbat", "gtdb", "BAT.bin2classification.txt")
taxonomy <- fread(taxonomy_path, check.names = FALSE)
setnames(taxonomy, "# bin", "MAG_ID")
taxonomy[, MAG_ID := sub("\\.fasta$", "", MAG_ID)]

extract_rank <- function(lineage, prefix) {
  vapply(strsplit(lineage, ";", fixed = TRUE), function(parts) {
    hit <- parts[startsWith(parts, paste0(prefix, "__"))]
    if (!length(hit)) return(NA_character_)
    value <- sub(paste0("^", prefix, "__"), "", hit[[1L]])
    value <- sub("\\*$", "", value)
    if (!nzchar(value)) NA_character_ else value
  }, character(1))
}

taxonomy[, phylum := extract_rank(lineage, "p")]
taxonomy[, genus := extract_rank(lineage, "g")]
taxonomy[is.na(phylum), phylum := "Unclassified"]
taxonomy[, phylum_display := fifelse(
  phylum %chin% names(phage_uv_phylum_colours),
  phylum,
  "Other"
)]
taxonomy <- taxonomy[, .(MAG_ID, phylum, phylum_display, genus)]

message("Building MAG-level metagenomic abundance matrix...")
mg_path <- file.path(
  data_root,
  "quantification",
  "mags_votu",
  "coverage",
  "metagenomics",
  "coverm",
  "output-Read_Count.tsv"
)
mg <- fread(mg_path, showProgress = FALSE)
mg_sample_columns <- setdiff(names(mg), "Contig")
mg_sample_codes <- sub("__MG__.*$", "", mg_sample_columns)
mg_library <- data.table(
  sample_code = mg_sample_codes,
  mg_library_total = vapply(mg[, ..mg_sample_columns], sum, numeric(1), na.rm = TRUE)
)
mg <- mg[grepl("_MAGScoT_cleanbin_", Contig, fixed = TRUE)]
mg[, MAG_ID := sub(
  "^(.+_MAGScoT_cleanbin_[0-9]+)_.*$",
  "\\1",
  Contig
)]
mg_mag <- mg[, lapply(.SD, sum, na.rm = TRUE), by = MAG_ID, .SDcols = mg_sample_columns]
mg_long <- melt(
  mg_mag,
  id.vars = "MAG_ID",
  variable.name = "sample_column",
  value.name = "mg_count"
)
mg_name_map <- data.table(sample_column = mg_sample_columns, sample_code = mg_sample_codes)
mg_long <- mg_name_map[mg_long, on = "sample_column"]
mg_long <- mg_library[mg_long, on = "sample_code"]
mg_long[, mg_cpm := mg_count / mg_library_total * 1e6]
fwrite(mg_long, file.path(tables_dir, "mag_metagenomic_abundance.tsv"), sep = "\t")
rm(mg, mg_mag)
gc()

message("Building MAG-level DNA-damage transcription matrices...")
hits <- fread(file.path(data_root, "community_uv_response", "uv_signature_hits.tsv"))
hits <- unique(hits[
  entity_type == "MAG",
  .(gene_id, MAG_ID, signature_tier, signature_category)
])
module_map <- rbindlist(list(
  unique(hits[
    signature_category == "SOS_response",
    .(gene_id, MAG_ID, module = "SOS_response")
  ]),
  unique(hits[
    signature_tier %in% c(1L, 2L),
    .(gene_id, MAG_ID, module = "DNA_damage_core")
  ])
))
module_map <- unique(module_map)
module_gene_ids <- unique(module_map$gene_id)

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

read_module_counts <- function(path) {
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
  counts <- counts[gene_id %chin% module_gene_ids]
  counts <- module_map[counts, on = "gene_id", allow.cartesian = TRUE]
  summary <- counts[, .(module_count = sum(read_count, na.rm = TRUE)), by = .(
    MAG_ID,
    module
  )]
  summary[, `:=`(
    sample_code = sample_code,
    run_accession = run_accession,
    mt_library_total = library_total
  )]
  summary[]
}

run_module_counts <- rbindlist(lapply(coverage_files, read_module_counts), use.names = TRUE)
run_libraries <- unique(run_module_counts[, .(sample_code, run_accession, mt_library_total)])
sample_libraries <- run_libraries[, .(mt_library_total = sum(mt_library_total)), by = sample_code]
sample_module_counts <- run_module_counts[, .(
  module_count = sum(module_count)
), by = .(sample_code, MAG_ID, module)]
sample_module_counts <- sample_libraries[sample_module_counts, on = "sample_code"]

all_mag_samples <- CJ(
  sample_code = sort(unique(mg_long$sample_code)),
  MAG_ID = sort(unique(taxonomy$MAG_ID)),
  module = sort(unique(module_map$module)),
  unique = TRUE
)
sample_module_counts <- sample_module_counts[all_mag_samples, on = .(sample_code, MAG_ID, module)]
sample_module_counts[is.na(module_count), module_count := 0]
sample_module_counts <- sample_libraries[sample_module_counts, on = "sample_code"]
sample_module_counts[, mt_cpm := module_count / mt_library_total * 1e6]
sample_module_counts <- mg_long[
  sample_module_counts,
  on = .(sample_code, MAG_ID)
]
sample_module_counts <- parse_sample(unique(sample_module_counts$sample_code))[
  sample_module_counts,
  on = "sample_code"
]
sample_module_counts[, activity_log2_rna_dna := log2(
  ((module_count + 0.5) / mt_library_total) /
    ((mg_count + 0.5) / mg_library_total)
)]
fwrite(
  sample_module_counts,
  file.path(tables_dir, "mag_dna_damage_rna_dna_activity.tsv"),
  sep = "\t"
)

detection <- sample_module_counts[, .(
  total_module_reads = sum(module_count),
  n_mt_detected_samples = sum(module_count > 0),
  n_mg_detected_samples = sum(mg_count > 0)
), by = .(MAG_ID, module)]
detection[, eligible := (
  total_module_reads >= 100 &
    n_mt_detected_samples >= 6 &
    n_mg_detected_samples >= 6
)]
fwrite(detection, file.path(tables_dir, "mag_temporal_cluster_eligibility.tsv"), sep = "\t")

activity_effect <- dcast(
  sample_module_counts,
  MAG_ID + module + phase + cycle ~ condition,
  value.var = "activity_log2_rna_dna"
)
activity_effect[, treatment_control_effect := treatment - control]
activity_effect <- detection[activity_effect, on = .(MAG_ID, module)]
activity_effect <- taxonomy[activity_effect, on = "MAG_ID"]
fwrite(
  activity_effect,
  file.path(tables_dir, "mag_dna_damage_treatment_control_effect.tsv"),
  sep = "\t"
)

community_activity <- sample_module_counts[, .(
  module_count = sum(module_count),
  mg_count = sum(mg_count),
  mt_library_total = unique(mt_library_total),
  mg_library_total = unique(mg_library_total)
), by = .(sample_code, condition, phase, cycle, module)]
community_activity[, activity_log2_rna_dna := log2(
  ((module_count + 0.5) / mt_library_total) /
    ((mg_count + 0.5) / mg_library_total)
)]
community_effect <- dcast(
  community_activity,
  phase + cycle + module ~ condition,
  value.var = "activity_log2_rna_dna"
)
community_effect[, treatment_control_effect := treatment - control]

community_tests <- community_effect[, {
  trend <- exact_phase_blocked_slope(cycle, phase, treatment_control_effect)
  positive <- sum(treatment_control_effect > 0)
  .(
    n_phase_cycle_pairs = .N,
    n_positive_pairs = positive,
    median_treatment_control_effect = median(treatment_control_effect),
    temporal_slope_per_cycle = trend$slope,
    temporal_exact_p = trend$exact_p,
    direction_sign_test_p = binom.test(
      positive,
      .N,
      p = 0.5,
      alternative = "two.sided"
    )$p.value
  )
}, by = module]
community_tests[, temporal_adjusted_p_bh := p.adjust(temporal_exact_p, method = "BH")]
community_tests[, direction_adjusted_p_bh := p.adjust(direction_sign_test_p, method = "BH")]
fwrite(
  community_effect,
  file.path(tables_dir, "community_rna_dna_temporal_effect.tsv"),
  sep = "\t"
)
fwrite(
  community_tests,
  file.path(tables_dir, "community_rna_dna_temporal_tests.tsv"),
  sep = "\t"
)

community_effect[, module_label := fifelse(
  module == "SOS_response",
  "SOS response",
  "Core DNA-damage response"
)]
community_effect[, phase := factor(phase, levels = c("initial", "backflush"))]
community_annotations <- copy(community_tests)
community_annotations[, module_label := fifelse(
  module == "SOS_response",
  "SOS response",
  "Core DNA-damage response"
)]
community_annotations[, label := sprintf(
  "direction: raw p = %.3f; BH q = %.3f\ntrend: exact p = %.3f; BH q = %.3f",
  direction_sign_test_p,
  direction_adjusted_p_bh,
  temporal_exact_p,
  temporal_adjusted_p_bh
)]
community_y_min <- min(community_effect$treatment_control_effect, na.rm = TRUE) - 0.08
community_y_max <- max(community_effect$treatment_control_effect, na.rm = TRUE) + 0.30
community_annotations[, annotation_y := community_y_max]
p_community <- ggplot(
  community_effect,
  aes(
    x = cycle,
    y = treatment_control_effect,
    colour = phase,
    shape = phase,
    group = phase
  )
) +
  geom_hline(yintercept = 0, colour = "#777777", linewidth = 0.35) +
  geom_line(linewidth = 0.7) +
  geom_point(size = 2.3) +
  geom_text(
    data = community_annotations,
    aes(x = 1, y = annotation_y, label = label),
    inherit.aes = FALSE,
    hjust = 0,
    vjust = 1,
    size = 2.55,
    lineheight = 0.95
  ) +
  facet_wrap(vars(module_label), nrow = 1L) +
  scale_colour_manual(values = c(
    initial = phage_uv_condition_colours[["treatment"]],
    backflush = "#4C78A8"
  )) +
  scale_shape_manual(values = phage_uv_phase_shapes) +
  scale_x_continuous(breaks = 1:3) +
  coord_cartesian(ylim = c(community_y_min, community_y_max)) +
  labs(
    x = "Sampled cleaning cycle",
    y = expression(log[2]("phage-UV / control RNA:DNA activity")),
    colour = "Phase",
    shape = "Phase"
  ) +
  theme_phage_uv() +
  theme(
    panel.grid.major.y = element_line(colour = "#E6E6E6", linewidth = 0.25),
    legend.position = "bottom"
  )
save_candidate("community-rna-dna-temporal-response", p_community, 8.2, 4.2)

message("Testing exact phase-blocked temporal slopes...")
module_temporal_tests <- activity_effect[
  eligible == TRUE,
  {
    test <- exact_phase_blocked_slope(cycle, phase, treatment_control_effect)
    .(
      temporal_slope_per_cycle = test$slope,
      exact_p = test$exact_p,
      mean_treatment_control_effect = mean(treatment_control_effect),
      min_treatment_control_effect = min(treatment_control_effect),
      max_treatment_control_effect = max(treatment_control_effect)
    )
  },
  by = .(MAG_ID, module, phylum, phylum_display, genus)
]
module_temporal_tests <- adjust_family(module_temporal_tests, "module")
fwrite(
  module_temporal_tests,
  file.path(tables_dir, "mag_temporal_slope_tests.tsv"),
  sep = "\t"
)

sos_continuous_summary <- module_temporal_tests[
  module == "SOS_response",
  .(
    MAG_ID,
    phylum,
    phylum_display,
    genus,
    mean_treatment_control_effect,
    min_treatment_control_effect,
    max_treatment_control_effect,
    temporal_slope_per_cycle,
    exact_p,
    adjusted_p_bh
  )
]
setorder(sos_continuous_summary, mean_treatment_control_effect, MAG_ID)
sos_continuous_summary[, response_rank := seq_len(.N)]
fwrite(
  sos_continuous_summary,
  file.path(tables_dir, "sos_mag_continuous_response_summary.tsv"),
  sep = "\t"
)

sos_heat <- activity_effect[
  module == "SOS_response" & eligible == TRUE
]
sos_heat <- sos_continuous_summary[
  sos_heat,
  on = c("MAG_ID", "phylum", "phylum_display", "genus")
]
sos_heat[, phase_cycle := factor(
  paste0(phase, "_cycle", cycle),
  levels = c(
    "initial_cycle1",
    "initial_cycle2",
    "initial_cycle3",
    "backflush_cycle1",
    "backflush_cycle2",
    "backflush_cycle3"
  ),
  labels = c("I1", "I2", "I3", "BF1", "BF2", "BF3")
)]
sos_heat[, response_rank := factor(response_rank, levels = rev(seq_len(uniqueN(MAG_ID))))]
sos_limit <- quantile(abs(sos_heat$treatment_control_effect), 0.98, na.rm = TRUE)
p_sos_heat <- ggplot(
  sos_heat,
  aes(
    x = phase_cycle,
    y = response_rank,
    fill = treatment_control_effect
  )
) +
  geom_tile() +
  scale_fill_gradient2(
    low = phage_uv_condition_colours[["control"]],
    mid = "white",
    high = phage_uv_condition_colours[["treatment"]],
    midpoint = 0,
    limits = c(-sos_limit, sos_limit),
    oob = squish
  ) +
  labs(
    x = "Phase and sampled cleaning cycle",
    y = "Eligible MAGs ordered by mean response",
    fill = expression(log[2]("phage-UV / control RNA:DNA"))
  ) +
  theme_phage_uv(base_size = 9) +
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    panel.grid = element_blank(),
    legend.position = "bottom"
  )
save_candidate("sos-mag-continuous-response-heatmap", p_sos_heat, 6.8, 7.6)

category_effect_path <- file.path(tables_dir, "uv_mt_paired_treatment_effect.tsv")
if (file.exists(category_effect_path)) {
  category_effect <- fread(category_effect_path)
  category_temporal <- category_effect[, {
    test <- exact_phase_blocked_slope(cycle, phase, log2_treatment_control)
    .(
      temporal_slope_per_cycle = test$slope,
      exact_p = test$exact_p,
      cycle1_mean = mean(log2_treatment_control[cycle == 1L]),
      cycle2_mean = mean(log2_treatment_control[cycle == 2L]),
      cycle3_mean = mean(log2_treatment_control[cycle == 3L])
    )
  }, by = .(signature_tier, signature_category)]
  category_temporal[, adjusted_p_bh := p.adjust(exact_p, method = "BH")]
  fwrite(
    category_temporal,
    file.path(tables_dir, "uv_category_temporal_slope_tests.tsv"),
    sep = "\t"
  )
}

sos_symbol_path <- file.path(tables_dir, "sos_mt_symbol_treatment_effect.tsv")
if (file.exists(sos_symbol_path)) {
  sos_symbol_effect <- fread(sos_symbol_path)
  sos_symbol_temporal <- sos_symbol_effect[, {
    test <- exact_phase_blocked_slope(cycle, phase, log2_treatment_control)
    .(
      temporal_slope_per_cycle = test$slope,
      exact_p = test$exact_p,
      cycle1_mean = mean(log2_treatment_control[cycle == 1L]),
      cycle2_mean = mean(log2_treatment_control[cycle == 2L]),
      cycle3_mean = mean(log2_treatment_control[cycle == 3L])
    )
  }, by = signature_gene_symbol]
  sos_symbol_temporal[, adjusted_p_bh := p.adjust(exact_p, method = "BH")]
  fwrite(
    sos_symbol_temporal,
    file.path(tables_dir, "sos_marker_temporal_slope_tests.tsv"),
    sep = "\t"
  )
}

adjusted_rand_index <- function(a, b) {
  tab <- table(a, b)
  choose2 <- function(x) x * (x - 1) / 2
  sum_nij <- sum(choose2(tab))
  sum_ai <- sum(choose2(rowSums(tab)))
  sum_bj <- sum(choose2(colSums(tab)))
  n <- sum(tab)
  expected <- sum_ai * sum_bj / choose2(n)
  maximum <- (sum_ai + sum_bj) / 2
  if (maximum == expected) return(1)
  (sum_nij - expected) / (maximum - expected)
}

cluster_palette <- c(
  `1` = "#4E79A7",
  `2` = "#F28E2B",
  `3` = "#59A14F",
  `4` = "#E15759",
  `5` = "#B07AA1",
  `6` = "#76B7B2"
)

cluster_results <- list()
cluster_diagnostics <- list()

for (module_name in sort(unique(activity_effect$module))) {
  current <- activity_effect[module == module_name & eligible == TRUE]
  current[, phase_cycle := paste0(phase, "_cycle", cycle)]
  wide <- dcast(
    current,
    MAG_ID ~ phase_cycle,
    value.var = "treatment_control_effect"
  )
  feature_order <- c(
    "initial_cycle1",
    "initial_cycle2",
    "initial_cycle3",
    "backflush_cycle1",
    "backflush_cycle2",
    "backflush_cycle3"
  )
  feature_order <- feature_order[feature_order %chin% names(wide)]
  matrix_raw <- as.matrix(wide[, ..feature_order])
  rownames(matrix_raw) <- wide$MAG_ID
  complete <- complete.cases(matrix_raw)
  matrix_raw <- matrix_raw[complete, , drop = FALSE]
  row_sd <- apply(matrix_raw, 1L, sd)
  matrix_raw <- matrix_raw[row_sd > 1e-8, , drop = FALSE]
  matrix_shape <- t(scale(t(matrix_raw)))

  if (nrow(matrix_shape) < 12L) next

  distance <- dist(matrix_shape)
  tree <- hclust(distance, method = "ward.D2")
  k_candidates <- 2L:min(6L, nrow(matrix_shape) - 1L)
  diagnostics <- rbindlist(lapply(k_candidates, function(k) {
    membership <- cutree(tree, k = k)
    sizes <- table(membership)
    silhouette_mean <- mean(silhouette(membership, distance)[, "sil_width"])
    data.table(
      module = module_name,
      k = k,
      mean_silhouette = silhouette_mean,
      minimum_cluster_size = min(sizes),
      eligible_k = min(sizes) >= 5L
    )
  }))
  usable <- diagnostics[eligible_k == TRUE]
  selected_k <- if (nrow(usable)) {
    usable[which.max(mean_silhouette)]$k
  } else {
    diagnostics[which.max(mean_silhouette)]$k
  }
  membership <- cutree(tree, k = selected_k)

  leave_one_out_ari <- vapply(seq_len(ncol(matrix_shape)), function(drop_column) {
    reduced <- matrix_shape[, -drop_column, drop = FALSE]
    reduced_tree <- hclust(dist(reduced), method = "ward.D2")
    reduced_membership <- cutree(reduced_tree, k = selected_k)
    adjusted_rand_index(membership, reduced_membership)
  }, numeric(1))
  diagnostics[, `:=`(
    selected = k == selected_k,
    leave_one_stratum_out_median_ari = median(leave_one_out_ari),
    leave_one_stratum_out_min_ari = min(leave_one_out_ari)
  )]
  cluster_diagnostics[[module_name]] <- diagnostics

  membership_table <- data.table(
    MAG_ID = names(membership),
    module = module_name,
    cluster = as.integer(membership)
  )
  membership_table <- taxonomy[membership_table, on = "MAG_ID"]
  magnitude <- data.table(
    MAG_ID = rownames(matrix_raw),
    mean_effect = rowMeans(matrix_raw),
    temporal_amplitude = apply(matrix_raw, 1L, function(x) max(x) - min(x))
  )
  membership_table <- magnitude[membership_table, on = "MAG_ID"]
  membership_table <- detection[membership_table, on = .(MAG_ID, module)]
  cluster_results[[module_name]] <- membership_table

  plot_data <- current[membership_table, on = .(MAG_ID, module)]
  plot_data[, cluster := factor(cluster)]
  centroid <- plot_data[, .(
    median_effect = median(treatment_control_effect),
    q25 = quantile(treatment_control_effect, 0.25),
    q75 = quantile(treatment_control_effect, 0.75),
    n_mags = uniqueN(MAG_ID)
  ), by = .(cluster, phase, cycle)]

  p_centroid <- ggplot(
    centroid,
    aes(
      x = cycle,
      y = median_effect,
      colour = cluster,
      fill = cluster,
      group = cluster
    )
  ) +
    geom_hline(yintercept = 0, colour = "#777777", linewidth = 0.35) +
    geom_ribbon(aes(ymin = q25, ymax = q75), alpha = 0.14, colour = NA) +
    geom_line(linewidth = 0.75) +
    geom_point(size = 2.1) +
    facet_wrap(vars(phase), nrow = 1L) +
    scale_colour_manual(values = cluster_palette) +
    scale_fill_manual(values = cluster_palette) +
    scale_x_continuous(breaks = 1:3) +
    labs(
      x = "Sampled cleaning cycle",
      y = expression(log[2]("phage-UV / control RNA:DNA activity")),
      colour = "Trajectory cluster",
      fill = "Trajectory cluster"
    ) +
    theme_phage_uv() +
    theme(
      panel.grid.major.y = element_line(colour = "#E6E6E6", linewidth = 0.25),
      legend.position = "bottom"
    )
  save_candidate(
    paste0(tolower(module_name), "-trajectory-clusters"),
    p_centroid,
    7.5,
    4.2
  )

  row_order <- names(membership)[order(membership, match(names(membership), tree$labels[tree$order]))]
  heat <- current[MAG_ID %chin% row_order]
  heat[, MAG_ID := factor(MAG_ID, levels = rev(row_order))]
  heat <- membership_table[heat, on = c("MAG_ID", "module")]
  heat[, cluster := factor(cluster)]
  limit <- max(abs(heat$treatment_control_effect), na.rm = TRUE)
  p_heat <- ggplot(
    heat,
    aes(x = cycle, y = MAG_ID, fill = treatment_control_effect)
  ) +
    geom_tile() +
    facet_grid(
      rows = vars(cluster),
      cols = vars(phase),
      scales = "free_y",
      space = "free_y"
    ) +
    scale_fill_gradient2(
      low = phage_uv_condition_colours[["control"]],
      mid = "white",
      high = phage_uv_condition_colours[["treatment"]],
      midpoint = 0,
      limits = c(-limit, limit),
      oob = squish
    ) +
    scale_x_continuous(breaks = 1:3) +
    labs(
      x = "Sampled cleaning cycle",
      y = NULL,
      fill = expression(log[2]("phage-UV / control RNA:DNA"))
    ) +
    theme_phage_uv(base_size = 8) +
    theme(
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      panel.spacing.y = grid::unit(0.35, "lines"),
      legend.position = "bottom"
    )
  save_candidate(
    paste0(tolower(module_name), "-trajectory-heatmap"),
    p_heat,
    7.5,
    8.8
  )
}

cluster_membership <- rbindlist(cluster_results, use.names = TRUE, fill = TRUE)
cluster_diagnostic_table <- rbindlist(cluster_diagnostics, use.names = TRUE, fill = TRUE)
fwrite(
  cluster_membership,
  file.path(tables_dir, "mag_temporal_cluster_membership.tsv"),
  sep = "\t"
)
fwrite(
  cluster_diagnostic_table,
  file.path(tables_dir, "mag_temporal_cluster_diagnostics.tsv"),
  sep = "\t"
)

if (nrow(cluster_membership)) {
  taxon_tests <- cluster_membership[, {
    module_total <- cluster_membership[module == .BY$module, .N]
    cluster_total <- cluster_membership[module == .BY$module & cluster == .BY$cluster, .N]
    phylum_total <- cluster_membership[module == .BY$module & phylum_display == .BY$phylum_display, .N]
    in_both <- .N
    matrix_2x2 <- matrix(
      c(
        in_both,
        cluster_total - in_both,
        phylum_total - in_both,
        module_total - cluster_total - phylum_total + in_both
      ),
      nrow = 2L
    )
    .(
      cluster_n = cluster_total,
      phylum_n = phylum_total,
      overlap_n = in_both,
      odds_ratio = unname(fisher.test(matrix_2x2)$estimate),
      fisher_p = fisher.test(matrix_2x2)$p.value
    )
  }, by = .(module, cluster, phylum_display)]
  taxon_tests[, adjusted_p_bh := p.adjust(fisher_p, method = "BH"), by = module]
  fwrite(
    taxon_tests,
    file.path(tables_dir, "mag_cluster_taxonomic_enrichment.tsv"),
    sep = "\t"
  )

  taxon_composition <- cluster_membership[, .N, by = .(module, cluster, phylum_display)]
  taxon_composition[, proportion := N / sum(N), by = .(module, cluster)]
  taxon_composition[, cluster := factor(cluster)]
  p_taxa <- ggplot(
    taxon_composition,
    aes(x = cluster, y = proportion, fill = phylum_display)
  ) +
    geom_col(width = 0.72, colour = "white", linewidth = 0.15) +
    facet_wrap(vars(module), scales = "free_x") +
    scale_fill_manual(values = phage_uv_phylum_colours, drop = FALSE) +
    scale_y_continuous(labels = percent_format()) +
    labs(
      x = "Trajectory cluster",
      y = "MAG composition",
      fill = "Phylum"
    ) +
    theme_phage_uv() +
    theme(
      axis.text.x = element_text(angle = 0),
      legend.position = "right"
    )
  save_candidate("temporal-cluster-taxonomic-composition", p_taxa, 9, 4.8)
}

message("Testing scoped SNV temporal summaries...")
snv_path <- file.path(
  data_root,
  "community_uv_response",
  "variant_analysis",
  "instrain_priority_20",
  "tables",
  "priority20_instrain_compare_summary.tsv"
)
snv <- fread(snv_path)
snv_cycle <- snv[
  condition_a == condition_b &
    phase_a == phase_b &
    cycle_a != cycle_b
]
snv_cycle[, cycle_gap := abs(as.integer(cycle_b) - as.integer(cycle_a))]

snv_condition_mag <- snv_cycle[, .(
  mean_snv_distance = mean(SNV_distance),
  n_pairs = .N
), by = .(MAG_ID, condition = condition_a)]
snv_condition_wide <- dcast(
  snv_condition_mag,
  MAG_ID ~ condition,
  value.var = "mean_snv_distance"
)
snv_condition_complete <- snv_condition_wide[complete.cases(control, uv)]

snv_gap_mag <- snv_cycle[, .(
  mean_snv_distance = mean(SNV_distance),
  n_pairs = .N
), by = .(MAG_ID, cycle_gap)]
snv_gap_wide <- dcast(
  snv_gap_mag,
  MAG_ID ~ cycle_gap,
  value.var = "mean_snv_distance"
)
if ("1" %chin% names(snv_gap_wide) && "2" %chin% names(snv_gap_wide)) {
  snv_gap_complete <- snv_gap_wide[complete.cases(`1`, `2`)]
} else {
  snv_gap_complete <- data.table()
}

snv_tests <- rbindlist(list(
  data.table(
    comparison = "within-MAG mean cycle SNV distance: phage-UV versus control",
    n_mags = nrow(snv_condition_complete),
    median_difference = if (nrow(snv_condition_complete)) median(
      snv_condition_complete$uv - snv_condition_complete$control
    ) else NA_real_,
    wilcoxon_p = if (nrow(snv_condition_complete) >= 3L) wilcox.test(
      snv_condition_complete$uv,
      snv_condition_complete$control,
      paired = TRUE,
      exact = FALSE
    )$p.value else NA_real_
  ),
  data.table(
    comparison = "within-MAG mean cycle SNV distance: two-cycle versus one-cycle separation",
    n_mags = nrow(snv_gap_complete),
    median_difference = if (nrow(snv_gap_complete)) median(
      snv_gap_complete[["2"]] - snv_gap_complete[["1"]]
    ) else NA_real_,
    wilcoxon_p = if (nrow(snv_gap_complete) >= 3L) wilcox.test(
      snv_gap_complete[["2"]],
      snv_gap_complete[["1"]],
      paired = TRUE,
      exact = FALSE
    )$p.value else NA_real_
  )
))
snv_tests[, adjusted_p_bh := p.adjust(wilcoxon_p, method = "BH")]
fwrite(snv_cycle, file.path(tables_dir, "snv_within_condition_phase_cycle_pairs.tsv"), sep = "\t")
fwrite(snv_tests, file.path(tables_dir, "snv_temporal_sensitivity_tests.tsv"), sep = "\t")

analysis_manifest <- data.table(
  analysis = c(
    "category temporal trend",
    "SOS-marker temporal trend",
    "MAG RNA:DNA temporal trend",
    "MAG trajectory clustering stability audit",
    "cluster taxonomic enrichment diagnostic",
    "SNV temporal sensitivity"
  ),
  inference_level = c(
    "exploratory phase-blocked exact permutation",
    "exploratory phase-blocked exact permutation",
    "exploratory phase-blocked exact permutation",
    "descriptive unsupervised stability audit; no stable configuration found",
    "diagnostic only; not interpretable because clusters were unstable",
    "exploratory MAG-aggregated paired Wilcoxon"
  ),
  multiplicity_family = c(
    "8 pre-defined UV-response categories",
    "7 pre-defined SOS markers",
    "eligible MAGs within each response module",
    "not applicable",
    "all cluster-by-phylum tests within response module",
    "2 pre-defined SNV sensitivity comparisons"
  ),
  experimental_unit_caveat = "One control membrane and one treated membrane; cycles are repeated observations, not independent biological replicates"
)
fwrite(
  analysis_manifest,
  file.path(out_root, "temporal_analysis_manifest.tsv"),
  sep = "\t"
)

message("Wrote temporal-response analysis to: ", out_root)
