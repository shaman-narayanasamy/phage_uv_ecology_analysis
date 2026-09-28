#!/usr/bin/env Rscript

repo_root <- normalizePath(getwd())
provenance <- read.delim(
  file.path(repo_root, "manuscript", "upstream_repository_provenance.tsv"),
  sep = "\t",
  quote = "",
  check.names = FALSE,
  stringsAsFactors = FALSE
)
code_manifest <- read.delim(
  file.path(repo_root, "manifests", "code_manifest.tsv"),
  sep = "\t",
  quote = "",
  check.names = FALSE,
  stringsAsFactors = FALSE
)
checklist_text <- paste(
  readLines(
    file.path(repo_root, "manuscript", "isme_communications", "submission_checklist.md"),
    warn = FALSE
  ),
  collapse = "\n"
)

required_columns <- c(
  "repository",
  "role",
  "versioned_commit",
  "execution_state",
  "source_base_commit",
  "evidence_location",
  "evidence_sha256",
  "verification_status",
  "provenance_note"
)
expected_commits <- c(
  multiomics_pipeline = "5f7dfe4c42ba65a8188589f437667a61285a5bea",
  host_phage_linking = "604db81b73f2550bdea08e5eaa08f35186d21f53"
)

stopifnot(
  identical(names(provenance), required_columns),
  identical(provenance$repository, names(expected_commits)),
  !anyDuplicated(provenance$repository),
  identical(provenance$versioned_commit, unname(expected_commits)),
  all(grepl("^[0-9a-f]{40}$", provenance$versioned_commit)),
  all(grepl("^[0-9a-f]{40}$", provenance$source_base_commit)),
  all(provenance$verification_status == "verified"),
  all(nzchar(provenance$evidence_location)),
  all(nzchar(provenance$provenance_note)),
  all(grepl("^[0-9a-f]{64}(; [0-9a-f]{64})*$", provenance$evidence_sha256)),
  !any(grepl("TODO_resolve_main_commit", code_manifest$ref_or_commit, fixed = TRUE))
)

for (repository in names(expected_commits)) {
  manifest_row <- code_manifest[code_manifest$code_id == repository, ]
  stopifnot(
    nrow(manifest_row) == 1L,
    manifest_row$ref_or_commit == expected_commits[[repository]],
    grepl("upstream_repository_provenance.tsv", manifest_row$notes, fixed = TRUE)
  )
}

stopifnot(
  grepl(
    "[x] Exact executed upstream repository states are versioned",
    checklist_text,
    fixed = TRUE
  )
)

message("Upstream repository execution states and exact commits verified.")
