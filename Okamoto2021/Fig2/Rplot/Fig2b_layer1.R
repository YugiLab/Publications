library(ggplot2)
library(ggsci)

#levels(x$sample)

x <- data.frame(
    data   = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"),
    sample = c("Promoter","Promoter","Promoter","Promoter","Promoter","Promoter","Promoter","Promoter","Promoter","Promoter","Promoter","Promoter","Promoter","Promoter","Promoter","Enhancer","Enhancer","Enhancer","Enhancer","Enhancer","Enhancer","Enhancer","Enhancer","Enhancer","Enhancer","Enhancer","Enhancer","Enhancer","Enhancer","Enhancer","Promoter.Enhancer","Promoter.Enhancer","Promoter.Enhancer","Promoter.Enhancer","Promoter.Enhancer","Promoter.Enhancer","Promoter.Enhancer","Promoter.Enhancer","Promoter.Enhancer","Promoter.Enhancer","Promoter.Enhancer","Promoter.Enhancer","Promoter.Enhancer","Promoter.Enhancer","Promoter.Enhancer" ),
    number = c(0,7,10,0,0,0,0,0,11,13,1,3,0,17,1,8,41,95,24,26,12,15,20,49,75,37,19,0,56,24,8,42,96,25,26,12,16,21,52,74,35,19,0,56,28)
    )
    x$sample <- factor(x$sample, levels = unique(x$sample))

g <- ggplot(x, aes(x = data, y = number, fill = sample)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_x_discrete(limit=c('15','14','13','12','11','10','9','8','7','6','5','4','3','2','1')) +
    coord_flip() +
    labs(title = "Layer 1", x = "Public Data", y = "TFBSs", fill = "") +
    guides(fill = guide_legend(reverse = TRUE)) +
    scale_fill_manual(labels = c("Promoter", "Enhancer","Promoter/Enhancer"), values = c("#F8766D","#619CFF", "#00BA38")) +
    theme_classic() +
    theme(legend.position = "none")

g2 <- g +
      theme(plot.title = element_text(size = 28, hjust = 0.5), axis.title=element_text(size= 30), text = element_text(size = 24))
plot(g2)
