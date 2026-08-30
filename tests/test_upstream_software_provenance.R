#!/usr/bin/env Rscript

provenance_path <- file.path(
  normalizePath(getwd()),
  "manuscript",
  "upstream_software_provenance.tsv"
)
provenance <- read.delim(
  provenance_path,
  sep = "\t",
  quote = "",
  check.names = FALSE,
  stringsAsFactors = FALSE
)
manuscript_text <- paste(
  readLines(
    file.path(normalizePath(getwd()), "manuscript", "manuscript_skeleton.md"),
    warn = FALSE
  ),
  collapse = "\n"
)

required_columns <- c(
  "workflow_component",
  "role",
  "software_version",
  "database",
  "database_version_or_date",
  "verification_status",
  "evidence_location",
  "evidence_sha256",
  "provenance_note"
)
stopifnot(
  identical(names(provenance), required_columns),
  identical(
    provenance$workflow_component,
    c("CoverM", "Bakta", "CAT/BAT", "CheckV", "inStrain")
  ),
  !anyDuplicated(provenance$workflow_component),
  all(provenance$verification_status %in% c("verified", "partial")),
  all(nzchar(provenance$evidence_location)),
  all(nzchar(provenance$provenance_note)),
  all(grepl(
    "^[0-9a-f]{64}(; [0-9a-f]{64})*$",
    provenance$evidence_sha256
  ))
)

value_for <- function(component, field) {
  hit <- provenance[provenance$workflow_component == component, field]
  stopifnot(length(hit) == 1L)
  hit[[1L]]
}

stopifnot(
  value_for("CoverM", "software_version") == "not recoverable",
  value_for("CoverM", "verification_status") == "partial",
  grepl(
    "not proven to be the executed environment",
    value_for("CoverM", "provenance_note"),
    fixed = TRUE
  ),
  value_for("Bakta", "software_version") == "1.12.0",
  value_for("Bakta", "database_version_or_date") == "6.0; 2025-02-24",
  value_for("CAT/BAT", "software_version") == "6.0.1",
  grepl(
    "exact GTDB release not recoverable",
    value_for("CAT/BAT", "database_version_or_date"),
    fixed = TRUE
  ),
  value_for("CheckV", "software_version") == "1.1.1",
  value_for("CheckV", "database_version_or_date") == "1.5",
  value_for("inStrain", "software_version") == "1.10.0",
  grepl("Bakta 1.12.0", manuscript_text, fixed = TRUE),
  grepl("CAT/BAT 6.0.1", manuscript_text, fixed = TRUE),
  grepl("CheckV 1.1.1", manuscript_text, fixed = TRUE),
  grepl("inStrain 1.10.0", manuscript_text, fixed = TRUE),
  grepl("not the resolved CoverM package", manuscript_text, fixed = TRUE),
  grepl("exact GTDB release tag was not preserved", manuscript_text, fixed = TRUE)
)

message("Upstream software provenance and explicit gaps verified.")
