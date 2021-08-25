#!/bin/bash

# Usage   : $ ./enrich.sh mmu GOIfile POIfile  # GOI : Genes Of Interest ; POI : Pathways of Interest
# Example : $ ./enrich.sh mmu example_gene_of_interest.txt ./Data/mmu_non_disease_pathway_list.txt 

theSpecies=$1 # mmu
theGOIfile=$2 # GOI = Genes Of Interest
thePOIfile=$3 # POI = Pathways Of Interest
theOutputFile=$4

DATA_DIR="./Data"
PROGRAM_DIR="./Program"

#
# File preparation
#

bash ${PROGRAM_DIR}/num_gene_in_pathway.sh ${thePOIfile} ${DATA_DIR}/path.${theSpecies}.xrefs | sort > ${DATA_DIR}/num_${theSpecies}_pathway_gene.txt

#
# Enrichment
#

join -t$'\t' -1 2 -2 1 <(sort -t$'\t' -k2,2 ${DATA_DIR}/path.${theSpecies}.xrefs) <(sort ${theGOIfile}) | awk -F"\t" '{ print $2"\t"$1}' > ${DATA_DIR}/GOI_path.${theSpecies}.txt

bash ${PROGRAM_DIR}/num_GOI_in_pathway.sh ${DATA_DIR}/GOI_path.${theSpecies}.txt | sort > ${DATA_DIR}/num_${theSpecies}_GOI.txt

join -t$'\t' -1 1 -2 1 ${DATA_DIR}/num_${theSpecies}_pathway_gene.txt ${DATA_DIR}/num_${theSpecies}_GOI.txt > ${DATA_DIR}/${theSpecies}_pathway_GOI_freq.txt

python ${PROGRAM_DIR}/enrichment_no_correction.py ${DATA_DIR}/${theSpecies}_pathway_GOI_freq.txt > ${DATA_DIR}/${theSpecies}_pathway_GOI_enrichment.txt

cut -f1,6 ${DATA_DIR}/${theSpecies}_pathway_GOI_enrichment.txt | grep ^path > ${DATA_DIR}/tmp_${theSpecies}_enrichment.txt

python ${PROGRAM_DIR}/bh.py ${DATA_DIR}/tmp_${theSpecies}_enrichment.txt > ${DATA_DIR}/${theSpecies}_enrichment_BH_corrected.txt

join -t$'\t' -1 1 -2 1 <(sort -t$'\t' -k1,1 ${DATA_DIR}/${theSpecies}_pathway_list.txt)  <(sort -t$'\t' -k1,1 ${DATA_DIR}/${theSpecies}_enrichment_BH_corrected.txt) | sort -t$'\t' -k4,4 > ${DATA_DIR}/${theSpecies}_enrichment_BH_corrected_annotated.txt

echo -e "KEGG PATHWAY ID\tKEGG PATHWAY NAME\tP-value\tFDR (BH-corrected)\t#GENES IN PATHWAY\t#GOI IN PATHWAY" > ${DATA_DIR}/${theSpecies}_freq_enrichment_BH_corrected_annotated.txt 

join -t$'\t' -1 1 -2 1 <(sort -t$'\t' -k1,1 ${DATA_DIR}/${theSpecies}_enrichment_BH_corrected_annotated.txt) <(sort -t$'\t' -k1,1 ${DATA_DIR}/${theSpecies}_pathway_GOI_freq.txt) | sort -t$'\t' -gk4,4 >> ${DATA_DIR}/${theSpecies}_freq_enrichment_BH_corrected_annotated.txt 

mv ${DATA_DIR}/${theSpecies}_freq_enrichment_BH_corrected_annotated.txt ${theOutputFile}

rm ${DATA_DIR}/num_${theSpecies}_pathway_gene.txt
rm ${DATA_DIR}/num_${theSpecies}_GOI.txt
rm ${DATA_DIR}/${theSpecies}_pathway_GOI_enrichment.txt
rm ${DATA_DIR}/tmp_${theSpecies}_enrichment.txt
rm ${DATA_DIR}/${theSpecies}_enrichment_BH_corrected.txt
rm ${DATA_DIR}/${theSpecies}_pathway_GOI_freq.txt
rm ${DATA_DIR}/${theSpecies}_enrichment_BH_corrected_annotated.txt

