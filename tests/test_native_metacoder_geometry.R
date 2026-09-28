# Verify native polygon areas, colour mapping and actual renderer layer types.
args <- commandArgs(trailingOnly=TRUE)
stopifnot(length(args)==1L)
area <- function(d) {
  next_index <- c(seq.int(2L,nrow(d)),1L)
  abs(sum(d$x*d$y[next_index]-d$x[next_index]*d$y))/2
}
for(community in c("votu","mag")) {
  p <- readRDS(file.path(args[[1]],"source",paste0(community,"_native_heat_tree.rds")))
  stopifnot(inherits(p$layers[[1]]$geom,"GeomPolygon"))
  d <- p$layers[[1]]$data
  nodes <- read.delim(file.path(args[[1]],"tables",paste0(community,"_plotted_nodes.tsv")),check.names=FALSE)
  shapes <- split(d,d$group,drop=TRUE)
  root_area <- area(shapes[["n000_node"]])
  stopifnot(root_area>0)
  for(i in seq_len(nrow(nodes))) {
    shape <- shapes[[paste0(nodes$node_id[[i]],"_node")]]
    stopifnot(!is.null(shape),all(is.finite(shape$x)),all(is.finite(shape$y)))
    stopifnot(all(shape$color==nodes$colour[[i]]))
    stopifnot(abs(area(shape)/root_area-nodes$clade_abundance[[i]])<1e-8)
  }
  types <- vapply(p$layers,function(x)class(x$geom)[[1]],character(1))
  stopifnot(all(types %in% c("GeomPolygon","GeomFitText")))
  cat("PASS:",community,"native polygons retain",nrow(nodes),"nodes, exact colours and abundance-proportional areas; native text only.\n")
}
