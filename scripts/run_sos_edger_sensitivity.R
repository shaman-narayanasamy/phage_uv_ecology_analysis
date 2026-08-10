#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(data.table)
  library(edgeR)
})

args <- commandArgs(trailingOnly = TRUE)
data_root <- if (length(args) >= 1L) args[[1L]] else Sys.getenv("PHAGE_UV_DATA_ROOT")
out_root <- if (length(args) >= 2L) args[[2L]] else file.path(data_root, "derived", "manuscript_candidates")
tables_dir <- file.path(out_root, "tables")

sample_gene_path <- file.path(tables_dir, "sos_mt_sample_gene_cpm.tsv")
if (!file.exists(sample_gene_path)) {
  stop("Missing SOS sample-gene table: ", sample_gene_path)
}

counts_long <- fread(sample_gene_path)
counts_long <- counts_long[, .(
  read_count = max(read_count),
  library_total = max(library_total)
), by = .(sample_code, gene_id, MAG_ID)]

sample_info <- unique(counts_long[, .(sample_code, library_total)])
sample_info[, condition := factor(
  fifelse(substr(sample_code, 1L, 1L) == "C", "control", "treatment"),
  levels = c("control", "treatment")
)]
sample_info[, phase := factor(
  fifelse(grepl("BF", sample_code, fixed = TRUE), "backflush", "initial"),
  levels = c("initial", "backflush")
)]
sample_info[, cycle_factor := factor(as.integer(sub(".*([123])$", "\\1", sample_code)))]
sample_info[, cycle_numeric := as.numeric(as.character(cycle_factor))]
setorder(sample_info, condition, phase, cycle_factor)

counts_wide <- dcast(
  counts_long,
  gene_id + MAG_ID ~ sample_code,
  value.var = "read_count",
  fill = 0
)
count_columns <- sample_info$sample_code
count_matrix <- as.matrix(counts_wide[, ..count_columns])
rownames(count_matrix) <- counts_wide$gene_id

y <- DGEList(
  counts = count_matrix,
  lib.size = sample_info$library_total,
  genes = counts_wide[, .(gene_id, MAG_ID)]
)
y$samples$norm.factors <- 1

design_main <- model.matrix(
  ~ phase + cycle_factor + condition,
  data = sample_info
)
keep <- filterByExpr(y, design = design_main, min.count = 5)
y <- y[keep, , keep.lib.sizes = FALSE]
y$samples$lib.size <- sample_info$library_total
y$samples$norm.factors <- 1

fit_test <- function(y, design, coefficients, test_name) {
  y_current <- estimateDisp(y, design, robust = TRUE)
  fit <- glmQLFit(y_current, design, robust = TRUE)
  test <- glmQLFTest(fit, coef = coefficients)
  result <- as.data.table(topTags(test, n = Inf, sort.by = "none")$table)
  result[, test := test_name]
  result[]
}

condition_coef <- grep("^condition", colnames(design_main))
main_result <- fit_test(
  y,
  design_main,
  condition_coef,
  "condition_main_effect"
)

design_interaction <- model.matrix(
  ~ phase + cycle_factor * condition,
  data = sample_info
)
interaction_coefs <- grep("cycle_factor.*:condition|condition.*:cycle_factor", colnames(design_interaction))
interaction_result <- fit_test(
  y,
  design_interaction,
  interaction_coefs,
  "condition_by_cycle_factor_interaction"
)

design_trend <- model.matrix(
  ~ phase + condition * cycle_numeric,
  data = sample_info
)
trend_coef <- grep("condition.*:cycle_numeric|cycle_numeric.*:condition", colnames(design_trend))
trend_result <- fit_test(
  y,
  design_trend,
  trend_coef,
  "condition_by_linear_cycle_interaction"
)

all_results <- rbindlist(
  list(main_result, interaction_result, trend_result),
  use.names = TRUE,
  fill = TRUE
)

gene_map <- unique(fread(file.path(
  data_root,
  "community_uv_response",
  "uv_signature_hits.tsv"
))[
  entity_type == "MAG" & signature_category == "SOS_response",
  .(gene_id, MAG_ID, signature_gene_symbol)
])
gene_symbols <- gene_map[, .(
  signature_gene_symbol = paste(sort(unique(signature_gene_symbol)), collapse = ";")
), by = .(gene_id, MAG_ID)]

taxonomy_path <- file.path(tables_dir, "mag_taxonomy_crosswalk.tsv")
taxonomy <- fread(taxonomy_path)[, .(MAG_ID, phylum, genus)]
all_results <- merge(
  all_results,
  gene_symbols,
  by = c("gene_id", "MAG_ID"),
  all.x = TRUE,
  sort = FALSE
)
all_results <- merge(
  all_results,
  taxonomy,
  by = "MAG_ID",
  all.x = TRUE,
  sort = FALSE
)
all_results[, inference_caveat := paste(
  "Exploratory technical-model sensitivity only:",
  "one control membrane and one phage-UV-treated membrane;",
  "repeated cycles and technical sequencing runs do not create independent treatment replication"
)]

family_summary <- all_results[, .(
  n_tested_genes = .N,
  n_fdr_0_05 = sum(FDR <= 0.05, na.rm = TRUE),
  n_fdr_0_05_positive = sum(FDR <= 0.05 & logFC > 0, na.rm = TRUE),
  n_fdr_0_05_negative = sum(FDR <= 0.05 & logFC < 0, na.rm = TRUE),
  median_logFC = median(logFC, na.rm = TRUE)
), by = test]
family_summary[, inference_caveat := paste(
  "Exploratory technical-model sensitivity only;",
  "not population-level causal differential expression"
)]

main_by_mag_symbol <- all_results[
  test == "condition_main_effect",
  .(mean_logFC = mean(logFC, na.rm = TRUE)),
  by = .(MAG_ID, signature_gene_symbol)
]
symbol_direction <- main_by_mag_symbol[, {
  n_positive <- sum(mean_logFC > 0)
  .(
    n_mags = .N,
    n_positive_mags = n_positive,
    median_mag_logFC = median(mean_logFC),
    sign_test_p = binom.test(
      n_positive,
      .N,
      p = 0.5,
      alternative = "two.sided"
    )$p.value
  )
}, by = signature_gene_symbol]
symbol_direction[, adjusted_p_bh := p.adjust(sign_test_p, method = "BH")]
symbol_direction[, absolute_median_mag_logFC := abs(median_mag_logFC)]
setorder(symbol_direction, adjusted_p_bh, -absolute_median_mag_logFC)

fwrite(
  sample_info,
  file.path(tables_dir, "sos_edger_sample_design.tsv"),
  sep = "\t"
)
fwrite(
  all_results,
  file.path(tables_dir, "sos_edger_sensitivity_gene_results.tsv"),
  sep = "\t"
)
fwrite(
  family_summary,
  file.path(tables_dir, "sos_edger_sensitivity_summary.tsv"),
  sep = "\t"
)
fwrite(
  symbol_direction,
  file.path(tables_dir, "sos_edger_symbol_direction_tests.tsv"),
  sep = "\t"
)

message("Wrote explicitly exploratory edgeR sensitivity results.")
