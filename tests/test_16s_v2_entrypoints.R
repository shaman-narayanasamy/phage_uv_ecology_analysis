#!/usr/bin/env Rscript
# Contract tests for the isolated 16S_v2 workstream. These run without data:
# they check the v2 configuration routes every output away from the protected
# v1 locations, that the guard actually fires, and that the v2 notebook follows
# the repository's Quarto execution contract and is documented.

abort <- function(...) stop(sprintf(...), call. = FALSE)
expect <- function(value, message) if (!isTRUE(value)) abort("FAILED: %s", message)

protocol_path <- "docs/16s_v2_protocol.md"
config_path <- "config/16s_v2_paths.sh"
notebooks <- c("scripts/run_16s_v2_cycle_models.qmd", "scripts/run_16s_v2_common_region.qmd",
               "scripts/compare_16s_v2_reproduction.qmd")
handoffs <- c(
  "notes/handoff-2026-09-16-16s-v2-return.md",
  "notes/handoff-2026-09-09-susana-16s-v2-start-here.md",
  "notes/handoff-2026-09-09-16s-v2-isolated.md",
  "notes/handoff-2026-09-13-susana-16s-cycle-models.md"
)

shell_scripts <- c("scripts/run_16s_v2_reproduction.sh", "scripts/trim_16s_v2_earlier_cohort.sh",
                   "scripts/build_16s_v2_return_package.sh",
                   "metadata/16s_v2_earlier_cohort_fastq_manifest.tsv", "metadata/16s_v2_earlier_cohort_sample_map.tsv")
for (path in c(protocol_path, config_path, notebooks, handoffs, shell_scripts)) {
  expect(file.exists(path), sprintf("%s exists", path))
}
protocol <- paste(readLines(protocol_path, warn = FALSE), collapse = "\n")
for (path in c(config_path, notebooks, shell_scripts[1:3])) {
  expect(grepl(basename(path), protocol, fixed = TRUE), sprintf("%s is documented in the v2 protocol", path))
}
earlier_map <- read.delim("metadata/16s_v2_earlier_cohort_sample_map.tsv", sep = "\t", stringsAsFactors = FALSE)
expect(all(earlier_map$cycle == "unassigned"), "earlier-cohort samples never carry a cycle assignment")
expect(setequal(earlier_map$run_accession, c("ERR4181942", "ERR4181943", "ERR4181944")), "earlier cohort is exactly the three U+B40 runs")

for (path in notebooks) {
  source_text <- paste(readLines(path, warn = FALSE), collapse = "\n")
  expect(grepl("execute:\\s*\\n\\s*enabled:\\s*false", source_text), sprintf("%s disables automatic execution", path))
  expect(grepl("#\\| label:", source_text), sprintf("%s labels its chunk", path))
  expect(grepl("bash scripts/run_qmd.sh", source_text, fixed = TRUE), sprintf("%s documents its invocation", path))
  expect(grepl("commandArgs(trailingOnly = TRUE)", source_text, fixed = TRUE), sprintf("%s accepts positional arguments", path))
  expect(grepl("protected", source_text, fixed = TRUE), sprintf("%s carries the isolation guard", path))
}

# The config must be sourceable from the repository root, must send every
# output variable into the v2 root, and must pin the executed v1 parameters.
run_config <- function(env = character()) {
  cmd <- sprintf("cd %s && %s bash -c 'source %s && env | grep ^PHAGE_UV_'",
                 shQuote(getwd()), paste(env, collapse = " "), config_path)
  out <- suppressWarnings(system(cmd, intern = TRUE))
  status <- attr(out, "status")
  values <- if (length(out)) setNames(sub("^[^=]*=", "", out), sub("=.*$", "", out)) else character()
  list(status = if (is.null(status)) 0L else status, values = values)
}
v2_root <- tempfile("16s_v2_")
ok <- run_config(sprintf("PHAGE_UV_16S_V2_ROOT=%s", shQuote(v2_root)))
expect(ok$status == 0L, "the v2 configuration sources cleanly")
output_vars <- grep("^PHAGE_UV_16S_.*_DIR$|^PHAGE_UV_16S_DERIVED$|^PHAGE_UV_16S_V2_", names(ok$values), value = TRUE)
expect(length(output_vars) >= 15L, "the v2 configuration exports the output variables")
for (v in setdiff(output_vars, "PHAGE_UV_16S_V1_RETURN_COPY")) {
  expect(startsWith(ok$values[[v]], v2_root), sprintf("%s is inside the v2 root", v))
}
expect(identical(ok$values[["PHAGE_UV_16S_TRUNC_LEN_R2"]], "200"), "reproduction pins the executed reverse truncation 200")
expect(identical(ok$values[["PHAGE_UV_16S_POOL"]], "FALSE"), "reproduction pins the executed pool = FALSE")
expect(identical(ok$values[["PHAGE_UV_16S_LEARN_NBASES"]], "5e7"), "reproduction pins the executed learnErrors budget")
expect(identical(ok$values[["PHAGE_UV_16S_PRIMER_FWD"]], "GTGYCAGCMGCCGCGGTAA"), "primers are inherited from v1 unchanged")

bad <- run_config("PHAGE_UV_16S_V2_ROOT=/tmp/x/phage_uv_treatment/PRJEB79569/derived/16s_analysis/y")
expect(bad$status != 0L, "the isolation guard refuses a protected v1 location")

cat("16S_v2 entrypoint tests passed\n")
