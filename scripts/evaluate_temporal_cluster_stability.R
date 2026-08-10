#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(data.table)
  library(cluster)
})

args <- commandArgs(trailingOnly = TRUE)
data_root <- if (length(args) >= 1L) args[[1L]] else Sys.getenv("PHAGE_UV_DATA_ROOT")
out_root <- if (length(args) >= 2L) args[[2L]] else file.path(data_root, "derived", "manuscript_candidates")
tables_dir <- file.path(out_root, "tables")

if (!dir.exists(tables_dir)) {
  stop("Temporal-analysis tables are missing: ", tables_dir)
}

set.seed(79569)

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

cluster_matrix <- function(x, algorithm, k) {
  if (algorithm == "ward") {
    return(cutree(hclust(dist(x), method = "ward.D2"), k = k))
  }
  if (algorithm == "pam") {
    return(pam(x, k = k, cluster.only = TRUE))
  }
  if (algorithm == "kmeans") {
    return(kmeans(x, centers = k, nstart = 100, iter.max = 200)$cluster)
  }
  stop("Unknown clustering algorithm: ", algorithm)
}

standardize_rows <- function(x) {
  row_sd <- apply(x, 1L, sd)
  x <- x[row_sd > 1e-8 & complete.cases(x), , drop = FALSE]
  t(scale(t(x)))
}

evaluate_space <- function(matrix_shape, module, space) {
  algorithms <- c("ward", "pam", "kmeans")
  k_values <- 2:6
  cycle_groups <- sub(".*cycle", "cycle", colnames(matrix_shape))
  results <- list()
  memberships <- list()

  for (k in k_values) {
    full_memberships <- lapply(algorithms, function(algorithm) {
      cluster_matrix(matrix_shape, algorithm, k)
    })
    names(full_memberships) <- algorithms

    cross_algorithm_aris <- c(
      adjusted_rand_index(full_memberships$ward, full_memberships$pam),
      adjusted_rand_index(full_memberships$ward, full_memberships$kmeans),
      adjusted_rand_index(full_memberships$pam, full_memberships$kmeans)
    )

    for (algorithm in algorithms) {
      membership <- full_memberships[[algorithm]]
      silhouette_mean <- mean(silhouette(membership, dist(matrix_shape))[, "sil_width"])
      leave_cycle_aris <- vapply(unique(cycle_groups), function(cycle_name) {
        reduced <- matrix_shape[, cycle_groups != cycle_name, drop = FALSE]
        reduced_membership <- cluster_matrix(reduced, algorithm, k)
        adjusted_rand_index(membership, reduced_membership)
      }, numeric(1))

      results[[paste(module, space, algorithm, k, sep = "__")]] <- data.table(
        module = module,
        feature_space = space,
        algorithm = algorithm,
        k = k,
        n_mags = nrow(matrix_shape),
        minimum_cluster_size = min(table(membership)),
        mean_silhouette = silhouette_mean,
        median_cross_algorithm_ari = median(cross_algorithm_aris),
        minimum_cross_algorithm_ari = min(cross_algorithm_aris),
        median_leave_one_cycle_out_ari = median(leave_cycle_aris),
        minimum_leave_one_cycle_out_ari = min(leave_cycle_aris)
      )
      memberships[[paste(module, space, algorithm, k, sep = "__")]] <- data.table(
        MAG_ID = rownames(matrix_shape),
        module = module,
        feature_space = space,
        algorithm = algorithm,
        k = k,
        cluster = as.integer(membership)
      )
    }
  }

  list(
    diagnostics = rbindlist(results),
    memberships = rbindlist(memberships)
  )
}

activity <- fread(file.path(tables_dir, "mag_dna_damage_rna_dna_activity.tsv"))
effect <- fread(file.path(tables_dir, "mag_dna_damage_treatment_control_effect.tsv"))
eligibility <- fread(file.path(tables_dir, "mag_temporal_cluster_eligibility.tsv"))

all_results <- list()
all_memberships <- list()

for (module_name in sort(unique(effect$module))) {
  eligible_mags <- eligibility[module == module_name & eligible == TRUE]$MAG_ID

  contrast <- effect[module == module_name & MAG_ID %chin% eligible_mags]
  contrast[, feature := paste0(phase, "_cycle", cycle)]
  contrast_wide <- dcast(
    contrast,
    MAG_ID ~ feature,
    value.var = "treatment_control_effect"
  )
  contrast_features <- c(
    "initial_cycle1",
    "initial_cycle2",
    "initial_cycle3",
    "backflush_cycle1",
    "backflush_cycle2",
    "backflush_cycle3"
  )
  contrast_matrix <- as.matrix(contrast_wide[, ..contrast_features])
  rownames(contrast_matrix) <- contrast_wide$MAG_ID
  contrast_matrix <- standardize_rows(contrast_matrix)
  contrast_result <- evaluate_space(
    contrast_matrix,
    module_name,
    "treatment_control_contrast"
  )
  all_results[[paste0(module_name, "_contrast")]] <- contrast_result$diagnostics
  all_memberships[[paste0(module_name, "_contrast")]] <- contrast_result$memberships

  full <- activity[module == module_name & MAG_ID %chin% eligible_mags]
  full[, feature := paste0(condition, "_", phase, "_cycle", cycle)]
  full_wide <- dcast(
    full,
    MAG_ID ~ feature,
    value.var = "activity_log2_rna_dna"
  )
  full_features <- c(
    "control_initial_cycle1",
    "control_initial_cycle2",
    "control_initial_cycle3",
    "control_backflush_cycle1",
    "control_backflush_cycle2",
    "control_backflush_cycle3",
    "treatment_initial_cycle1",
    "treatment_initial_cycle2",
    "treatment_initial_cycle3",
    "treatment_backflush_cycle1",
    "treatment_backflush_cycle2",
    "treatment_backflush_cycle3"
  )
  full_matrix <- as.matrix(full_wide[, ..full_features])
  rownames(full_matrix) <- full_wide$MAG_ID
  full_matrix <- standardize_rows(full_matrix)
  full_result <- evaluate_space(
    full_matrix,
    module_name,
    "all_sample_activity"
  )
  all_results[[paste0(module_name, "_full")]] <- full_result$diagnostics
  all_memberships[[paste0(module_name, "_full")]] <- full_result$memberships
}

diagnostics <- rbindlist(all_results)
diagnostics[, passes_minimum_cluster_size := minimum_cluster_size >= 5L]
diagnostics[, stable := (
  passes_minimum_cluster_size &
    mean_silhouette >= 0.25 &
    median_cross_algorithm_ari >= 0.60 &
    median_leave_one_cycle_out_ari >= 0.60
)]
setorder(
  diagnostics,
  module,
  feature_space,
  -stable,
  -mean_silhouette,
  -median_leave_one_cycle_out_ari
)

memberships <- rbindlist(all_memberships)
fwrite(
  diagnostics,
  file.path(tables_dir, "temporal_cluster_multimethod_diagnostics.tsv"),
  sep = "\t"
)
fwrite(
  memberships,
  file.path(tables_dir, "temporal_cluster_multimethod_memberships.tsv"),
  sep = "\t"
)

best <- diagnostics[, .SD[1L], by = .(module, feature_space)]
fwrite(
  best,
  file.path(tables_dir, "temporal_cluster_best_configurations.tsv"),
  sep = "\t"
)

message("Wrote multi-method temporal cluster stability diagnostics.")
