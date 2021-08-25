library(ggplot2)

# Loading data
data <- read.table("GSE152438_TPM32.csv", sep=",", header=T)

# Exclude columns with missing values
data <- na.omit(data)
data.selectedND <- data.frame(matrix(rep(NA,ncol(data)),nrow=1))[numeric(0), ]
colnames(data.selectedND) <- colnames(data)
data.selectedNor <- data.frame(matrix(rep(NA,ncol(data)),nrow=1))[numeric(0), ]
colnames(data.selectedNor) <- colnames(data)

for (i in 1:nrow(data)){
    if (prod(data[i,2:9]) != 0){
        data.selectedND <- rbind(data.selectedND, data[i,])
    }
}

for (i in 1:nrow(data)){
    if (prod(data[i,18:25]) != 0){
        data.selectedNor <- rbind(data.selectedNor, data[i,])
    }
}


#Separate data for case and control
NDcase <- data.selectedND[,c(2:4,6)]
NDcontrol <- data.selectedND[,c(5,7:9)]
Norcase <- data.selectedNor[,c(18:21)]
Norcontrol <- data.selectedNor[,c(22:25)]

#Calculate FoldChange
NDfoldchange <- apply(NDcase, 1, mean)/apply(NDcontrol, 1, mean)
Norfoldchange <- apply(Norcase, 1, mean)/apply(Norcontrol, 1, mean)


#Calculate P-value
NDp.values <- apply(cbind(NDcase,NDcontrol),1,function(x) {t.test(x[1:4],x[5:8])$p.value})
Norp.values <- apply(cbind(Norcase,Norcontrol),1,function(x) {t.test(x[1:4],x[5:8])$p.value})


#Add Fold Change and P-value columns to data with missing values excluded.
NDvolcano <- data.frame(FoldChange=NDfoldchange, p.value=NDp.values)
data.selected2 <- cbind(data.selectedND,NDvolcano)
Norvolcano <- data.frame(FoldChange=Norfoldchange, p.value=Norp.values)
data.selected3 <- cbind(data.selectedNor,Norvolcano)

#Narrow down by each criteria
#ND
data.selected4 <- data.frame(matrix(rep(NA,ncol(data.selected2)),nrow=1))[numeric(0), ]
colnames(data.selected4) <- colnames(data.selected2)

for (j in 1:nrow(data.selected2)){
    if (data.selected2[j,35] < 0.05){
        data.selected4 <- rbind(data.selected4, data.selected2[j,])
    }
}

#Nor
data.selected5 <- data.frame(matrix(rep(NA,ncol(data.selected3)),nrow=1))[numeric(0), ]
colnames(data.selected5) <- colnames(data.selected3)

for (j in 1:nrow(data.selected3)){
    if (data.selected3[j,35] < 0.05){
        data.selected5 <- rbind(data.selected5, data.selected3[j,])
    }
}
