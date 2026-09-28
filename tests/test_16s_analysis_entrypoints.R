#!/usr/bin/env Rscript
# Contract tests for the delegated 16S workstream. These run without data and
# without the reference databases: they check that every documented entrypoint
# exists, follows the repository's Quarto execution contract, and is referenced
# by the protocol document.

abort <- function(...) stop(sprintf(...), call. = FALSE)
read_tsv <- function(path) read.delim(
  path, sep = "\t", quote = "", comment.char = "", check.names = FALSE,
  stringsAsFactors = FALSE
)
expect <- function(value, message) if (!isTRUE(value)) abort("FAILED: %s", message)

protocol_path <- "docs/16s_analysis_protocol.md"
config_path <- "config/16s_analysis_paths.sh"
reference_manifest_path <- "metadata/16s_reference_manifest.tsv"

notebooks <- c(
  "scripts/check_16s_environment.qmd",
  "scripts/inspect_16s_quality_profiles.qmd",
  "scripts/run_16s_dada2.qmd",
  "scripts/assign_16s_taxonomy.qmd",
  "scripts/build_16s_phyloseq.qmd",
  "scripts/analyse_16s_community_ecology.qmd",
  "scripts/run_16s_exploratory_differential_abundance.qmd",
  "scripts/build_16s_candidate_figures.qmd",
  "scripts/build_16s_return_package.qmd"
)
shell_scripts <- c(
  "scripts/fetch_16s_ena_reads.sh",
  "scripts/fetch_16s_reference_databases.sh",
  "scripts/trim_16s_primers.sh",
  "scripts/subsample_16s_reads.sh",
  "scripts/run_16s_pipeline.sh"
)

expect(file.exists(protocol_path), "the 16S protocol document exists")
expect(file.exists(config_path), "the 16S shell configuration exists")
protocol <- paste(readLines(protocol_path, warn = FALSE), collapse = "\n")
protocol_flat <- gsub("\\s+", " ", protocol)
config <- paste(readLines(config_path, warn = FALSE), collapse = "\n")

for (path in c(notebooks, shell_scripts)) {
  expect(file.exists(path), sprintf("%s exists", path))
  expect(file.size(path) > 0, sprintf("%s is not empty", path))
  expect(grepl(basename(path), protocol, fixed = TRUE),
         sprintf("%s is documented in the protocol", path))
}

for (path in notebooks) {
  source_text <- paste(readLines(path, warn = FALSE), collapse = "\n")
  expect(grepl("execute:\\s*\\n\\s*enabled:\\s*false", source_text),
         sprintf("%s disables automatic execution", path))
  expect(grepl("#\\| label:", source_text), sprintf("%s labels its chunk", path))
  expect(grepl("bash scripts/run_qmd.sh", source_text, fixed = TRUE),
         sprintf("%s documents its command-line invocation", path))
  expect(grepl("commandArgs(trailingOnly = TRUE)", source_text, fixed = TRUE),
         sprintf("%s accepts positional arguments", path))
}

for (variable in c("PHAGE_UV_16S_SUBSAMPLE_DEPTH", "PHAGE_UV_16S_GTDB_CROSSCHECK",
                   "PHAGE_UV_DATA_ROOT", "PHAGE_UV_16S_RAW_DIR", "PHAGE_UV_16S_REFERENCE_DIR",
                   "PHAGE_UV_16S_DERIVED", "PHAGE_UV_16S_TRIMMED_DIR", "PHAGE_UV_16S_QUALITY_DIR",
                   "PHAGE_UV_16S_DADA2_DIR", "PHAGE_UV_16S_TAXONOMY_DIR", "PHAGE_UV_16S_PHYLOSEQ_DIR",
                   "PHAGE_UV_16S_ECOLOGY_DIR", "PHAGE_UV_16S_DA_DIR", "PHAGE_UV_16S_FIGURE_DIR",
                   "PHAGE_UV_16S_RETURN_DIR", "PHAGE_UV_16S_TRUNC_LEN_R1", "PHAGE_UV_16S_TRUNC_LEN_R2",
                   "PHAGE_UV_16S_MIN_OVERLAP", "PHAGE_UV_16S_PRIMER_FWD", "PHAGE_UV_16S_PRIMER_REV")) {
  expect(grepl(paste0(variable, ":="), config, fixed = TRUE),
         sprintf("config defines %s", variable))
}

# The primers must stay identical to the ones reported in the collaborator handoff.
expect(grepl("PHAGE_UV_16S_PRIMER_FWD:=GTGYCAGCMGCCGCGGTAA", config, fixed = TRUE),
       "the forward primer is the reported 515F sequence")
expect(grepl("PHAGE_UV_16S_PRIMER_REV:=CCCCGYCAATTCMTTTRAGT", config, fixed = TRUE),
       "the reverse primer is the reported 907R sequence")

references <- read_tsv(reference_manifest_path)
expect(nrow(references) == 4L, "the reference manifest declares four files")
expect(all(c("reference_set", "role", "local_filename", "download_url", "md5", "bytes",
             "source_record", "citation") %in% names(references)),
       "the reference manifest has the expected columns")
expect(all(grepl("^https://", references$download_url)), "reference downloads use HTTPS")
expect(all(grepl("^[0-9a-f]{32}$", references$md5)), "reference files have valid MD5 values")
expect(all(references$bytes > 0), "reference file sizes are recorded")
expect(any(grepl("silva_nr99_v138.2", references$local_filename, fixed = TRUE)),
       "SILVA 138.2 is the primary reference")
expect(any(grepl("r220", references$local_filename, fixed = TRUE)),
       "GTDB r220 is the cross-check reference")

# The protocol must keep the binding experimental boundary visible.
for (phrase in c("one membrane per condition", "not a replicated", "unrarefied")) {
  expect(grepl(phrase, protocol_flat, ignore.case = TRUE),
         sprintf("the protocol states the boundary phrase: %s", phrase))
}

cat("16S analysis entrypoint tests passed.\n")
