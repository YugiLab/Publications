#read data
data<- read.csv("graph.csv", header = T)

#define x and y
x <- data$X.Term.appeared.in.datasets.
y <- data$X.Hits.by.MeSH.term.

#attach package
library(ggplot2)

#main function to plot
the_plot <- function()
{
  plot(x,y, log = "y",
     xlab = "EFO term appeared in datasets", 
     ylab = "Hits by MeSH term in PubMed",
     col=ifelse(x<4, "black", ifelse(y<100, "red", "blue")),
     cex.lab=1.5,
     xlim = c(1, 6)
     )
  #label each dot
  text(data[1:2,2], data[1:2,3], labels=data[1:2,1], cex= 1, pos=2)
  text(data[3,2], data[3,3], labels=data[3,1], cex= 1, pos=3)
  text(data[4:7,2], data[4:7,3], labels=data[4:7,1], cex= 1, pos=2)
  text(data[8,2], data[8,3], labels=data[8,1], cex= 1, pos=3)
  text(data[9:10,2], data[9:10,3], labels=data[9:10,1], cex= 1, pos=2)
  text(data[11,2], data[11,3], labels=data[11,1], cex= 1, pos=4)
}
#increase resolution
ggsave(
  "Fig4c_EFO_MeSH.png",
  the_plot(),
  width = 7,
  height = 7,
  dpi = 300
)