library(ggplot2)
library(dplyr)

a <- read.table("data1_enrich_non_disease.txt", skip=1, sep="\t")
colnames(a) <- c("KeggPathwayID","KeggPathwayName","Pvalue","FDR","GenesInPathway","GOI")
a2 <- a[a$Pvalue<0.05, ]
a3 <- a2[ order( a2$Pvalue ), ]
a4 <- head(a3, n=20)

g <-
  ggplot(a4, aes(x = reorder(KeggPathwayName, -log10(Pvalue)), y = -log10(Pvalue))) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "data1", x = "Pathway Name", y = "-log10(Pvalue)") +
  geom_text(aes(label = round(-log10(Pvalue), digits = 2)), size = 4, hjust = 1, vjust = 1, color = "snow3")

g2 <- g + theme_classic() +
      theme(plot.title = element_text(size = 15, face = 2, hjust = 0.5), axis.title=element_text(size= 15), text = element_text(size = 13))

ggsave(file = "data1_pathwayenrichment.png", plot = g)

rm(list=ls())
