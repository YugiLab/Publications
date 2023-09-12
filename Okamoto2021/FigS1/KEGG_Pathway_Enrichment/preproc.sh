#!/bin/bash

##
## Usage : $ ./preproc.sh mmu 
##

theSpecies=$1

DATA_DIR=./Data

curl "https://rest.kegg.jp/link/${theSpecies}/pathway" > ${DATA_DIR}/path.${theSpecies}.xrefs

curl "https://rest.kegg.jp/list/pathway/${theSpecies}" | awk -F" - " '{ print $1 }' | awk -F"\t" '{ print "path:"$1"\t"$2 }' > ${DATA_DIR}/${theSpecies}_pathway_list.txt

curl "https://rest.kegg.jp/list/${theSpecies}" > ${DATA_DIR}/${theSpecies}_gene_list.txt

grep -v "^path:${theSpecies}05\|${theSpecies}04930\|${theSpecies}04931\|${theSpecies}04940" ${DATA_DIR}/${theSpecies}_pathway_list.txt > ${DATA_DIR}/${theSpecies}_non_disease_pathway_list.txt

grep "signaling pathway" ${DATA_DIR}/${theSpecies}_non_disease_pathway_list.txt > ${DATA_DIR}/${theSpecies}_signaling_pathway_list.txt

grep -v "signaling pathway" ${DATA_DIR}/${theSpecies}_non_disease_pathway_list.txt > ${DATA_DIR}/${theSpecies}_cellular_function_pathway_list.txt

