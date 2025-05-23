rm(list = ls())

library(ggplot2)
library(reshape2)
library(ggrepel)

a <- read.table("fig3a_data.txt", header=T, sep="\t")
colnames(a) <- c("PublicData","1","2","3","4","5")
data <- melt(a, id = "PublicData", measure = c("1", "2", "3", "4", "5"))
colnames(data) <- c("PublicData","Layer","TFBSs")
g <-
  ggplot(data, aes(x = Layer, y = TFBSs, group = PublicData, colour = PublicData) )+
  geom_line() +
  theme(axis.title=element_text(size= 19)) +
  coord_cartesian(xlim = c(1,5.3)) +
  geom_text(check_overlap = T,
            data = subset(data, Layer == 5),
            aes(label = PublicData),
            nudge_x = 0.15, size = 6,
            ) +
  theme(legend.position = "none") +
  labs(title = "", x = "Layers", y = "Number of TFBSs")

g2 <- g + theme_classic() +
      theme(axis.title=element_text(size= 30), text = element_text(size = 26)) +
      geom_vline(xintercept=2, linetype = "dotted") +
      theme(legend.position = "none")

plot(g2)
