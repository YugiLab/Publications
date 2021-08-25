library(ggplot2)

# Loading data
data <- read.table("GSE40102_analysis.csv", sep=",", header=T)

#Narrow down by each criteria
data.selected3 <- data.frame(matrix(rep(NA,ncol(data)),nrow=1))[numeric(0), ]
colnames(data.selected3) <- colnames(data)

for (j in 1:nrow(data)){
    if (data[j,6] < 0.05){
        data.selected3 <- rbind(data.selected3, data[j,])
    }
}
