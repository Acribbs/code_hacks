library(org.Hs.eg.db)
library(UniprotR)
library(tidyverse)

inf = read.table("human.txt", header=1, sep="\t")


ensembl_to_symbol <- function(dataframe, ensembl_column){
  
  dataframe_tmp <- dataframe %>% 
    select(ensembl_column)
  data <- unlist(dataframe_tmp)
  data <- as.vector(data)
  annots <-  AnnotationDbi::select(org.Hs.eg.db, keys=data,
                                   columns=c("SYMBOL","GENENAME"), keytype = "ENSEMBL")
  
  result <- merge(dataframe, annots, by.x=ensembl_column, by.y="ENSEMBL")
  return(result)
}


ensembl_to_symbol(inf, "To")

convertMouseGeneList <- function(x){
  
  require("biomaRt")
  human = useMart("ensembl", dataset = "hsapiens_gene_ensembl")
  mouse = useMart("ensembl", dataset = "mmusculus_gene_ensembl")
  
  genesV2 = getLDS(attributes = c("mgi_symbol"), filters = "mgi_symbol", values = x , mart = mouse, attributesL = c("hgnc_symbol"), martL = human, uniqueRows=T)
  humanx <- unique(genesV2[, 2])
  
  # Print the first 6 genes found to the screen
  print(head(humanx))
  return(humanx)
}



  human.old <- useMart(host="jul2016.archive.ensembl.org", 
                       "ENSEMBL_MART_ENSEMBL", 
                       dataset="hsapiens_gene_ensembl")
  
  mouse.old   <- useMart(host="jul2016.archive.ensembl.org", 
                         "ENSEMBL_MART_ENSEMBL", 
                         dataset="mmusculus_gene_ensembl")
  
  genesV2 = getLDS(attributes = c("ensembl_gene_id"), filters = "ensembl_gene_id", values = annotLookup$ensembl_gene_id, mart = human.old, attributesL = c("ensembl_gene_id"), martL = mouse.old, uniqueRows=T)
  




mart <- useMart('ENSEMBL_MART_ENSEMBL')
mart <- useDataset('hsapiens_gene_ensembl', mart)

annotLookup <- getBM(
  mart = mart,
  attributes = c(
    'ensembl_gene_id',
    'gene_biotype',
    'external_gene_name',
    'uniprot_gn_symbol',
    'uniprotswissprot'),
  uniqueRows=TRUE)

mart <- useMart('ENSEMBL_MART_ENSEMBL')
mart <- useDataset('mmusculus_gene_ensembl', mart)

annotLookup_mouse <- getBM(
  mart = mart,
  attributes = c(
    'ensembl_gene_id',
    'gene_biotype',
    'external_gene_name',
    'uniprot_gn_symbol',
    'uniprotswissprot'),
  uniqueRows=TRUE)


library(dplyr)

join1 = full_join(x = genesV2, y = annotLookup, by = c("Ensembl.Gene.ID" = "ensembl_gene_id"))
join2 = full_join(x = genesV2, y = annotLookup_mouse, by = c("Ensembl.Gene.ID.1" = "ensembl_gene_id"))

final = full_join(x = join1, y = join2, by = "Ensembl.Gene.ID")
final = na.omit(final)

write.csv(final, file="output_mapping_table_noNA.csv")

inf = read.csv("Human to Mouse uniprot.csv")

xjoin = left_join(inf, final, by = c("Human.Uniprot.acsession" = "uniprotswissprot"))
xjoin

x = listAttributes(mart)
