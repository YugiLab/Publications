# Load libraries
library(openxlsx)
library(tidyverse)
library(DEGseq)

# Clear environment
rm(list = ls())

# Loading data
data <- read.xlsx("GSE121376_TPM_14pairs.xlsx", rowNames = TRUE)

# Exclude columns with missing values
data <- na.omit(data)
data <- as.data.frame(t(apply(data, 1, function(x){round(x, 2)})))
rowname_data <- rownames(data)
data <- cbind(rowname_data, data)
data <- data %>% rename("GENE_ID" = 1)
data_selected <- data.frame(matrix(rep(NA,ncol(data)),nrow=1))[numeric(0), ]
colnames(data_selected) <- colnames(data)
chk_prod_zero <- function(x) {
  if (prod(as.numeric(x[2:57])) != 0) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
selected_rows <- as.vector(nrow(data))
selected_rows <- apply(data, 1, chk_prod_zero)
data_selected <- data[selected_rows,]

# Separate data for case and control
case <- data_selected[,2:29]
control <- data_selected[,30:57]

case <- cbind(data_selected[, 1], case) %>% 
  rename("gene" = 1)
control <- cbind(data_selected[, 1], control) %>% 
  rename("gene" = 1)

# Test the significance
DEGexp(geneExpMatrix1 = case,
       geneCol1 = 1,
       expCol1 = c(2:29),
       groupLabel1 = "case",
       geneExpMatrix2 = control, 
       geneCol2 = 1,
       expCol2 = c(2:29),
       groupLabel2 = "control",
       method = "MARS",
       thresholdKind = 5,
       qValue = 0.05,
       foldChange = 1.5,
       outputDir = "./data5_MARS",
       rawCount = FALSE)
new_data <- read_tsv("./data5_MARS/output_score.txt")
gene_new_data <- new_data %>% 
  filter(`Signature(q-value(Storey et al. 2003) < 0.05)` == TRUE) %>% 
  select(GeneNames)

# Save the DEG list
write_tsv(gene_new_data,
          "./data5_MARS/data5_DEG.txt", col_names = FALSE)
