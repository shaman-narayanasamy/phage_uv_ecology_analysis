#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(data.table)
  library(limma)
  library(matrixStats)
})
source("R/full_de_interpretation_functions.R")

expect_true <- function(value, message) {
  if (!isTRUE(value)) stop(message, call. = FALSE)
}

stats <- signed_ql_statistic(c(-2, 0, 3), c(4, 9, 16))
expect_true(identical(stats, c(-2, 0, 4)), "Signed QL statistic changed")

lineages <- c(
  "root;d__Bacteria;p__Bacteroidota;c__Bacteroidia",
  "root;d__Archaea;p__Halobacteriota",
  NA_character_
)
expect_true(
  identical(extract_lineage_rank(lineages, "p__"), c("Bacteroidota", "Halobacteriota", NA_character_)),
  "Lineage rank parsing failed"
)

effects <- rbind(
  c(2, 1.5, 1.2, 2.1, 0.8, -0.1),
  c(-2, -1.5, -1.2, -2.1, -0.8, 0.1),
  c(2, -2, 2, -2, 2, -2),
  c(0.2, 0.1, 0.2, 0.1, 0.2, 0.1)
)
recurrence <- classify_recurrence(effects)
expect_true(recurrence$recurrence_class[[1]] == "recurrent_treatment_higher", "Positive recurrence failed")
expect_true(recurrence$recurrence_class[[2]] == "recurrent_control_higher", "Negative recurrence failed")
expect_true(all(recurrence$recurrence_class[3:4] == "heterogeneous_or_small"), "Heterogeneous/small classification failed")

set.seed(23)
statistic <- c(rnorm(20, 3, 0.2), rnorm(80))
sets <- list(signal = 1:20, small = 21:25)
camera <- run_camera_pr(statistic, sets, directional = TRUE, minimum_size = 10L)
expect_true(nrow(camera) == 1L && camera$set_id[[1]] == "signal", "Gene-set size threshold failed")
expect_true(camera$FDR[[1]] < 0.05, "Synthetic coherent gene set was not detected")

cat("test_full_de_interpretation.R: PASS\n")
