signed_ql_statistic <- function(log_fc, f_statistic) {
  if (length(log_fc) != length(f_statistic)) {
    stop("logFC and F vectors must have equal length", call. = FALSE)
  }
  sign(log_fc) * sqrt(pmax(f_statistic, 0))
}

extract_lineage_rank <- function(lineage, prefix) {
  pieces <- strsplit(ifelse(is.na(lineage), "", lineage), ";", fixed = TRUE)
  vapply(pieces, function(x) {
    hit <- x[startsWith(x, prefix)]
    if (!length(hit)) return(NA_character_)
    sub(paste0("^", prefix), "", hit[[1]])
  }, character(1))
}

classify_recurrence <- function(effect_matrix, minimum_concordant = 5L,
                                minimum_median_absolute_effect = 1) {
  effect_matrix <- as.matrix(effect_matrix)
  positive <- rowSums(effect_matrix > 0, na.rm = TRUE)
  negative <- rowSums(effect_matrix < 0, na.rm = TRUE)
  dominant <- pmax(positive, negative)
  median_effect <- matrixStats::rowMedians(effect_matrix, na.rm = TRUE)
  recurrent <- dominant >= minimum_concordant &
    abs(median_effect) >= minimum_median_absolute_effect
  data.table::data.table(
    n_positive_cells = positive,
    n_negative_cells = negative,
    dominant_direction_cells = dominant,
    median_cell_log2cpm_difference = median_effect,
    recurrence_class = ifelse(
      recurrent & median_effect > 0,
      "recurrent_treatment_higher",
      ifelse(recurrent & median_effect < 0, "recurrent_control_higher", "heterogeneous_or_small")
    )
  )
}

run_camera_pr <- function(statistic, index_sets, directional = TRUE,
                          minimum_size = 10L, correlation = 0.01) {
  sizes <- lengths(index_sets)
  eligible <- index_sets[sizes >= minimum_size]
  if (!length(eligible)) return(data.table::data.table())
  result <- limma::cameraPR(
    statistic,
    eligible,
    use.ranks = TRUE,
    inter.gene.cor = correlation,
    sort = FALSE,
    directional = directional
  )
  result <- data.table::as.data.table(result, keep.rownames = "set_id")
  result[, FDR := p.adjust(PValue, method = "BH")]
  result
}
