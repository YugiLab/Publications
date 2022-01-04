# Setup
#
#source("http://bioconductor.org/biocLite.R")
#biocLite("XGR")

args <- commandArgs(trailingOnly = TRUE)
default_args <- c("../Data")
default_flag <- is.na(args[1])
args[default_flag] <- default_args[default_flag]

library(XGR)
RData.location <- "http://galahad.well.ox.ac.uk/bigdata"

rs_file <- paste(args[1], "/rs_ids.txt", sep = "")

rs_ids <- scan(rs_file,
               what = character(),
               sep = "\n",
               blank.lines.skip = TRUE)

enrich <- xEnricherSNPs( data = rs_ids, 
                         ontology = "EF", 
                         size.range = c(3, 2000), 
                         min.overlap = 2, 
                         test = "hypergeo", 
                         path.mode = "all_paths", 
                         RData.location = RData.location)

# d) save enrichment results to the file called 'EF_enrichments.txt'
res <- xEnrichViewer(enrich, 
                     top_num = length(enrich$adjp), 
                     sortBy = "adjp",
                     details = TRUE)

output <- data.frame(term = rownames(res), res)

ef <- paste(args[1], "/EF_enrichments.txt", sep = "")

write.table(output, file = ef, sep = "\t", row.names = FALSE)

# e) barplot of significant enrichment results
barplot <- xEnrichBarplot(enrich, top_num = "auto", displayBy = "adjp")

fdr <- paste(args[1], "/fdr.pdf", sep = "")

pdf(fdr, width = 12)
print(barplot)
dev.off()

dag_file <- paste(args[1], "/dag.pdf", sep = "")

dag <- xEnrichDAGplot(enrich,
                      top_num = "auto",
                      displayBy = "adjp", 
                      node.info = c("full_term_name"),
                      graph.node.attrs = list(fontsize = 45))

pdf(dag_file)
plot(dag)
dev.off()