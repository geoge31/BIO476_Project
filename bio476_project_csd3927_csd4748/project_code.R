#############################################   
#               BIO476                      #
#           Project - Spring 2024           #
#           Giorgos Geramoutsos csd3927     #
#           Theodora Symeonidou csd4748     #
#############################################  

# Libraries

library(limma)
library(matrixStats)
library(ggplot2)
library(tidyr)
library(biomaRt)

pr_List = list()


# 1 

gds_6010 = readLines("GDS6010.soft")
gds_6010_cleaned = gds_6010[!grepl("[!^#]",gds_6010)]
writeLines(gds_6010_cleaned,"GDS6010.soft")

samples = read.table("GDS6010.soft", sep = "\t", header=T, na.strings="null")

samples = samples[ , 3:ncol(samples)]



pr_List[[1]] = "Samples (10x7)"
pr_List[[2]] = samples[1:10, 1:7]

print(pr_List)

# 2 

pr_List = NULL

exps = samples[ , c(1:6, 13:18)]

time_points = c(rep(6,6), rep(24,6))
time_factor = factor(time_points, levels=c(6,24))

infection_status = factor(rep(rep(c("infection","control"), each=3),2))
infection_factor = factor(infection_status, levels = c("infection", "control"))

pr_List[[1]] = "Time Factor"
pr_List[[2]] = time_factor
pr_List[[3]] = "Infection Factor"
pr_List[[4]] = infection_factor

print(pr_List)

# 3 

pr_List = NULL

design = model.matrix(~ 0 + time_factor * infection_factor)
colnames(design) = c("time_6", "time_24", "infection_control", "time_24Xinfection_control")

pr_List[[1]] = "Design"
pr_List[[2]] = design

print(pr_List)

pr_List = NULL

fitA = lmFit(exps, design)

pr_List[[1]] = "fit A"
pr_List[[2]] = fitA

print(pr_List)

pr_List = NULL

contrasts = makeContrasts(time24h_vs_time6h = time_24-time_6, levels=design)
# contrasts

pr_List[[1]] = "Contrasts"
pr_List[[2]] = contrasts

print(pr_List)

pr_List = NULL

fitB = contrasts.fit(fitA, contrasts)
fitB = eBayes(fitB)
# fitB

pr_List[[1]] = "fit B"
pr_List[[2]] = fitB

print(pr_List)

pr_List = NULL

top_table = topTable(fitB, adjust.method="fdr", number=Inf)
#top_table
significant_genes = top_table[top_table$adj.P.Val < 0.05 & abs(top_table$logFC) > 1, ]
# significant_genes

pr_List[[1]] = 'Adjusted Significant Genes (first 20) :'
pr_List[[2]] = head(significant_genes, n=20)

print(pr_List)


# 4 

percentage = nrow(significant_genes) / nrow(exps) * 100
cat("Percentage of affected genes: \n",percentage, "%\n")


# 5 

# SOLUTION 2 

# lathos handling 


gene_expression = as.vector(t(exps))

time_factor_l = rep(time_factor, each=nrow(exps))
infection_factor_l = rep(infection_factor, each=nrow(exps))

exps_df = data.frame(gene_expression, time_factor = time_factor_l, infection_factor = infection_factor_l)

model = lm(gene_expression ~ time_factor * infection_factor, data = exps_df)
summary(model)

# SOLUTION 3 
gene_expression = as.vector(t(exps))

time_factor_l = rep(time_factor, nrow(exps))

infection_factor_l = rep(infection_factor, nrow(exps))

exps_df = data.frame(gene_expression, time_factor = time_factor_l, infection_factor = infection_factor_l)

model = lm(gene_expression ~ time_factor * infection_factor, data = exps_df)

summary(model)


# 6 

time_points_all = c(rep(6, 6), rep(12, 6), rep(24, 6))
time_factor_all = factor(time_points_all, levels = c(6, 12, 24))

infection_status_all = factor(rep(rep(c("infection", "control"), each=3), 3))
infection_factor_all = factor(infection_status_all, levels = c("infection", "control"))

exps_all = samples[, 1:18]
gene_expression_all = as.vector(t(exps_all))

design_all = model.matrix(~ 0 + infection_factor_all * time_factor_all )
colnames(design_all) = c("infection", "control", "hour12", "hour24", "controlXhour12", "controlXhour24")

fit_all = lmFit(exps_all, design_all)
fit_all = eBayes(fit_all)


contrasts_all = makeContrasts(infected_vs_control = infection-control, levels=design_all)

fit_contrasts_all = contrasts.fit(fit_all, contrasts_all)
fit_contrasts_all = eBayes(fit_contrasts_all)

