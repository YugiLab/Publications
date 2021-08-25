library(openxlsx)
library(ggplot2)

# Loading data
data <- read.xlsx("GSE121376_TPM_14pairs.xlsx", rowNames = TRUE)

# Exclude columns with missing values
data <- na.omit(data)
data <- t(apply(data, 1, function(x){round(x, 2)}))
data.selected <- data.frame(matrix(rep(NA,ncol(data)),nrow=1))[numeric(0), ]
colnames(data.selected) <- colnames(data)

for (i in 1:nrow(data)){
    if (prod(data[i,1:56]) != 0){
        data.selected <- rbind(data.selected, data[i,])
    }
}

#Separate data for case and control
case <- data.selected[,1:28]
control <- data.selected[,29:56]

#Calculate FoldChange
foldchange <- apply(case, 1, mean)/apply(control, 1, mean)

#Calculate P-value
p.values <- apply(cbind(case,control),1,function(x) {t.test(x[1:28],x[29:56])$p.value})

#Add Fold Change and P-value columns to data with missing values excluded.
volcano <- data.frame(FoldChange=foldchange, p.value=p.values)
data.selected2 <- cbind(data.selected,volcano)

#Narrow down by each criteria
data.selected3 <- data.frame(matrix(rep(NA,ncol(data.selected2)),nrow=1))[numeric(0), ]
colnames(data.selected3) <- colnames(data.selected2)

for (j in 1:nrow(data.selected2)){
    if (data.selected2[j,58] < 0.05){
        data.selected3 <- rbind(data.selected3, data.selected2[j,])
    }
}
