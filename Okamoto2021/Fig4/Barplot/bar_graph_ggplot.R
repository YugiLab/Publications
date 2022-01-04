library(ggplot2)
library(ggsci)

#levels(x$sample)

x <- data.frame(
    data   = c("1", "1", "2", "2", "3", "3", "4", "4", "5", "5", "6", "6", "7", "7","8","8", "9", "9", "10", "10", "11", "11", "12", "12", "13", "13","14","14","15","15"),
    sample = c("2DEG", "1SNP","2DEG", "1SNP","2DEG", "1SNP","2DEG", "1SNP","2DEG", "1SNP","2DEG", "1SNP","2DEG", "1SNP","2DEG", "1SNP","2DEG", "1SNP","2DEG", "1SNP","2DEG", "1SNP","2DEG", "1SNP","2DEG", "1SNP","2DEG", "1SNP","2DEG", "1SNP"),
    number = c(1165, 3163, 1349, 1049, 486, 577, 313, 1391, 253, 263, 759, 4425, 848, 123, 107, 0, 551, 819, 485, 1622, 1337, 2841, 739, 1065, 53, 0, 595, 832, 22, 0)
    )
    #x$sample <- factor(x$sample, levels = unique(x$sample))

g <- ggplot(x, aes(x = data, y = number, fill = sample)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_x_discrete(limit=c('15','14','13','12','11','10','9','8','7','6','5','4','3','2','1')) +
    coord_flip() +
    labs(title = "", x = "Public Data", y = "Number", fill = "") +
    guides(fill = guide_legend(reverse = TRUE)) +
    scale_fill_manual(labels = c("SNP", "DEG"), values = c("#F8766D","#00BFC4")) +
    theme_classic()

g2 <- g +
      theme(axis.title=element_text(size= 30), text = element_text(size = 24))
plot(g2)
