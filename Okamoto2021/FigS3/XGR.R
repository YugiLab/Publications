source("http://bioconductor.org/biocLite.R")
biocLite("XGR")

# Loading the library.

library( XGR )
RData.location <- "http://galahad.well.ox.ac.uk/bigdata_dev/"


# Read the list of SNPs.

rs_file <- "data1_SNPs_only.txt"
rs <- scan( rs_file , what=character(), sep = "\n", blank.lines.skip = T)

#
# Enrichment analysis.
#

rs_enrich <- xEnricherSNPs( data=rs, ontology="EF", size.range = c(3, 2000), min.overlap = 2, test = "hypergeo", path.mode="all_paths", RData.location=RData.location)


# Create a bar chart of the FDR.

rs_barplot <- xEnrichBarplot( rs_enrich, top_num="auto", displayBy="adjp" )

rs_fdr <- "fdr_rs.pdf"
pdf( rs_fdr, width = 12 )
print( rs_barplot )
dev.off()


# Visualize the vertical relationship of EFO terms in a Directed acyclic graph (DAG).

rs_dag <- xEnrichDAGplot( rs_enrich, top_num="auto", displayBy="adjp", node.info=c("full_term_name"), graph.node.attrs=list(fontsize=45) )

rs_dag_file <- "dag_rs.pdf"
pdf( rs_dag_file )
plot( rs_dag )
dev.off()


# Save the results of the Enrichment analysis.

rs_res <- xEnrichViewer( rs_enrich, top_num=length(rs_enrich$adjp), sortBy="adjp", details=TRUE )

rs_ef <- "EF_enrichments_rs.txt"
rs_output <- data.frame(term=rownames(rs_res), rs_res)
utils::write.table(rs_output, file=rs_ef, sep="\t", row.names=FALSE)
