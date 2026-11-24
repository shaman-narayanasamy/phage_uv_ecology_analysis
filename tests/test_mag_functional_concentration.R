suppressPackageStartupMessages(library(data.table))
out<-commandArgs(TRUE)[1]
g<-fread(file.path(out,"tables/global_concentration.tsv"))
p<-fread(file.path(out,"tables/MAG_specificity_baselines.tsv"))
m<-fread(file.path(out,"tables/membership_and_original_statistics.tsv.gz"))
stopifnot(!anyDuplicated(m[,.(feature_id,set_id)]),!anyNA(m$MAG_ID),
 all(p$set_hits<=p$eligible_set),all(p$set_hits<=p$MAG_all_hits),
 all(p$eligible_set<=p$eligible_MAG))
if("biofilm_union" %in% m$set_id) stopifnot(m[set_id=="biofilm_union",sum(FDR<.05)]==164,
 m[set_id=="biofilm_union",sum(joint_FDR<.05)]==13)
if("biofilm_combined" %in% m$set_id) stopifnot(m[set_id=="biofilm_combined",.N]==3905,
 setequal(unique(m$set_id),c("biofilm_combined","SOS_response")))
for(mode in unique(g$null)) {
 z<-g[null==mode]
 stopifnot(isTRUE(all.equal(z$FDR_simpson,p.adjust(z$p_simpson,"BH"))),
  isTRUE(all.equal(z$FDR_max,p.adjust(z$p_max,"BH"))))
}
stopifnot(isTRUE(all.equal(p$FDR_within,p.adjust(p$p_within,"BH"))))
# Independently calculate selected within-MAG upper-tail tests with Fisher 2x2.
for(i in unique(round(seq(1,nrow(p),length.out=50)))) {
 z<-p[i]; a<-z$set_hits; b<-z$eligible_set-a
 c<-z$MAG_all_hits-a; d<-z$eligible_MAG-a-b-c
 exact<-fisher.test(matrix(c(a,b,c,d),2,byrow=TRUE),alternative="greater")$p.value
 stopifnot(abs(exact-z$p_within)<1e-10)
}
nulls<-readRDS(file.path(out,"null_distributions.rds"))
for(i in which(g$status=="exploratory_gene_independence")) {
 z<-g[i]; n<-nulls[[paste(z$set_id,z$endpoint,z$null,sep="/")]]
 stopifnot(length(n$simpson)==100000,
  abs(z$p_simpson-(sum(n$simpson>=z$simpson-1e-12)+1)/100001)<1e-12,
  abs(sum(n$expected_MAG)-z$K)<1e-8)
}
h<-fread(file.path(out,"output_sha256.tsv"))
stopifnot(all(vapply(file.path(out,h$path),function(x)digest::digest(file=x,algo="sha256"),character(1))==h$sha256))
cat("PASS: membership, known counts, multiplicity, Fisher equivalence, empirical p-values, K expectations, output hashes\n")
