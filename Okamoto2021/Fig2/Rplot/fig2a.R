library(ggplot2)
library(ggsci)

#levels(x$sample)

x <- data.frame(
    data   = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"),
    sample = c("a"),
    number = c(25,37,8,3,1,11,13,0,6,3,23,17,0,10,0)
    )
    x$sample <- factor(x$sample, levels = unique(x$sample))

g <- ggplot(x, aes(x = data, y = number, fill = sample)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_x_discrete(limit=c('15','14','13','12','11','10','9','8','7','6','5','4','3','2','1')) +
    coord_flip() +
    labs(title = "", x = "Public Datasets", y = "Lipid Metabolism Genes", fill = "") +
    guides(fill = guide_legend(reverse = TRUE)) +
    scale_fill_manual(labels = c("Promoter", "Enhancer","Promoter/Enhancer"), values = c("dimgrey","dimgrey", "dimgrey")) +
    theme_classic() +
    theme(legend.position = "none")

g2 <- g +
      theme(plot.title = element_text(size = 16, hjust = 0.5), axis.title=element_text(size= 30), text = element_text(size = 24))
plot(g2)
