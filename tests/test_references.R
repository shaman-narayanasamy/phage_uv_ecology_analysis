#!/usr/bin/env Rscript

repo_root <- normalizePath(getwd())
bib_path <- file.path(repo_root, "manuscript", "references.bib")
manuscript_path <- file.path(repo_root, "manuscript", "manuscript_skeleton.md")
legend_path <- file.path(repo_root, "manuscript", "figure_legends.md")
handoff_path <- file.path(
  repo_root,
  "notes",
  "handoff-2026-08-27-full-manuscript-draft.md"
)

bib_lines <- readLines(bib_path, warn = FALSE)
manuscript_lines <- readLines(manuscript_path, warn = FALSE)
legend_lines <- readLines(legend_path, warn = FALSE)
handoff_text <- paste(readLines(handoff_path, warn = FALSE), collapse = "\n")

entry_starts <- grep("^@[[:alpha:]]+\\{[^,]+,", bib_lines)
stopifnot(length(entry_starts) == 16L)
stopifnot(
  grepl("16 unique DOI-addressed records", handoff_text, fixed = TRUE),
  !grepl("14 unique DOI-addressed records", handoff_text, fixed = TRUE)
)

entry_ends <- c(entry_starts[-1L] - 1L, length(bib_lines))
entries <- Map(
  function(start, end) bib_lines[start:end],
  entry_starts,
  entry_ends
)

extract_key <- function(entry) {
  sub("^@[[:alpha:]]+\\{([^,]+),.*$", "\\1", entry[[1L]])
}

extract_field <- function(entry, field) {
  pattern <- sprintf("^[[:space:]]*%s[[:space:]]*=[[:space:]]*\\{", field)
  hit <- grep(pattern, entry, value = TRUE, ignore.case = TRUE)
  stopifnot(length(hit) == 1L)
  sub("^[^{]*\\{(.*)\\}[,]?[[:space:]]*$", "\\1", hit)
}

keys <- vapply(entries, extract_key, character(1L))
dois <- tolower(vapply(entries, extract_field, character(1L), field = "doi"))

required_keys <- c(
  "Aroney2025", "Benjamini1995", "Cheng2019", "Dahl2022", "Lu2016", "Maslowska2019",
  "Myshkevych2025", "Nayfach2021", "Olm2021", "Parks2022",
  "Robinson2010edgeR", "Robinson2010TMM", "Scarascia2021",
  "Schwengers2021", "vonMeijenfeldt2019", "Wu2012"
)

stopifnot(
  setequal(keys, required_keys),
  !anyDuplicated(keys),
  !anyDuplicated(dois),
  all(grepl("^10\\.[0-9]{4,9}/[^[:space:]]+$", dois)),
  all(vapply(entries, function(x) {
    all(vapply(
      c("author", "title", "journal", "year", "doi"),
      function(field) {
        length(grep(
          sprintf("^[[:space:]]*%s[[:space:]]*=", field),
          x,
          ignore.case = TRUE
        )) == 1L
      },
      logical(1L)
    ))
  }, logical(1L)))
)

reference_start <- match("## References", manuscript_lines)
legend_start <- match("## Working main-figure legends", manuscript_lines)
stopifnot(!is.na(reference_start), !is.na(legend_start), legend_start > reference_start)
manual_references <- paste(
  manuscript_lines[(reference_start + 1L):(legend_start - 1L)],
  collapse = "\n"
)

stopifnot(all(vapply(
  dois,
  function(doi) grepl(doi, manual_references, fixed = TRUE),
  logical(1L)
)))

body_and_legends <- paste(
  c(manuscript_lines[seq_len(reference_start - 1L)], legend_lines),
  collapse = "\n"
)
body_and_legends <- gsub("[[:space:]]+", " ", body_and_legends)
required_citation_text <- c(
  "Aroney et al., 2025",
  "Benjamini and Hochberg, 1995",
  "Cheng et al., 2019",
  "Dahl et al. (2022)",
  "Lu et al., 2016",
  "Maslowska et al., 2019",
  "Myshkevych et al., 2025",
  "Nayfach et al., 2021",
  "Olm et al., 2021",
  "Parks et al., 2022",
  "Robinson et al., 2010",
  "Robinson and Oshlack, 2010",
  "Scarascia et al., 2021",
  "Schwengers et al., 2021",
  "von Meijenfeldt et al., 2019",
  "Wu and Smyth, 2012"
)
stopifnot(all(vapply(
  required_citation_text,
  function(citation) grepl(citation, body_and_legends, fixed = TRUE),
  logical(1L)
)))

stopifnot(
  !any(grepl("TODO|TBD|citation needed|DOI needed", bib_lines, ignore.case = TRUE)),
  !any(grepl("^@[[:alpha:]]+\\{[^,]+,[[:space:]]*\\}$", bib_lines))
)

cat("test_references.R: PASS\n")
