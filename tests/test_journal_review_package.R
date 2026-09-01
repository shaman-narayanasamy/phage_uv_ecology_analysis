#!/usr/bin/env Rscript

repo_root <- normalizePath(getwd())
package_dir <- file.path(repo_root, "manuscript", "isme_communications")
required_files <- c(
  "README.md",
  "title_page.md",
  "prior_publication_metadata.md",
  "cover_letter_draft.md",
  "submission_checklist.md",
  "researcher_authorship_remediation.md",
  "author_decision_register.tsv",
  "scientific_review_checklist.md"
)
stopifnot(
  dir.exists(package_dir),
  all(file.exists(file.path(package_dir, required_files)))
)

read_text <- function(path) {
  paste(readLines(path, warn = FALSE), collapse = "\n")
}

decision <- read_text(file.path(repo_root, "docs", "journal_selection_and_conformance.md"))
package_text <- setNames(vapply(
  file.path(package_dir, required_files),
  read_text,
  character(1L),
  USE.NAMES = FALSE
), required_files)
all_package_text <- paste(package_text, collapse = "\n")
decision_register <- read.delim(
  file.path(package_dir, "author_decision_register.tsv"),
  sep = "\t",
  quote = "",
  check.names = FALSE,
  stringsAsFactors = FALSE,
  na.strings = character()
)
release_script <- file.path(repo_root, "scripts", "build_submission_release_manifest.sh")
release_protocol <- read_text(file.path(repo_root, "docs", "submission_release_protocol.md"))

stopifnot(
  grepl("Target journal: **ISME Communications**", decision, fixed = TRUE),
  grepl("Fallback 1: **FEMS Microbiology Ecology**", decision, fixed = TRUE),
  grepl("Fallback 2: **Environmental Microbiome**", decision, fixed = TRUE),
  grepl("provisional author decision", decision, fixed = TRUE),
  grepl("does[[:space:]]+not authorize[[:space:]]+a live Google Docs edit", decision),
  grepl("review package, not a submitted package", package_text[["README.md"]], fixed = TRUE),
  grepl("one control membrane and one phage-UV membrane", all_package_text, fixed = TRUE),
  grepl("10.1016/j.ceja.2025.100796", all_package_text, fixed = TRUE),
  grepl("PRJEB79569", package_text[["cover_letter_draft.md"]], fixed = TRUE),
  grepl("complete-universe transcriptome model", package_text[["cover_letter_draft.md"]], fixed = TRUE),
  grepl("[AUTHOR CONFIRMATION REQUIRED", all_package_text, fixed = TRUE),
  grepl("explicit immediate approval", package_text[["submission_checklist.md"]], fixed = TRUE),
  grepl("Critical authorship-policy gate", decision, fixed = TRUE),
  grepl("prohibit using an LLM to draft", decision, fixed = TRUE),
  grepl("agent-authored prose is a scaffold", package_text[["submission_checklist.md"]], fixed = TRUE),
  grepl("must not be lightly edited", package_text[["researcher_authorship_remediation.md"]], fixed = TRUE),
  grepl("academic.oup.com/ismecommun/pages/author-guidelines", package_text[["researcher_authorship_remediation.md"]], fixed = TRUE),
  grepl("RESEARCHER-AUTHORED AI DISCLOSURE REQUIRED", package_text[["cover_letter_draft.md"]], fixed = TRUE),
  identical(decision_register$decision_id, sprintf("D%02d", 1:20)),
  all(decision_register$status %in% c("pending_human", "pending_external")),
  all(is.na(decision_register$decision) | decision_register$decision == ""),
  all(is.na(decision_register$decided_by) | decision_register$decided_by == ""),
  all(is.na(decision_register$decision_date) | decision_register$decision_date == ""),
  !any(grepl("approved|confirmed|complete", decision_register$status)),
  grepl("Only[[:space:]]+named authors can approve", package_text[["scientific_review_checklist.md"]]),
  file.exists(release_script),
  file.access(release_script, mode = 1L) == 0L,
  grepl("No package is frozen, tagged", release_protocol, fixed = TRUE),
  grepl("does not grant that authority", release_protocol, fixed = TRUE),
  !grepl("approved for submission", package_text[["README.md"]], fixed = TRUE)
)

release_test_dir <- tempfile("submission-release-test-")
dir.create(release_test_dir)
on.exit(unlink(release_test_dir, recursive = TRUE), add = TRUE)
source_file <- file.path(release_test_dir, "manuscript.pdf")
writeBin(charToRaw("approved submission bytes\n"), source_file)

pending_inventory <- file.path(release_test_dir, "pending.tsv")
writeLines(c(
  "role\tsource_path\tsubmission_name\tapproval_status",
  paste("manuscript", source_file, "manuscript.pdf", "pending_human", sep = "\t")
), pending_inventory)
pending_output <- file.path(release_test_dir, "pending-manifest.tsv")
pending_result <- suppressWarnings(system2(
  "bash",
  c(shQuote(release_script), shQuote(pending_inventory), shQuote(pending_output)),
  stdout = TRUE,
  stderr = TRUE
))
stopifnot(
  identical(attr(pending_result, "status"), 65L),
  !file.exists(pending_output)
)

approved_inventory <- file.path(release_test_dir, "approved.tsv")
writeLines(c(
  "role\tsource_path\tsubmission_name\tapproval_status",
  paste(
    "manuscript",
    source_file,
    "manuscript.pdf",
    "approved_by_corresponding_author",
    sep = "\t"
  )
), approved_inventory)
approved_output <- file.path(release_test_dir, "release-manifest.tsv")
approved_result <- system2(
  "bash",
  c(shQuote(release_script), shQuote(approved_inventory), shQuote(approved_output)),
  stdout = TRUE,
  stderr = TRUE
)
release_manifest <- read.delim(
  approved_output,
  sep = "\t",
  quote = "",
  check.names = FALSE,
  stringsAsFactors = FALSE
)
stopifnot(
  is.null(attr(approved_result, "status")),
  nrow(release_manifest) == 1L,
  release_manifest$submission_name == "manuscript.pdf",
  release_manifest$file_size_bytes == file.info(source_file)$size,
  grepl("^[0-9a-f]{64}$", release_manifest$sha256),
  grepl("^[0-9a-f]{40}$", release_manifest$repository_commit)
)

message("Journal choice and review-only submission package verified.")
