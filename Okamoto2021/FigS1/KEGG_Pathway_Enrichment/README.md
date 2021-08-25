# KEGG_Pathway_Enrichment
A simple pathway enrichment analysis programs using bash and python

Put list of DEGs in the place of example_gene_of_interest.txt 

# Possible usage

$ bash preproc.sh hsa

(1) All the KEGG PATHWAY maps

$ bash enrich.sh hsa example_gene_of_interest.txt ./Data/hsa_pathway_list.txt ./Data/enrich_kegg.txt

or

(2) All the KEGG PATHWAY maps other than disease maps (05XXX and 049{30, 31, 40})

$ bash enrich.sh hsa example_gene_of_interest.txt  ./Data/hsa_non_disease_pathway_list.txt enrich_non_disease.txt

or

(3) Pathways named 'signaling pathway' among the pathways of (2)

$ bash enrich.sh hsa example_gene_of_interest.txt ./Data/hsa_signaling_pathway_list.txt enrich_signalint.txt

or

(4) = (2) - (3)

$ bash enrich.sh hsa example_gene_of_interest.txt ./Data/hsa_cellular_function_pathway_list.txt enrich_cellular_function.txt

$ bash color_map.sh ./Data/GOI_path.hsa.txt ./Data/enrich_kegg.txt
