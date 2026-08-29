#!/usr/bin/env Rscript

repo_root <- normalizePath(getwd())
manuscript_path <- file.path(repo_root, "manuscript", "manuscript_skeleton.md")
lines <- readLines(manuscript_path, warn = FALSE)

section_text <- function(start_heading, end_heading) {
  start <- match(start_heading, lines)
  end <- match(end_heading, lines)
  stopifnot(!is.na(start), !is.na(end), end > start)
  paste(lines[(start + 1L):(end - 1L)], collapse = "\n")
}

word_count <- function(text) {
  words <- strsplit(trimws(gsub("[[:space:]]+", " ", text)), " ")[[1L]]
  sum(nzchar(words))
}

required_headings <- c(
  "## Working title", "## Abstract", "## Introduction", "## Methods",
  "## Results", "## Discussion", "## Data and code availability",
  "## Declarations", "## References", "## Working main-figure legends",
  "## Working supplementary-figure legends",
  "## Editorial insertion note, not manuscript text"
)
stopifnot(all(vapply(
  required_headings,
  function(heading) sum(lines == heading) == 1L,
  logical(1L)
)))

title <- section_text("## Working title", "## Abstract")
abstract <- section_text("## Abstract", "## Introduction")
abstract_lines <- strsplit(abstract, "\n", fixed = TRUE)[[1L]]
abstract <- paste(abstract_lines[!grepl("^Keywords:", abstract_lines)], collapse = "\n")
introduction <- section_text("## Introduction", "## Methods")
methods <- section_text("## Methods", "## Results")
results <- section_text("## Results", "## Discussion")
discussion <- section_text("## Discussion", "## Data and code availability")
scientific_body <- paste(abstract, introduction, methods, results, discussion)
scientific_body <- gsub("[[:space:]]+", " ", scientific_body)
results_flat <- gsub("[[:space:]]+", " ", results)

stopifnot(
  word_count(title) <= 18L,
  word_count(abstract) >= 180L,
  word_count(abstract) <= 250L,
  word_count(introduction) >= 180L,
  word_count(introduction) <= 400L,
  word_count(results) >= 700L,
  word_count(results) <= 1500L,
  word_count(discussion) >= 400L,
  word_count(discussion) <= 900L,
  !grepl("—", paste(lines, collapse = "\n"), fixed = TRUE)
)

required_boundaries <- c(
  "treatment is inseparable from membrane identity",
  "do not provide independent treatment replication",
  "does not fit a joint DNA-RNA model",
  "not to claim a uniform per-cell regulatory response",
  "do not demonstrate treatment-induced mutation or adaptation"
)
stopifnot(all(vapply(
  required_boundaries,
  function(boundary) grepl(boundary, scientific_body, fixed = TRUE),
  logical(1L)
)))

prohibited_claims <- c(
  "treatment caused",
  "phage-UV caused",
  "UV-induced DNA damage was",
  "UV-induced mutations were",
  "demonstrates adaptation",
  "independent view of community"
)
stopifnot(!any(vapply(
  prohibited_claims,
  function(claim) grepl(claim, scientific_body, fixed = TRUE),
  logical(1L)
)))

main_labels <- paste0("Figure ", 1:4)
main_positions <- vapply(
  main_labels,
  function(label) regexpr(label, results_flat, fixed = TRUE)[[1L]],
  integer(1L)
)
stopifnot(all(main_positions > 0L), identical(order(main_positions), 1:4))

supp_labels <- paste0("Supplementary Figure S", 1:7)
supp_positions <- vapply(
  supp_labels,
  function(label) regexpr(label, results_flat, fixed = TRUE)[[1L]],
  integer(1L)
)
stopifnot(all(supp_positions > 0L), identical(order(supp_positions), 1:7))

required_result_signals <- c(
  "No named family exceeded 6.6% mean relative abundance",
  "7,703 features at FDR < 0.05",
  "BH FDR range 0.642 to 0.892",
  "175 MAG-level gene sets",
  "6,985 met the five-of-six-cell recurrence rule",
  "Five MAGs passed the pairwise and organism-level coverage rules"
)
stopifnot(all(vapply(
  required_result_signals,
  function(signal) grepl(signal, results_flat, fixed = TRUE),
  logical(1L)
)))

cat(sprintf(
  paste0(
    "test_manuscript_structure.R: PASS ",
    "(abstract=%d; introduction=%d; results=%d; discussion=%d words)\n"
  ),
  word_count(abstract),
  word_count(introduction),
  word_count(results),
  word_count(discussion)
))
