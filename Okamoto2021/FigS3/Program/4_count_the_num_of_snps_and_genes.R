# Load libraries
library(tidyverse)
library(gt)

# Clear environment
rm(list = ls())

# Read command line arguments
args <- commandArgs(trailingOnly = TRUE)
default_args <- c("../Data")
default_flag <- is.na(args[1])
args[default_flag] <- default_args[default_flag]

# Load result file and KEGG_ID-MSigDB-Signature file
gtex_enriched_efo <- read.table(paste(args[1], "/gtex_enriched_efo.txt", sep = ""),
                                sep = "\t",
                                header = TRUE,
                                quote = "\\")
ef_enrichment_txt <- read.table(paste(args[1], "/EF_enrichments.txt", sep = ""),
                                sep = "\t",
                                header = TRUE,
                                quote = "\"")

# Count and list the belonging genes and SNPs
efo_term <- ef_enrichment_txt %>% 
  select(name) 
result_num <- as.data.frame(NULL)
result_list <- as.list(NULL)
result_genes <- as.data.frame(NULL)

count_snps_and_genes <- function(x) {
  genes_belonging <- gtex_enriched_efo %>% 
    filter(efo_term == x) %>% 
    distinct(human_gene_name, .keep_all = TRUE) %>% 
    select(Genes = human_gene_name)
  snps_belonging <- gtex_enriched_efo %>% 
    filter(efo_term == x) %>% 
    distinct(rs_id, .keep_all = TRUE) %>% 
    select(SNPs = rs_id)
  res <- c(x, nrow(snps_belonging), nrow(genes_belonging))
  names(res) <- c("efo_term", "Num_SNPs", "Num_Genes")
  return(res)
}

list_snps_and_genes <- function(x) {
  genes_belonging <- gtex_enriched_efo %>% 
    filter(efo_term == x) %>% 
    distinct(human_gene_name, .keep_all = TRUE) %>% 
    select(Genes = human_gene_name)
  snps_belonging <- gtex_enriched_efo %>% 
    filter(efo_term == x) %>% 
    distinct(rs_id, .keep_all = TRUE) %>% 
    select(SNPs = rs_id)
  res <- list(x, genes_belonging, snps_belonging)
  names(res) <- c("efo_term", "Genes", "SNPs")
  return(res)
}

result_num <- apply(efo_term, MARGIN = 1, count_snps_and_genes)
result_num <- as.data.frame(t(result_num))
result_list <- apply(efo_term, MARGIN = 1, list_snps_and_genes)

for(i in 1:length(result_list)) {
  genes <- as.data.frame(result_list[[i]]$Genes)
  genes <- genes %>% 
    mutate(efo_term = result_list[[i]]$efo_term) %>% 
    select(2, 1)
  result_genes <- rbind(result_genes, genes)
}

# Prepare tables
table_result_num <- result_num %>% 
  slice(1:nrow(gtex_enriched_efo %>% distinct(efo_term))) %>% 
  gt() %>% 
  tab_options(column_labels.background.color = "gray90") %>% 
  tab_style(style = list(cell_text(weight = "bold")),
            locations = cells_column_labels())
table_result_num
gtsave(table_result_num, paste(args[1], "/num_genes_snps.png", sep = ""))

table_result_genes <- result_genes %>% 
  gt(groupname_col = "efo_term") %>% 
  tab_options(row_group.background.color = "gray90") %>% 
  tab_style(style = list(cell_text(weight = "bold")),
            locations = cells_row_groups())
table_result_genes
gtsave(table_result_genes, paste(args[1], "/genes_belonging.png", sep = ""))

# Save the results
write_tsv(result_num,
          paste(args[1], 
                "/number_of_SNPs_and_genes_for_each_efo_terms.txt", 
                sep = "")
          )
write_tsv(result_genes,
          paste(args[1],
                "/belonging_genes_for_each_efo_terms.txt",
                sep = "")
          )
