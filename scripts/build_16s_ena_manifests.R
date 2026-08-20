#!/usr/bin/env Rscript

abort <- function(...) stop(sprintf(...), call. = FALSE)

args <- commandArgs(trailingOnly = TRUE)
ena_source <- if (length(args) >= 1L) args[[1L]] else paste0(
  "https://www.ebi.ac.uk/ena/portal/api/filereport?",
  "accession=PRJEB79569&result=read_run&format=tsv&download=false&fields=",
  paste(c(
    "run_accession", "sample_accession", "secondary_sample_accession",
    "sample_title", "library_name", "library_strategy", "library_source",
    "library_selection", "instrument_platform", "instrument_model",
    "nominal_length", "read_count", "base_count", "fastq_ftp",
    "fastq_md5", "fastq_bytes", "submitted_ftp", "submitted_md5",
    "submitted_bytes", "first_public", "last_updated"
  ), collapse = ",")
)
sample_metadata_path <- if (length(args) >= 2L) args[[2L]] else "metadata/sample_metadata.tsv"
output_dir <- if (length(args) >= 3L) args[[3L]] else "metadata"

read_tsv <- function(source) {
  read.delim(
    source,
    sep = "\t",
    header = TRUE,
    quote = "",
    comment.char = "",
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
}

require_columns <- function(data, columns, label) {
  missing <- setdiff(columns, names(data))
  if (length(missing)) {
    abort("%s is missing required columns: %s", label, paste(missing, collapse = ", "))
  }
}

split_pair <- function(values, label) {
  pieces <- strsplit(values, ";", fixed = TRUE)
  if (any(lengths(pieces) != 2L)) {
    bad <- which(lengths(pieces) != 2L)
    abort("%s must contain exactly two semicolon-separated values; bad rows: %s",
          label, paste(bad, collapse = ", "))
  }
  do.call(rbind, pieces)
}

samples <- read_tsv(sample_metadata_path)
ena <- read_tsv(ena_source)

sample_columns <- c(
  "sample_title", "condition", "phase", "cycle", "analysis_group",
  "ena_sample_accession", "ena_secondary_sample_accession",
  "amplicon_run_accession"
)
ena_columns <- c(
  "run_accession", "sample_accession", "secondary_sample_accession",
  "sample_title", "library_strategy", "library_source", "library_selection",
  "instrument_platform", "instrument_model", "read_count", "base_count",
  "fastq_ftp", "fastq_md5", "fastq_bytes", "first_public", "last_updated"
)
require_columns(samples, sample_columns, "sample metadata")
require_columns(ena, ena_columns, "ENA report")

if (nrow(samples) != 12L || anyDuplicated(samples$amplicon_run_accession)) {
  abort("Canonical sample metadata must contain 12 unique amplicon accessions")
}

match_index <- match(samples$amplicon_run_accession, ena$run_accession)
if (anyNA(match_index)) {
  abort("ENA report lacks expected amplicon runs: %s",
        paste(samples$amplicon_run_accession[is.na(match_index)], collapse = ", "))
}
amplicon <- ena[match_index, , drop = FALSE]

if (!identical(as.character(amplicon$run_accession), samples$amplicon_run_accession)) {
  abort("ENA runs did not retain canonical sample order")
}
if (!identical(as.character(amplicon$sample_title), samples$sample_title)) {
  abort("ENA sample titles do not match canonical sample metadata")
}
if (!identical(as.character(amplicon$sample_accession), samples$ena_sample_accession) ||
    !identical(as.character(amplicon$secondary_sample_accession),
               samples$ena_secondary_sample_accession)) {
  abort("ENA sample accessions do not match canonical sample metadata")
}

expected_fields <- list(
  library_strategy = "AMPLICON",
  library_source = "METAGENOMIC",
  library_selection = "PCR",
  instrument_platform = "ILLUMINA",
  instrument_model = "Illumina MiSeq"
)
for (field in names(expected_fields)) {
  if (any(amplicon[[field]] != expected_fields[[field]])) {
    abort("Unexpected ENA %s value in selected amplicon runs", field)
  }
}

ftp <- split_pair(amplicon$fastq_ftp, "fastq_ftp")
md5 <- split_pair(amplicon$fastq_md5, "fastq_md5")
bytes <- split_pair(amplicon$fastq_bytes, "fastq_bytes")
if (any(!grepl("^[0-9a-f]{32}$", md5))) abort("Malformed ENA FASTQ MD5 value")

read_count <- as.numeric(amplicon$read_count)
base_count <- as.numeric(amplicon$base_count)
fastq_bytes <- matrix(as.numeric(bytes), nrow = nrow(bytes), ncol = ncol(bytes))
if (anyNA(read_count) || any(read_count %% 2 != 0)) {
  abort("ENA read_count must be numeric and even so it can be converted to read pairs")
}
if (anyNA(base_count) || anyNA(fastq_bytes)) abort("ENA count/byte fields must be numeric")

run_manifest <- data.frame(
  sample_title = samples$sample_title,
  condition = samples$condition,
  phase = samples$phase,
  cycle = samples$cycle,
  analysis_group = samples$analysis_group,
  ena_sample_accession = samples$ena_sample_accession,
  ena_secondary_sample_accession = samples$ena_secondary_sample_accession,
  amplicon_run_accession = amplicon$run_accession,
  library_strategy = amplicon$library_strategy,
  ena_library_source = amplicon$library_source,
  library_selection = amplicon$library_selection,
  instrument_platform = amplicon$instrument_platform,
  instrument_model = amplicon$instrument_model,
  read_count = read_count,
  read_pairs = read_count / 2,
  base_count = base_count,
  fastq_r1_url = paste0("https://", ftp[, 1L]),
  fastq_r2_url = paste0("https://", ftp[, 2L]),
  fastq_r1_md5 = md5[, 1L],
  fastq_r2_md5 = md5[, 2L],
  fastq_r1_bytes = fastq_bytes[, 1L],
  fastq_r2_bytes = fastq_bytes[, 2L],
  ena_first_public = amplicon$first_public,
  ena_last_updated = amplicon$last_updated,
  check.names = FALSE,
  stringsAsFactors = FALSE
)

fastq_manifest <- do.call(rbind, lapply(seq_len(nrow(run_manifest)), function(i) {
  data.frame(
    sample_title = run_manifest$sample_title[[i]],
    amplicon_run_accession = run_manifest$amplicon_run_accession[[i]],
    read_direction = c("R1", "R2"),
    local_filename = paste0(run_manifest$sample_title[[i]], c("_R1.fastq.gz", "_R2.fastq.gz")),
    download_url = c(run_manifest$fastq_r1_url[[i]], run_manifest$fastq_r2_url[[i]]),
    md5 = c(run_manifest$fastq_r1_md5[[i]], run_manifest$fastq_r2_md5[[i]]),
    bytes = c(run_manifest$fastq_r1_bytes[[i]], run_manifest$fastq_r2_bytes[[i]]),
    stringsAsFactors = FALSE
  )
}))

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
run_path <- file.path(output_dir, "16s_ena_run_manifest.tsv")
fastq_path <- file.path(output_dir, "16s_ena_fastq_manifest.tsv")
write.table(run_manifest, run_path, sep = "\t", quote = FALSE, row.names = FALSE, na = "")
write.table(fastq_manifest, fastq_path, sep = "\t", quote = FALSE, row.names = FALSE, na = "")

cat(sprintf(
  paste0(
    "Wrote %d runs and %d FASTQ records\n",
    "Reads: %.0f (%.0f pairs); bases: %.0f; compressed bytes: %.0f\n",
    "%s\n%s\n"
  ),
  nrow(run_manifest), nrow(fastq_manifest), sum(run_manifest$read_count),
  sum(run_manifest$read_pairs), sum(run_manifest$base_count),
  sum(fastq_manifest$bytes), run_path, fastq_path
))
