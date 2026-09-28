suppressPackageStartupMessages(library(data.table))
out<-commandArgs(TRUE)[1]
g<-fread(file.path(out,"tables/dependence_results.tsv"))
a<-fread(file.path(out,"tables/gene_block_assignments.tsv.gz"))
n<-readRDS(file.path(out,"null_distributions.rds"))
family_size<-length(unique(g$set_id))*12L
stopifnot(nrow(g)==family_size,!anyDuplicated(a[,.(resolution,set_id,feature_id)]),
 all(g$K_blocks<=g$original_hits),
 isTRUE(all.equal(g$FDR_all_planned,p.adjust(g$p,"BH",n=family_size))))
for(res in unique(g$resolution)){
 b<-fread(file.path(out,"tables",paste0("blocks_",res,".tsv")))
 z<-g[resolution==res]
 stopifnot(isTRUE(all.equal(z$FDR_per_resolution,p.adjust(z$p,"BH",n=family_size/3))))
 for(i in seq_len(nrow(z))){
  s<-z$set_id[i];e<-z$endpoint[i];bb<-b[set_id==s]
  stopifnot(sum(bb[[e]])==z$K_blocks[i],nrow(bb)==z$N_blocks[i])
  if(z$K_blocks[i]<2)next
  h<-bb[get(e)==TRUE,.N,by=MAG_ID]$N
  obs<-sum((h/sum(h))^2)
  sim<-n[[paste(res,s,e,sep="/")]]
  stopifnot(abs(obs-z$simpson[i])<1e-12,
   abs((sum(sim>=obs-1e-12)+1)/100001-z$p[i])<1e-12)
 }
}
h<-fread(file.path(out,"output_sha256.tsv"))
stopifnot(all(vapply(file.path(out,h$path),function(p)digest::digest(file=p,algo="sha256"),character(1))==h$sha256))
cat("PASS: unique assignments, block totals, hit collapse, independent statistic/p/BH recalculation, output hashes\n")
