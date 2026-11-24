#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
outdir <- if (length(args) >= 1) args[[1]] else "metadata"
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)

outfile <- file.path(outdir, "mgnify_prjeb79569_status.json")
accession <- "PRJEB79569"

write_status <- function(status) {
  jsonlite::write_json(status, outfile, pretty = TRUE, auto_unbox = TRUE, null = "null")
  system2("shasum", c("-a", "256", outfile), stdout = paste0(outfile, ".sha256"))
  message("Wrote ", outfile, " and checksum")
}

if (!requireNamespace("jsonlite", quietly = TRUE)) {
  stop("jsonlite is required to write MGnifyR status JSON")
}

if (!requireNamespace("MGnifyR", quietly = TRUE)) {
  write_status(list(
    status = "mgnifyr_missing",
    accession = accession,
    checked_with = "MGnifyR",
    message = "MGnifyR is not installed in this R library. Install/load MGnifyR on HPC or set R_LIBS before re-running.",
    timestamp = format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z")
  ))
  quit(status = 2)
}

suppressPackageStartupMessages(library(MGnifyR))

cache_dir <- Sys.getenv("MGNIFYR_CACHE", file.path(outdir, "MGnifyR_cache"))
dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)

result <- tryCatch({
  client <- MgnifyClient(useCache = TRUE, cacheDir = cache_dir)
  studies <- searchAnalysis(client, "studies", accession)
  list(ok = TRUE, studies = studies)
}, error = function(e) {
  list(ok = FALSE, error = conditionMessage(e))
})

if (!isTRUE(result$ok)) {
  write_status(list(
    status = "lookup_failed",
    accession = accession,
    checked_with = "MGnifyR",
    error = result$error,
    timestamp = format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z")
  ))
  quit(status = 1)
}

studies <- result$studies
n_records <- if (is.data.frame(studies)) nrow(studies) else length(studies)

write_status(list(
  status = if (n_records > 0) "records_found" else "no_records_found",
  accession = accession,
  checked_with = "MGnifyR",
  n_records = n_records,
  record_class = class(studies),
  records = studies,
  cache_dir = cache_dir,
  timestamp = format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z")
))

