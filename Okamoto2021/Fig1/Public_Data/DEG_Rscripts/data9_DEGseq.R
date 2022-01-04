# Load libraries
library(openxlsx)
library(tidyverse)
library(DEGseq)

# Clear environment
rm(list = ls())

# Loading data
data <- read.table("GSE106589_geneCounts.csv", sep=",", header=T)

# Exclude columns with missing values
data <- na.omit(data)
data_selected <- data.frame(matrix(rep(NA,ncol(data)),nrow=1))[numeric(0), ]
colnames(data_selected) <- colnames(data)
chk_prod_zero <- function(x) {
  if (prod(as.numeric(x[2:95])) != 0) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
selected_rows <- as.vector(nrow(data))
selected_rows <- apply(data, 1, chk_prod_zero)
data_selected <- data[selected_rows,]

# Separate data for case and control
case <- data_selected[, c(2:25,32:37,70:75,82:91)]
control <- data_selected[, c(26:31,38:69,76:81,92:95)]
caseFB <- data_selected[, c(seq(2, 24, 2), seq(32, 36, 2), seq(70, 74, 2), seq(82, 90, 2))]
controlFB <- data_selected[, c(seq(26, 30, 2), seq(38, 52, 2), 54, 55, seq(58, 64, 2), 66, 67, seq(76, 80, 2), seq(92, 94))]

caseFB <- cbind(data_selected[, 1], caseFB) %>% 
  rename("gene" = 1)
controlFB <- cbind(data_selected[, 1], controlFB) %>% 
  rename("gene" = 1)

# Test the significance
DEGexp(geneExpMatrix1 = caseFB,
       geneCol1 = 1,
       expCol1 = c(2:24),
       groupLabel1 = "case",
       geneExpMatrix2 = controlFB, 
       geneCol2 = 1,
       expCol2 = c(2:26),
       groupLabel2 = "control",
       method = "MARS",
       thresholdKind = 5,
       qValue = 0.05,
       foldChange = 1.5,
       outputDir = "./data9_MARS",
       rawCount = TRUE)
new_data <- read_tsv("./data9_MARS/output_score.txt")
gene_new_data <- new_data %>% 
  filter(`Signature(q-value(Storey et al. 2003) < 0.05)` == TRUE) %>% 
  select(GeneNames)

# Save the DEG list
write_tsv(gene_new_data,
          "./data9_MARS/data9_DEG.txt", col_names = FALSE)
