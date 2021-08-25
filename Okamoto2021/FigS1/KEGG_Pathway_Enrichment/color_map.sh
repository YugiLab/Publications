#!/bin/bash

##
## Usage : $ bash color_map.sh ./Data/GOI_path.mmu.txt ./Data/enrich_kegg.txt
##

theGOIpathFile=$1 # ./Data/GOI_path.mmu.txt
theFDRfile=$2 # ./Data/enrich_kegg.txt

MAP_DIR=./Data/Maps
FDR_CUTOFF=0.1

for aPathway in $(tail -n +2 ${theFDRfile} | awk -F"\t" -v CutOff=${FDR_CUTOFF} '($4<=CutOff){ print $1 }') ; do
    aMap=$(echo "${aPathway}" | awk -F":" '{ printf $2 }')
    aGene=""
    while read aLine ; do
	if [[ ${aPathway} = $(echo "${aLine}" | cut -f1) ]] ; then
	    aGene="${aGene}/$(echo "${aLine}" | awk -F"\t" '{ printf $2 }')%09,red" 
	fi 
    done < "${theGOIpathFile}"
    #echo -e "https://www.kegg.jp/kegg-bin/show_pathway?${aMap}${aGene}"

    anURL=$(curl "https://www.kegg.jp/kegg-bin/show_pathway?${aMap}${aGene}" | grep "/tmp/mark_pathway" | cut -d'"' -f2) 
    
    aPNGfileName=$(echo ${anURL} | cut -d'/' -f4)
    curl "https://www.kegg.jp/${anURL}" --output "${MAP_DIR}/${aPNGfileName}"
done
