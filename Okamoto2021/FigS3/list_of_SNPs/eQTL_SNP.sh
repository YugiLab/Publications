#!/bin/bash

DataNo=$1
echo "Public Data${DataNo}"

#Merge the TF lists of Layer 1 and Layer 2.
cat data"${DataNo}"_TFBS_depth1.txt data"${DataNo}"_TFBS_depth2.txt  | sort | uniq > data"${DataNo}"_TFBS.txt

#Derive the eQTL via GeneID.
join -t$'\t' -1 2 -2 1 <(zcat GTEx_Analysis_v8_eQTL/Brain* | awk '{ n=split ($2, aToken, ".") ; OFS = "\t" ; $2 = aToken[1] ; print }' | sort -t$'\t' -k2,2) <(cat data"${DataNo}"_TFBS.txt | cut -d " " -f 2 | sort ) > data"${DataNo}"_eQTL.txt

#VariantIDを介してSNPを導出Derive the SNPs via VariantID.
join -t$'\t' -1 2 -2 1 <(sort -t$'\t' -k2,2 data"${DataNo}"_eQTL.txt ) <(sort -t$'\t' -k1,1 GTEx_Analysis_2017-06-05_v8_WholeGenomeSeq_838Indiv_Analysis_Freeze.lookup_table.txt ) > data"${DataNo}"_SNPs.txt
cut -f 18 data"${DataNo}"_SNPs.txt | sort | uniq > data"${DataNo}"_SNPs_only.txt
