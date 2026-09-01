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
  !grepl("approved for submission", package_text[["README.md"]], fixed = TRUE)
)

message("Journal choice and review-only submission package verified.")
