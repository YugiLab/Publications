# Load libraries
library(ggplot2)

# Clear environment
rm(list = ls())

# Load data
data <- read.table("GSE92874_RNA.txt", header=T)

# Exclude columns with missing values
data <- na.omit(data)
data_selected <- data.frame(matrix(rep(NA,ncol(data)),nrow=1))[numeric(0), ]
colnames(data_selected) <- colnames(data)
chk_prod_zero <- function(x) {
  if (prod(as.numeric(x[2:9])) != 0) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
selected_rows <- as.vector(nrow(data))
selected_rows <- apply(data, 1, chk_prod_zero)
data_selected <- data[selected_rows,]

# Separate data for case and control
case <- data_selected[,6:9]
control <- data_selected[,2:5]

# Calculate FoldChange
foldchange <- apply(case, 1, mean)/apply(control, 1, mean)

# Calculate P-value
p_values <- apply(cbind(case,control),1,function(x) {t.test(x[1:4],x[5:8])$p.value})

# Add Fold Change and P-value columns to data with missing values excluded.
volcano <- data.frame(FoldChange=foldchange, p.value=p_values)
data_selected2 <- cbind(data_selected,volcano)

# Narrow down by each criteria
data_selected3 <- data.frame(matrix(rep(NA,ncol(data_selected2)),nrow=1))[numeric(0), ]
colnames(data_selected3) <- colnames(data_selected2)

for (j in 1:nrow(data_selected2)){
    if ((data_selected2[j,15] > 1.5 || (data_selected2[j,15] < 2/3)) && (data_selected[j,12] < 0.05 )){
        data_selected3 <- rbind(data_selected3, data_selected[j,])    }
}

# Save the DEG list
write.csv(data_selected3,
          "data2_DEG.csv")
