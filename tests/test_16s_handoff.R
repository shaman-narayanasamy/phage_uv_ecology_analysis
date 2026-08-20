#!/usr/bin/env Rscript

abort <- function(...) stop(sprintf(...), call. = FALSE)
read_tsv <- function(path) read.delim(
  path, sep = "\t", quote = "", comment.char = "", check.names = FALSE,
  stringsAsFactors = FALSE
)
expect <- function(value, message) if (!isTRUE(value)) abort("FAILED: %s", message)

samples <- read_tsv("metadata/sample_metadata.tsv")
runs <- read_tsv("metadata/16s_ena_run_manifest.tsv")
fastqs <- read_tsv("metadata/16s_ena_fastq_manifest.tsv")

expect(nrow(runs) == 12L, "run manifest has 12 rows")
expect(nrow(fastqs) == 24L, "FASTQ manifest has 24 rows")
expect(identical(runs$amplicon_run_accession, samples$amplicon_run_accession),
       "run accessions follow the canonical sample map")
expect(identical(runs$sample_title, samples$sample_title),
       "sample titles follow the canonical sample map")
expect(!anyDuplicated(runs$amplicon_run_accession), "run accessions are unique")
expect(!anyDuplicated(fastqs$local_filename), "local FASTQ filenames are unique")
expect(identical(sort(unique(runs$condition)), c("control", "treatment")),
       "both conditions are represented")
expect(identical(sort(unique(runs$phase)), c("backflush", "initial")),
       "both phases are represented")
expect(identical(sort(unique(runs$cycle)), 1:3), "cycles 1-3 are represented")
expect(all(table(runs$condition, runs$phase, runs$cycle) == 1L),
       "the design has one sample in every condition-phase-cycle cell")
expect(all(table(fastqs$sample_title) == 2L), "each sample has two FASTQ files")
expect(all(table(fastqs$amplicon_run_accession, fastqs$read_direction) == 1L),
       "each run has one R1 and one R2")
expect(all(runs$library_strategy == "AMPLICON"), "all libraries are AMPLICON")
expect(all(runs$library_selection == "PCR"), "all libraries use PCR selection")
expect(all(runs$instrument_model == "Illumina MiSeq"), "all runs are MiSeq")
expect(sum(runs$read_count) == 17053094, "total ENA read count is stable")
expect(sum(runs$read_pairs) == 8526547, "total inferred read-pair count is stable")
expect(sum(runs$base_count) == 5132981294, "total base count is stable")
expect(sum(fastqs$bytes) == 2783761569, "total compressed FASTQ bytes are stable")
expect(all(grepl("^https://", fastqs$download_url)), "all downloads use HTTPS")
expect(all(grepl("^[0-9a-f]{32}$", fastqs$md5)), "all FASTQs have valid MD5 values")

cat("16S handoff manifest tests passed.\n")
