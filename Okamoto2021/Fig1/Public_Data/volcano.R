setwd("C:/Users/soyo6/Transomics/XGR")
library(ggplot2)

# Loading data
data <- read.table("GSE118313_RPKM_normal.csv", sep=",", header=T)

# Exclude columns with missing values
data.selected <- data.frame(matrix(rep(NA,ncol(data)),nrow=1))[numeric(0), ]
colnames(data.selected) <- colnames(data)

for (i in 1:nrow(data)){
    if (prod(data[i,9:32]) != 0){
        data.selected <- rbind(data.selected, data[i,])
    }
}

#Separate data for case and control
case <- data.selected[,9:20]
control <- data.selected[,21:32]

#Calculate FoldChange
log2foldchange <- log2(apply(case, 1, mean)/apply(control, 1, mean))

#Calculate P-value
p.values <- apply(cbind(case,control),1,function(x) {t.test(x[1:12],x[13:24])$p.value})

#Draw VolcanoPlot
volcano <- data.frame(log2FoldChange=log2foldchange, minuslog10p.value=-log10(p.values))
ggplot(data=volcano, aes(x=log2FoldChange, y=minuslog10p.value)) + geom_point() + labs(x = "log2(FoldChange)", y = "-log10(P-value)")