significant_genes_all = topTable(fit_contrasts_all, adjust.method = "fdr", number = Inf)
significant_genes_all = significant_genes_all[significant_genes_all$adj.P.Val < 0.05 & abs(significant_genes_all$logFC) > 1, ]

head(significant_genes_all, n=30)


# 7 

mart = useMart(dataset="hsapiens_gene_ensembl", host = "https://jan2024.archive.ensembl.org", biomart="ensembl")

pr_List = NULL

top_100_genes = head(significant_genes_all[order(significant_genes_all$P.Value), ], 100)
gene_ids = rownames(top_100_genes)
# gene_ids


seqs = getSequence(id=gene_ids,
                   type="entrezgene_id", 
                   seqType="gene_flank",
                   upstream=1000,
                   mart=mart)

pr_List[[1]] = "Top 100 genes names :"
pr_List[[2]] = gene_ids
pr_List[[3]] = "Promoters entrezgene_id :"
pr_List[[4]] = seqs$entrezgene_id
pr_List[[5]] = "Promoters gene flank (Just on for example ):"
pr_List[[6]] = seqs$gene_flank[1]

print(pr_List)

pr_List = NULL

# set.seed(123) 
random_genes_indices = sample(nrow(exps_all), 1000)
random_genes_ids = rownames(exps_all)[random_genes_indices]


seqs_random = getSequence(id=random_genes_ids,
                   type="entrezgene_id", 
                   seqType="gene_flank",
                   upstream=1000,
                   mart=mart)
# seqs

pr_List[[1]] = "Random Genes "
pr_List[[2]] = random_genes_ids
pr_List[[3]] = "Promoters entrezgene_id :"
pr_List[[4]] = seqs_random$entrezgene_id
pr_List[[5]] = "Promoters gene flank (just one for example) :"
pr_List[[6]] = seqs_random$gene_flank[1]

print(pr_List)

processArrayMotifsSub = function(sequences, k=6){
  counterSeq = 0
  allMotifs = list()

  for(seq in sequences){
    currentMotifs = getMotifsSeqSub(seq, k=k)

    for(mot in names(currentMotifs)){
      if(mot %in% names(allMotifs)){
        allMotifs[[mot]] = allMotifs[[mot]] + currentMotifs[[mot]]
      }else{
        allMotifs[[mot]] = currentMotifs[[mot]]
      }
    }
  }
  
  return(allMotifs)
}


getMotifsSeqSub = function(seq, k=6){
  
  myMotifs = list()
  
  for(i in 1:(nchar(seq)-k+1)){
    
    mot = substr(seq, i, i+k-1)
    
    if(mot %in% names(myMotifs)){
      myMotifs[[mot]] = myMotifs[[mot]] + 1 
    }else{
      myMotifs[[mot]] = 1
    }
  }
  
  return (myMotifs)
}

pr_List = NULL


mmotivs_count_100_genes = processArrayMotifsSub(seqs[,1], k=6)
mmotivs_count_random_genes = processArrayMotifsSub(seqs_random[,1], k=6)

newdf = data.frame(mmotivs_count_100_genes)
newdf2 = data.frame(mmotivs_count_random_genes)

pr_List[[1]] = "Motivs found in 100 genes (first 10):"
pr_List[[2]] = head(mmotivs_count_100_genes, n=10)
pr_List[[3]] = "Overexpressed gene (Name and Position) :"
pr_List[[4]] = which.max(mmotivs_count_100_genes)
pr_List[[5]] = "Times found :"
pr_List[[6]] = max(newdf)

pr_List[[7]] = "Motivs found in 1000 random genes (first 20):"
pr_List[[8]] = head(mmotivs_count_random_genes, n=10)
pr_List[[9]] = "Overexpressed gene (Name and Position) :"
pr_List[[10]] = which.max(mmotivs_count_random_genes)
pr_List[[11]] = "Times found :"
pr_List[[12]] = max(newdf2)
pr_List[[13]] = "TTTTTT found in 100 genes"
pr_List[[14]] = newdf$TTTTTT
pr_List[[15]] = "TTTTTT found in random genes"
pr_List[[16]] = newdf2$TTTTTT

print(pr_List)

# 1os Tropos

k = newdf$TTTTTT
totalfor = 100
kback = newdf2$TTTTTT
totalback = 1000
pvalue = phyper(q=k-1, m=kback, n=totalback - kback, k = totalfor, lower.tail = FALSE)
pvalue

# 2os Tropos

pvalue = pbinom(q = k, size = totalfor, prob = kback/totalback, lower.tail = FALSE)
pvalue