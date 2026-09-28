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
# The local skeleton is a preserved historical scaffold. New reviewed prose is
# in the live Google Doc, with versioned payloads here; do not claim that this
# repository-only check verifies live Zotero fields or current Doc placement.
stopifnot(length(entry_starts) == 43L)

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
is_article <- vapply(entries, function(x) grepl("^@article", x[[1L]], ignore.case = TRUE), logical(1L))
article_entries <- entries[is_article]
software_entries <- entries[keys == "MinCED"]
preprint_entries <- entries[keys == "Li2013BWAMEM"]
dois <- tolower(vapply(article_entries, extract_field, character(1L), field = "doi"))

historical_keys <- c(
  "Aroney2025", "Benjamini1995", "Cheng2019", "Dahl2022", "Lu2016", "Maslowska2019",
  "Myshkevych2025", "Nayfach2021", "Olm2021", "Parks2022",
  "Robinson2010edgeR", "Robinson2010TMM", "Scarascia2021",
  "Schwengers2021", "vonMeijenfeldt2019", "Wu2012"
)
new_article_keys <- c("Love2014", "Zhang2021SpacePHARER", "Edgar2007",
                      "Callahan2016", "Martin2011", "Quast2013", "McMurdie2013",
                      "Li2015MEGAHIT", "Ruehlemann2022", "Olm2017dRep",
                      "Camargo2024geNomad", "Guo2021VirSorter2", "Peng2024ViraLM",
                      "Hou2024DeepMicroClass", "Zielezinski2025Vclust",
                      "Chen2018fastp", "Kopylova2012SortMeRNA",
                      "Li2009SAMtools", "Quinlan2010BEDTools",
                      "Alneberg2014CONCOCT", "Wu2016MaxBin", "Kang2019MetaBAT",
                      "Nissen2021Vamb", "Pan2023SemiBin2", "Tisza2026CenoteTaker3")
required_keys <- c(historical_keys, new_article_keys, "MinCED", "Li2013BWAMEM")

stopifnot(
  setequal(keys, required_keys),
  !anyDuplicated(keys),
  !anyDuplicated(dois),
  all(grepl("^10\\.[0-9]{4,9}/[^[:space:]]+$", dois)),
  all(vapply(article_entries, function(x) {
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
stopifnot(length(software_entries) == 1L,
          extract_key(software_entries[[1L]]) == "MinCED",
          extract_field(software_entries[[1L]], "url") == "https://github.com/ctSkennerton/minced",
          nzchar(extract_field(software_entries[[1L]], "author")),
          nzchar(extract_field(software_entries[[1L]], "title")))
stopifnot(length(article_entries) == 41L, length(preprint_entries) == 1L,
          extract_field(preprint_entries[[1L]], "eprint") == "1303.3997",
          extract_field(preprint_entries[[1L]], "howpublished") == "arXiv preprint",
          extract_field(preprint_entries[[1L]], "doi") == "10.48550/arXiv.1303.3997",
          !anyDuplicated(c(dois, tolower(extract_field(preprint_entries[[1L]], "doi")))))

reference_start <- match("## References", manuscript_lines)
legend_start <- match("## Working main-figure legends", manuscript_lines)
stopifnot(!is.na(reference_start), !is.na(legend_start), legend_start > reference_start)
manual_references <- paste(
  manuscript_lines[(reference_start + 1L):(legend_start - 1L)],
  collapse = "\n"
)

historical_dois <- tolower(vapply(entries[keys %in% historical_keys], extract_field, character(1L), field = "doi"))
stopifnot(all(vapply(
  historical_dois,
  function(doi) grepl(doi, manual_references, fixed = TRUE),
  logical(1L)
)))

revision_paths <- list.files(file.path(repo_root, "manuscript", "revisions"), pattern = "[.]md$", full.names = TRUE)
revision_text <- paste(unlist(lapply(revision_paths, readLines, warn = FALSE)), collapse = "\n")
new_dois <- tolower(vapply(entries[keys %in% new_article_keys], extract_field, character(1L), field = "doi"))
stopifnot(all(vapply(new_dois, function(doi) grepl(doi, tolower(revision_text), fixed = TRUE), logical(1L))))
stopifnot(all(vapply(c("Love et al., 2014", "Zhang et al., 2021", "Edgar, 2007",
                      "Callahan et al., 2016", "Martin, 2011", "Quast et al., 2013",
                      "McMurdie and Holmes, 2013", "Li et al., 2015", "Li, 2013",
                      "Rühlemann et al., 2022", "Olm et al., 2017",
                      "Camargo et al., 2024", "Guo et al., 2021",
                      "Peng et al., 2024", "Hou et al., 2024", "Zielezinski et al., 2025",
                      "Chen et al., 2018", "Kopylova et al., 2012",
                      "Li et al., 2009", "Quinlan and Hall, 2010",
                      "Alneberg et al., 2014", "Wu et al., 2016", "Kang et al., 2019",
                      "Nissen et al., 2021", "Pan et al., 2023", "Tisza et al., 2026"),
                    function(citation) grepl(citation, revision_text, fixed = TRUE), logical(1L))))

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

cat("test_references.R: PASS (41 DOI articles, 1 DOI preprint and 1 software record; historical scaffold and versioned payloads only, not live Zotero integration)\n")
