#Clear the decks
rm(list = ls())

#Ready for the packages
install.packages("gplots")
install.packages("sets")
library(sets)
library(gplots)
library(ggplot2)
library(tidyverse)

#Read data
df <- read.table("alldata_dotplot_matrix.txt",row.names=1)
TGs <- colnames(df)
TFs <- rownames(df)
pureTGs <- setdiff(TGs, TFs)

#As numeric
n<-ncol(df)
ix <- 1:n
df2 <- lapply(df[ix],as.numeric)
df4hm <- as.data.frame(df2, row.names = rownames(df))
df4hm.t <- as.data.frame(t(df4hm))

#coloring一部変更
colfunc <- colorRampPalette(c("#f0f0f0","brown"))
dotcolor <- colfunc(12)
breakpoint <- c(seq(-0.01,12,length=13))
cols <- rep('black', nrow(df4hm.t))
cols[rownames(df4hm.t) %in% pureTGs] <- 'red'
# cols[rownames(df4hm.t) %in% data1TGs] <- 'green'
rows <- rep('black', ncol(df4hm.t))
# rows[colnames(df4hm.t) %in% data1TFs] <- 'green'

#plot (fig.3B)
par(oma=c(1,1,1,1))
hm <- heatmap.2(as.matrix(df4hm.t),
                #xlab="TFs", ylab="Target Genes",
                col=dotcolor, breaks=breakpoint, trace="none", key=TRUE, keysize = 1.1, 
                key.xlab = "appearances", key.ylab = NA, key.title = NA, 
                key.par=list(mar=c(4,0,1,2), cex=1.2, cex.lab=1.2, cex.axis=1.2), margins=c(4,4),
                distfun = function(x) dist(x, method="euclidean"),
                hclustfun = function(x) hclust(x, method="ward.D2"),
                colRow = cols, colCol = rows, cexCol=0.5, cexRow = 0.25) # + 
  # theme(axis.title.x = element_text(size = 40), axis.title.y = element_text(size = 40)) 


#################repeat 14 times below#################
#For highlighting the TFs of each dataset (Optional)
data1TFclass <- scan("data1/data1_TFclass.txt",what = character(), sep = "\t", blank.lines.skip = F)
i <- length(data1TFclass)
odd <- seq(1,i, by = 2)
data1TFs <- data1TFclass[odd]
data1TGs <- t(read.table("data1/data1_TGs.txt"))

cols <- rep('black', nrow(df4hm.t))
cols[rownames(df4hm.t) %in% pureTGs] <- 'red'
cols[rownames(df4hm.t) %in% data1TGs] <- 'green'
rows <- rep('black', ncol(df4hm.t))
rows[colnames(df4hm.t) %in% data1TFs] <- 'green'

par(oma=c(1,1,1,1))
hm <- heatmap.2(as.matrix(df4hm.t),
                #xlab="TFs", ylab="Target Genes",
                col=dotcolor, breaks=breakpoint, trace="none", key=TRUE, keysize = 1.1, 
                key.xlab = "appearances", key.ylab = NA, key.title = NA, 
                key.par=list(mar=c(4,0,1,2), cex=1.2, cex.lab=1.2, cex.axis=1.2), margins=c(4,4),
                distfun = function(x) dist(x, method="euclidean"),
                hclustfun = function(x) hclust(x, method="ward.D2"),
                colRow = cols, colCol = rows, cexCol=0.5, cexRow = 0.25) # + 
  # theme(axis.title.x = element_text(size = 40), axis.title.y = element_text(size = 40)) 

######################################################

#Get the gene symbols of each cluster
TGcluster1 <- labels(hm$rowDendrogram)[1:9]
TGcluster2 <- labels(hm$rowDendrogram)[10:79]
TGcluster3 <- labels(hm$rowDendrogram)[80:123]
TGcluster4 <- labels(hm$rowDendrogram)[124:166]
TGcluster5 <- labels(hm$rowDendrogram)[167:192]
TGcluster6 <- labels(hm$rowDendrogram)[193:220]
TGcluster7 <- labels(hm$rowDendrogram)[221:270]

write(TGcluster1, file="alldata_TGcluster1.txt", sep="\n")
write(TGcluster2, file="alldata_TGcluster2.txt", sep="\n")
write(TGcluster3, file="alldata_TGcluster3.txt", sep="\n")
write(TGcluster4, file="alldata_TGcluster4.txt", sep="\n")
write(TGcluster5, file="alldata_TGcluster5.txt", sep="\n")
write(TGcluster6, file="alldata_TGcluster6.txt", sep="\n")
write(TGcluster7, file="alldata_TGcluster7.txt", sep="\n")


#################repeat 14 times below#################
#Draw dotplot for each data 変更
#Clear the decks
rm(list = ls())
df <- read.table("data1/data1_dotplot_matrix_pro_enh.txt",row.names=1)
TGs <- colnames(df)
TFs <- rownames(df)
pureTGs <- setdiff(TGs, TFs)

n<-ncol(df)
ix <- 1:n
df2 <- lapply(df[ix],as.numeric)
df4hm <- as.data.frame(df2, row.names = rownames(df))
df4hm.t <- as.data.frame(t(df4hm))

#coloring
color <- c("#f0f0f0", "orange", "lightblue")
breakpoint <- c(seq(-0.5,2.5,length=4))
cols <- rep('black', nrow(df4hm.t))
cols[rownames(df4hm.t) %in% pureTGs] <- 'red'

#plot (fig.S2)
par(mar=c(3,3,3,6))
heatmap.2(as.matrix(df4hm.t), xlab="TFs", ylab="Target Genes", Rowv=FALSE, Colv=FALSE, dendrogram = "none",
          main = "data1", lhei = c(1,8), lwid = c(1,3), cexCol=0.7, cexRow = 0.6,
          col=color, breaks=breakpoint, trace="none", key=FALSE, colRow = cols)
par(xpd=T)
legend(par()$usr[1], par()$usr[4], legend=c("none", "Enhancer", "Enhancer/Promoter"), fill=c("#f0f0f0","orange","lightblue"),cex = 0.75)
# dev.off()
######################################################