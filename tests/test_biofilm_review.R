# Independent checks of joins, correction families and selected cameraPR calls.
suppressPackageStartupMessages({library(data.table);library(limma)})
out<-commandArgs(trailingOnly=TRUE)[[1]]
inputs<-fread(file.path(out,"input_sha256.tsv"))
path<-function(id)inputs[input==id,path]
sha<-function(p)digest::digest(file=p,algo="sha256")
stopifnot(all(vapply(inputs$path,sha,character(1))==inputs$sha256))
manifest<-fread(file.path(out,"output_sha256.tsv"))
stopifnot(all(vapply(file.path(out,manifest$path),sha,character(1))==manifest$sha256))
membership<-fread(file.path(out,"tables/gene_set_membership.tsv"))
sets<-fread(file.path(out,"tables/set_registry_and_eligibility.tsv"))
stopifnot(!anyDuplicated(membership[,.(feature_id,set_id)]),
 sets[set_id=="biofilm_union",NGenes]==3489L,
 sets[set_id=="quorum",test_status]=="not_tested_fewer_than_10_genes")
cnd<-fread(path("condition"),select=c("feature_id","annotation","MAG_ID","gene_symbol","F","logFC","p_value","FDR"))
historical<-cnd[!is.na(MAG_ID) & grepl("Biofilm|Quorum sensing|Adhesion|Exopolysaccharide|Motility|Flagella|Pili|Extracellular|matrix",annotation,ignore.case=TRUE),feature_id]
stopifnot(setequal(historical,membership[set_id=="historical9",feature_id]))
actual_union<-unique(membership[set_id %in% sets[role=="module",set_id],feature_id])
stopifnot(setequal(actual_union,membership[set_id=="biofilm_union",feature_id]))
tests<-fread(file.path(out,"tables/expanded_gene_set_tests.tsv"))
stopifnot(all(tests$Direction %in% c("Up","Down","Non-directional")),
          !"quorum" %in% tests$set_id,
          all(tests[coefficient=="trajectory",Direction]=="Non-directional"))
for(rho in unique(tests$correlation)){
 x<-tests[correlation==rho]
 stopifnot(isTRUE(all.equal(x$FDR_all_sets_coefficients,p.adjust(x$PValue,"BH"))))
}
old<-fread(path("old_membership"))[,.(feature_id,set_id=category)]
joined<-unique(rbind(membership[,.(feature_id,set_id)],old))
index<-split(match(joined$feature_id,cnd$feature_id),joined$set_id)
index<-index[lengths(index)>=10]
joint<-fread(path("omnibus"),select=c("feature_id","F","p_value","FDR"))
joint<-joint[match(cnd$feature_id,feature_id)]
for(coef in c("condition","trajectory"))for(rho in c(.01,.1)){
 stopifnot(all(cnd[F<0,p_value]==1),all(joint[F<0,p_value]==1),
           all(cnd[F<0,FDR]==1),all(joint[F<0,FDR]==1))
 stat<-if(coef=="condition")sign(cnd$logFC)*sqrt(pmax(cnd$F,0)) else sqrt(pmax(joint$F,0))
 check<-as.data.table(cameraPR(stat,index,use.ranks=TRUE,directional=coef=="condition",
                         inter.gene.cor=rho,sort=FALSE),keep.rownames="set_id")
 actual<-tests[coefficient==coef & correlation==rho][match(check$set_id,set_id)]
 stopifnot(isTRUE(all.equal(actual$PValue,check$PValue)),
           isTRUE(all.equal(actual$FDR_within_coefficient,check$FDR)))
}
trajectory<-fread(file.path(out,"tables/set_trajectories.tsv"))
stopifnot(all(table(trajectory$set_id)==12),all(is.finite(trajectory$median_centered_log2CPM)))
cat("PASS: membership, frozen input/output hashes, 12 samples/set, named columns, BH families, independently recomputed condition/joint cameraPR at rho0.01/0.1\n")
