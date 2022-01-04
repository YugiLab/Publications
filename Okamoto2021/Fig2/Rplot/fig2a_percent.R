library(ggplot2)
library(ggsci)

#levels(x$sample)

x <- data.frame(
    data   = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"),
    sample = c("a"),
    number = c(2.15,2.74,1.65,0.96,0.40,1.45,1.53,0.00,1.09,0.62,1.72,2.30,0.00,1.68,0.00)
    )
    x$sample <- factor(x$sample, levels = unique(x$sample))

g <- ggplot(x, aes(x = data, y = number, fill = sample)) +
    geom_bar(stat = "identity", position = "dodge") +
    geom_hline(yintercept=1.22) +
    scale_x_discrete(limit=c('15','14','13','12','11','10','9','8','7','6','5','4','3','2','1')) +
    coord_flip() +
    labs(title = "", x = "Public Datasets", y = "Lipid Metabolism Genes (%)", fill = "") +
    guides(fill = guide_legend(reverse = TRUE)) +
    scale_fill_manual(labels = c("Promoter", "Enhancer","Promoter/Enhancer"), values = c("dimgrey","dimgrey", "dimgrey")) +
    theme_classic() +
    theme(legend.position = "none")

g2 <- g +
      theme(plot.title = element_text(size = 16, hjust = 0.5), axis.title=element_text(size= 30), text = element_text(size = 24))
plot(g2)
