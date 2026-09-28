suppressPackageStartupMessages({library(data.table);library(DESeq2);library(digest)})
out<-commandArgs(trailingOnly=TRUE)[[1]]
tab<-function(n)fread(file.path(out,"tables",n))
for(manifest in c("input_sha256.tsv","output_sha256.tsv")){
 x<-fread(file.path(out,manifest))
 paths<-if(manifest=="input_sha256.tsv")x$path else file.path(out,x$path)
 stopifnot(all(vapply(paths,function(p)digest(file=p,algo="sha256"),character(1))==x$sha256))
}
m<-tab("sample_metadata.tsv")
stopifnot(nrow(m)==12,all(table(m$condition,m$phase,m$cycle)==1))
for(layer in c("mag","votu")){
 raw<-tab(paste0(layer,"_counts.tsv"));f<-tab(paste0(layer,"_filter.tsv"))
 mat<-as.matrix(raw[,-1]);rownames(mat)<-raw$feature_id
 stopifnot(identical(colnames(mat),m$sample_title),identical(f$retained,unname(rowSums(mat>=10)>=3)))
 a<-tab(paste0(layer,"_main_wald.tsv"));b<-tab(paste0(layer,"_interaction_lrt.tsv"))
 stopifnot(!anyDuplicated(a$feature_id),setequal(a$feature_id,raw$feature_id[f$retained]),setequal(a$feature_id,b$feature_id))
 stopifnot(!"log2FoldChange" %in% names(b),all(b$test_df==2),all(b$stat>=-1e-8,na.rm=TRUE))
 for(z in list(a,b))stopifnot(isTRUE(all.equal(z$padj_BH_all_nonmissing,p.adjust(z$pvalue,"BH"),tolerance=1e-12)))
 ok<-is.finite(b$pvalue)
 stopifnot(isTRUE(all.equal(b$pvalue[ok],pchisq(b$stat[ok],df=2,lower.tail=FALSE),tolerance=1e-8)))
 main<-readRDS(file.path(out,"models",paste0(layer,"_main.rds")))
 full<-readRDS(file.path(out,"models",paste0(layer,"_interaction_lrt.rds")))
 stopifnot(all(mcols(main)$betaConv),all(mcols(full)$fullBetaConv),all(mcols(full)$reducedBetaConv))
 stopifnot(qr(model.matrix(design(main),as.data.frame(colData(main))))$rank==5,
           qr(model.matrix(design(full),as.data.frame(colData(full))))$rank==7)
 stopifnot(isTRUE(all.equal(sizeFactors(main),sizeFactors(full))),all(sizeFactors(full)>0))
 # Re-run LRT from the saved dispersions and design, independent of exported tables.
 again<-nbinomLRT(full,reduced=~phase+cycle+condition,quiet=TRUE)
 rr<-as.data.table(as.data.frame(results(again,alpha=.05)),keep.rownames="feature_id")
 stopifnot(identical(rr$feature_id,b$feature_id),isTRUE(all.equal(rr$stat,b$stat,tolerance=1e-7)),
           isTRUE(all.equal(rr$pvalue,b$pvalue,tolerance=1e-7)))
 cat(layer,": PASS hashes, sample mapping, filter, design, convergence, BH, chi-square p and repeated LRT\n")
}
