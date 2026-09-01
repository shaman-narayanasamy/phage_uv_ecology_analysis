#!/usr/bin/env Rscript

path <- file.path(getwd(), "manuscript", "isme_communications", "submission_review_manuscript.md")
stopifnot(file.exists(path))
lines <- readLines(path, warn = FALSE)
text <- paste(lines, collapse = "\n")

section <- function(start, end) {
  start_i <- grep(start, lines, fixed = TRUE)[1L]
  end_i <- grep(end, lines, fixed = TRUE)[1L]
  paste(lines[(start_i + 1L):(end_i - 1L)], collapse = " ")
}

abstract <- section("## Abstract", "## Introduction")
abstract_clean <- gsub("\\*\\*Keywords:.*$", "", abstract)
abstract_words <- strsplit(trimws(gsub("[[:space:]]+", " ", abstract_clean)), " ")[[1L]]
title <- lines[[1L]]
running <- sub("^\\*\\*Running title:\\*\\* ", "", lines[grep("^\\*\\*Running title:", lines)[1L]])

expected_headings <- c(
  "## Introduction", "## Materials and Methods", "## Results", "## Discussion",
  "## Acknowledgments", "## Author contributions", "## Funding",
  "## Conflict of interest", "## Data availability", "## References",
  "## Figures", "## Supplementary figures"
)
heading_positions <- match(expected_headings, lines)

stopifnot(
  lines[[3L]] == "**Original Article**",
  nchar(title) <= 150L,
  nchar(running) <= 40L,
  length(abstract_words) <= 250L,
  !grepl("\\[@", abstract),
  !grepl("—|–", text),
  all(!is.na(heading_positions)),
  !is.unsorted(heading_positions),
  length(grep("^\\*\\*Figure [1-4]\\.", lines)) == 4L,
  length(grep("^\\*\\*Supplementary Figure S[1-8]\\.", lines)) == 8L,
  length(grep("^Alt text:", lines)) == 12L,
  grepl("one control membrane and one phage-UV membrane", text, fixed = TRUE),
  grepl("collaborator-owned 16S analysis is pending", text, fixed = TRUE),
  grepl("@Myshkevych2025", text, fixed = TRUE),
  grepl("PRJEB79569", text, fixed = TRUE),
  grepl("Author review note", text, fixed = TRUE),
  !grepl("Figure 5 reserved|Editorial insertion note", text),
  all(c("@Lu2016", "@Cheng2019", "@Myshkevych2025") %in%
        unique(unlist(regmatches(text, gregexpr("@[A-Za-z0-9]+", text)))))
)

message(sprintf("ISME submission-review source verified; abstract=%d words.", length(abstract_words)))
