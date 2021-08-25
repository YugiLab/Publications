setwd("C:/Users/soyo6/Transomics/XGR/Okamoto")
library(ggplot2)
library(ggsci)

#levels(x$sample)

x <- data.frame(
    data   = c("1", "1", "2", "2", "3", "3", "4", "4", "5", "5", "6", "6", "7", "7", "8", "8", "9", "9", "10", "10", "11", "11", "12", "12", "13", "13", "14", "14", "15", "15"),
    sample = c("2DEG", "1SNP", "2DEG", "1SNP", "2DEG", "1SNP", "2DEG", "1SNP", "2DEG", "1SNP", "2DEG", "1SNP", "2DEG", "1SNP", "2DEG", "1SNP", "2DEG", "1SNP", "2DEG", "1SNP", "2DEG", "1SNP", "2DEG", "1SNP", "2DEG", "1SNP", "2DEG", "1SNP", "2DEG", "1SNP"),
    number = c(1195, 997, 1349, 1049, 4626, 7068, 381, 1121, 1075, 3118, 391, 1422, 639, 709, 558, 5509, 2519, 6823, 468, 310, 946, 3142, 739, 1065, 53, 0, 1945, 4413, 783, 3323)
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
