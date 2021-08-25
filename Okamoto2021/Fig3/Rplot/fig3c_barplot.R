#Ready for the packages
install.packages("tidyverse")
install.packages("ggplot2", dependencies=TRUE)
install.packages("plyr")
library(tidyverse)
library(ggplot2)
library(plyr)
library(ggsci)
library(RColorBrewer)

#Clear the decks
rm(list = ls())

#Read data
data = read.csv("fig3c.csv", header = T)
df <- data.frame(data)
tdf <- df %>% gather("cluster.a","cluster.b","cluster.c","cluster.d","cluster.e","cluster.f", key = "cluster", value = "counts")
class <- tdf[,1]
cluster <- tdf[,2]
frequency <- tdf[,3]
cluster_label <- sub("cluster.", "cluster ", cluster)

# Define the number of colors you want
nb.cols <- 27
mycolors <- colorRampPalette(brewer.pal(6, "Set1"))(nb.cols)

#plot data
g <- ggplot(data = tdf, aes(x = cluster_label, y = frequency, fill = class), color = class)
g <- g + theme_classic(base_size = 11, base_family = "")
g <- g + geom_bar(stat = "identity")
g <- g + scale_fill_manual(values = mycolors)
g <- g + xlab(NULL)
g <- g + theme(legend.key.size = unit(1.3, 'cm'), legend.position = "bottom", 
               text = element_text(color = "black", size = 40), 
               axis.text = element_text(color = "black", size = 30),
               legend.title=element_blank(),
               legend.text = element_text(color = "black", size = 25))
g <- g + guides(fill=guide_legend(ncol=2, reverse=FALSE))
plot(g)
