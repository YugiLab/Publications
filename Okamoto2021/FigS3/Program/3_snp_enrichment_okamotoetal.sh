# For macOS, enable these aliases.
# shopt -s expand_aliases
# alias sort='gsort'
# alias sed='gsed'
# alias join='gjoin'
# alias awk='gawk'

Data_Dir=../Data
GTEx_Network_File=${Data_Dir}/Brain.GTEx.network

##
## Enrichment using XGR 
##
awk -F"\t" '{ if( $20!="" ){ print $2"\t"$4"\t"$5"\t"$20 } }' ${GTEx_Network_File}.txt | sort -u > ${Data_Dir}/rs_annotated.txt
awk -F"\t" '{  print $4  }' ${Data_Dir}/rs_annotated.txt | sort -u > ${Data_Dir}/rs_ids.txt
Rscript xgr_snp_enrich_okamotoetal.R ${Data_Dir}

########
# Enriched traits and their genes
########
bash enriched_traits.sh ${Data_Dir}/EF_enrichments.txt ${GTEx_Network_File}.txt > ${Data_Dir}/gtex_enriched_efo.txt

rm Rplots*.pdf

