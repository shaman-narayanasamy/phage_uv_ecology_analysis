#!/usr/bin/env Rscript
Sys.setenv(PHAGE_UV_REVIEW_TEST_ONLY="1")
f <- tempfile(fileext=".R")
knitr::purl("analysis/votu_taxonomic_resolution_review.qmd",output=f,quiet=TRUE)
source(f); unlink(f)
lineage <- c("-_Viruses;-_Duplodnaviria;k_Heunggongvirae;p_Uroviricota;c_Caudoviricetes",
  "-_Viruses;-_Riboviria;k_Orthornavirae;p_Kitrinoviricota;c_Tolucaviricetes;o_Tolivirales;f_Tombusviridae;-_Procedovirinae;g_Gammacarmovirus",
  "unclassified virus", "", NA_character_,
  "-_Viruses;-_Varidnaviria;k_Bamfordvirae;p_Preplasmiviricota;-_Prepoliviricotina;c_Tectiliviricetes;o_Kalamavirales;f_Tectiviridae")
stopifnot(identical(parse_rank(lineage,"realm"),c("Duplodnaviria","Riboviria",NA,NA,NA,"Varidnaviria")),
  identical(parse_rank(lineage,"order"),c(NA,"Tolivirales",NA,NA,NA,"Kalamavirales")),
  identical(parse_rank(lineage,"genus"),c(NA,"Gammacarmovirus",NA,NA,NA,NA)))
stopifnot(identical(deepest_label(lineage),c("c_Caudoviricetes","g_Gammacarmovirus",NA,NA,NA,"f_Tectiviridae")))
nested <- data.table(contig_id=c("parent_only","child"),mixed=deepest_label(c(
  "-_Viruses;-_Duplodnaviria;c_Caudoviricetes",
  "-_Viruses;-_Duplodnaviria;c_Caudoviricetes;o_Crassvirales;f_Steigviridae")))
nested_counts <- data.table(contig_id=nested$contig_id,sample_title="one",reads=c(80,20))
nested_profile <- aggregate_rank(nested_counts,nested,"mixed")$profile
stopifnot(nested_profile[category=="c_Caudoviricetes",reads]==80,
          nested_profile[category=="f_Steigviridae",reads]==20,
          sum(nested_profile$reads)==100)
taxa <- data.table(contig_id=c("a","b","c"),class=c("ClassA","ClassB",NA_character_))
counts <- data.table(contig_id=rep(c("a","b","c"),2),sample_title=rep(c("one","two"),each=3),reads=c(60,30,10,0,5,5))
res <- aggregate_rank(counts,taxa,"class",top_n=1L)$profile
stopifnot(res[sample_title=="one" & category=="Unresolved at this rank",reads]==10,
          res[sample_title=="two" & category=="Unresolved at this rank",relative_abundance]==.5,
          all(abs(res[,sum(relative_abundance),by=sample_title]$V1-1)<1e-12),
          "Other classified taxa" %in% res$category)
# Compare a permutation of both inputs and retain explicit zero-count taxa.
a <- aggregate_rank(counts,taxa,"class")$profile
b <- aggregate_rank(counts[6:1],taxa[3:1],"class")$profile
setorder(a,sample_title,category);setorder(b,sample_title,category)
stopifnot(identical(a,b),a[sample_title=="two" & category=="ClassA",reads]==0)
fails <- function(expr) inherits(tryCatch({force(expr);NULL},error=identity),"error")
stopifnot(fails(aggregate_rank(rbind(counts,counts[1]),taxa,"class")),
          fails(aggregate_rank(counts,rbind(taxa,taxa[1]),"class")),
          fails(aggregate_rank(counts[,reads:=0],taxa,"class")),
          fails(parse_rank("-_Viruses;-_Riboviria;f_First;f_Second","family")))
cat("PASS: rank parsing, unranked intermediate nodes, unresolved taxa, zero counts, top-N remainder, conservation, row permutation and invalid-input rejection.\n")
