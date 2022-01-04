# Load libraries
library(openxlsx)
library(tidyverse)
library(DEGseq)

# Clear environment
rm(list = ls())

# Loading data
data <- read.table("GSE152438_TPM32.csv", sep=",", header=T)

# Exclude columns with missing values
data <- na.omit(data)
data_selected_ND <- data_frame(matrix(rep(NA,ncol(data)),nrow=1))[numeric(0), ]
colnames(data_selected_ND) <- colnames(data)
data_selected_Nor <- data_frame(matrix(rep(NA,ncol(data)),nrow=1))[numeric(0), ]
colnames(data_selected_Nor) <- colnames(data)
chk_prod_zero_ND <- function(x) {
  if (prod(as.numeric(x[2:9])) != 0) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
chk_prod_zero_Nor <- function(x) {
  if (prod(as.numeric(x[18:25])) != 0) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
selected_rows_ND <- as.vector(nrow(data))
selected_rows_ND <- apply(data, 1, chk_prod_zero_ND)
data_selected_ND <- data[selected_rows_ND,]
selected_rows_Nor <- as.vector(nrow(data))
selected_rows_Nor <- apply(data, 1, chk_prod_zero_Nor)
data_selected_Nor <- data[selected_rows_Nor,]

# Separate data for case and control
NDcase <- data_selected_ND[,c(2:4,6)]
NDcontrol <- data_selected_ND[,c(5,7:9)]
Norcase <- data_selected_Nor[,c(18:21)]
Norcontrol <- data_selected_Nor[,c(22:25)]

NDcase <- cbind(data_selected_ND[, 1], NDcase) %>% 
  rename("gene" = 1)
NDcontrol <- cbind(data_selected_ND[, 1], NDcontrol) %>% 
  rename("gene" = 1)
Norcase <- cbind(data_selected_Nor[, 1], Norcase) %>% 
  rename("gene" = 1)
Norcontrol <- cbind(data_selected_Nor[, 1], Norcontrol) %>% 
  rename("gene" = 1)

# Test the significance of data10
DEGexp(geneExpMatrix1 = NDcase,
       geneCol1 = 1,
       expCol1 = c(2:5),
       groupLabel1 = "case",
       geneExpMatrix2 = NDcontrol, 
       geneCol2 = 1,
       expCol2 = c(2:5),
       groupLabel2 = "control",
       method = "MARS",
       thresholdKind = 5,
       qValue = 0.05,
       foldChange = 1.5,
       outputDir = "./data10_MARS",
       rawCount = FALSE)
new_data_nd <- read_tsv("./data10_MARS/output_score.txt")
gene_new_data_nd <- new_data_nd %>% 
  filter(`Signature(q-value(Storey et al. 2003) < 0.05)` == TRUE) %>% 
  select(GeneNames)

# Save the DEG list of data10
write_tsv(gene_new_data_nd,
          "./data10_MARS/data10_DEG.txt", col_names = FALSE)

# Test the significance of data11
DEGexp(geneExpMatrix1 = Norcase,
       geneCol1 = 1,
       expCol1 = c(2:5),
       groupLabel1 = "case",
       geneExpMatrix2 = Norcontrol, 
       geneCol2 = 1,
       expCol2 = c(2:5),
       groupLabel2 = "control",
       method = "MARS",
       thresholdKind = 5,
       qValue = 0.05,
       foldChange = 1.5,
       outputDir = "./data11_MARS",
       rawCount = FALSE)
new_data_nor <- read_tsv("./data11_MARS/output_score.txt")
gene_new_data_nor <- new_data_nor %>% 
  filter(`Signature(q-value(Storey et al. 2003) < 0.05)` == TRUE) %>% 
  select(GeneNames)

# Save the DEG list of data11
write_tsv(gene_new_data_nor,
          "./data11_MARS/data11_DEG.txt", col_names = FALSE)
