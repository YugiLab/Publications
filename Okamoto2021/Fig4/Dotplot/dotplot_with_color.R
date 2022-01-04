#read data
data<- read.csv("graph.csv", header = T)

#define x and y
x <- data$X.Term.appeared.in.datasets.
y <- data$X.Hits.by.MeSH.term.

#main function to plot
png(
  "Fig4c_EFO_MeSH.png", 
  height = 8.5, 
  width  = 8.5, 
  units  = "in",
  res    = 300)

plot(x,y, log = "y",
     xlab    = "EFO term appeared in datasets", 
     ylab    = "Hits by MeSH term in PubMed",
     col     = ifelse(x<3, "black", ifelse(y<100, "red", "blue")),
     cex.lab = 1.5,
     xlim    = c(1, 6)
     )

#label each dot
  text(data[1,2],     data[1,3],     labels=data[1,1],     cex= 1, pos=1)
  text(data[3:4,2],   data[3:4,3],   labels=data[3:4,1],   cex= 1, pos=1)
  text(data[5,2],     data[5,3],     labels=data[5,1],     cex= 1, pos=4)
  text(data[6,2],     data[6,3],     labels=data[6,1],     cex= 1, pos=3)
  text(data[7:8,2],   data[7:8,3],   labels=data[7:8,1],   cex= 1, pos=1)
  text(data[10,2],    data[10,3],    labels=data[10,1],    cex= 1, pos=1)
  text(data[11:12,2], data[11:12,3], labels=data[11:12,1], cex= 1, pos=3)
  text(data[13,2],    data[13,3],    labels=data[13,1],    cex= 1, pos=4)
  text(data[14,2],    data[14,3],    labels=data[14,1],    cex= 1, pos=3)
  text(data[15:16,2], data[15:16,3], labels=data[15:16,1], cex= 1, pos=2)
  text(data[17:18,2], data[17:18,3], labels=data[17:18,1], cex= 1, pos=1)
  text(data[19:23,2], data[19:23,3], labels=data[19:23,1], cex= 1, pos=2)
  text(data[24,2],    data[24,3],    labels=data[24,1],    cex= 1, pos=3)

dev.off()
