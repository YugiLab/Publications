#!/bin/bash
DataNo=$1
echo "Public Data${DataNo}"

# Layer1
## Save "Genehancer" tab from downloaded data as genehancer_dataFIXME.csv.
## Extract the gene symbols in the 2nd column and the GHIDs in the 3rd column to create a list of gene names and GHIDs.
cat genehancer_data"${DataNo}".csv | awk -F"," 'NR>1{print $2"\t"$3}' > gene_GHID_list.txt
cat genehancer_data"${DataNo}".csv | awk -F"," 'NR>1{if($4 == "Promoter") print $2"\t"$3}' > gene_GHID_promoter_list.txt
cat genehancer_data"${DataNo}".csv | awk -F"," 'NR>1{if($4 == "Enhancer") print $2"\t"$3}' > gene_GHID_enhancer_list.txt
cat genehancer_data"${DataNo}".csv | awk -F"," 'NR>1{if($4 == "Promoter/Enhancer") print $2"\t"$3}' > gene_GHID_promoterenhancer_list.txt

## Extract the GHIDs in the 3rd column and the TFBSs in the 9th column to create a list of GHIDs and TFBSs.
cat genehancer_data"${DataNo}".csv | awk -F"," 'NR>1{print $3"\t"$9}' > GHID_TFBS_list.txt
cat genehancer_data"${DataNo}".csv | awk -F"," 'NR>1{if($4 == "Promoter") print $3"\t"$9}' > GHID_TFBS_promoter_list.txt
cat genehancer_data"${DataNo}".csv | awk -F"," 'NR>1{if($4 == "Enhancer") print $3"\t"$9}' > GHID_TFBS_enhancer_list.txt
cat genehancer_data"${DataNo}".csv | awk -F"," 'NR>1{if($4 == "Promoter/Enhancer") print $3"\t"$9}' > GHID_TFBS_promoterenhancer_list.txt

## Create a list with GHID in the 1st column and the name of TFBS in the 2nd column.
cat GHID_TFBS_list.txt | awk -F '\t|\\|\\|' '{for (i=2; i<=NF; i++){printf "%s,%s\n",$1,$i}}' > data"${DataNo}"_TFBS_list.txt
cat GHID_TFBS_promoter_list.txt | awk -F '\t|\\|\\|' '{for (i=2; i<=NF; i++){printf "%s,%s\n",$1,$i}}' > data"${DataNo}"_TFBS_promoter_list.txt
cat GHID_TFBS_enhancer_list.txt | awk -F '\t|\\|\\|' '{for (i=2; i<=NF; i++){printf "%s,%s\n",$1,$i}}' > data"${DataNo}"_TFBS_enhancer_list.txt
cat GHID_TFBS_promoterenhancer_list.txt | awk -F '\t|\\|\\|' '{for (i=2; i<=NF; i++){printf "%s,%s\n",$1,$i}}' > data"${DataNo}"_TFBS_promoterenhancer_list.txt

## Erase duplicates of the TFBS and create a list.
cat data"${DataNo}"_TFBS_list.txt | awk -F"," '{print $2}' | sort | uniq | sed '/^$/d' > data"${DataNo}"_TFBS_names.txt
cat data"${DataNo}"_TFBS_promoter_list.txt | awk -F"," '{print $2}' | sort | uniq | sed '/^$/d' > data"${DataNo}"_promoter_TFBS_names.txt
cat data"${DataNo}"_TFBS_enhancer_list.txt | awk -F"," '{print $2}' | sort | uniq | sed '/^$/d' > data"${DataNo}"_enhancer_TFBS_names.txt
cat data"${DataNo}"_TFBS_promoterenhancer_list.txt | awk -F"," '{print $2}' | sort | uniq | sed '/^$/d' > data"${DataNo}"_promoterenhancer_TFBS_names.txt

## Create a list of DEGs from the file sorted_public_dataFIXME_genelist.txt in Fig1/Lipid_Metabolism. Extract the gene name in the 3rd column of sorted_public_dataFIXME_genelist.txt, sort it, and save it as dataFIXME_DEGs.txt.
cat sorted_public_data"${DataNo}".txt | awk -F"\t" '{print $1}' | sort | uniq > data"${DataNo}"_DEGs.txt

## By using the list of DEGs, extract the TFBSs in Layer1 that are DEGs.
gjoin data"${DataNo}"_DEGs.txt data"${DataNo}"_TFBS_names.txt > data"${DataNo}"_TFBS_DEGs.txt
gjoin data"${DataNo}"_DEGs.txt data"${DataNo}"_promoter_TFBS_names.txt > data"${DataNo}"_promoter_TFBS_DEGs.txt
gjoin data"${DataNo}"_DEGs.txt data"${DataNo}"_enhancer_TFBS_names.txt > data"${DataNo}"_enhancer_TFBS_DEGs.txt
gjoin data"${DataNo}"_DEGs.txt data"${DataNo}"_promoterenhancer_TFBS_names.txt > data"${DataNo}"_promoterenhancer_TFBS_DEGs.txt


# Layer2
## Save "Genehancer" tab from downloaded data as genehancer_dataFIXME_depth2.csv.
## Extract the gene symbols in the 2nd column and the GHIDs in the 3rd column to create a list of gene names and GHIDs.
cat genehancer_data"${DataNo}"_depth2.csv | awk -F"," 'NR>1{print $2"\t"$3}' > gene_GHID_list2.txt
cat genehancer_data"${DataNo}"_depth2.csv | awk -F"," 'NR>1{if($4 == "Promoter") print $2"\t"$3}' > gene_GHID_promoter_list2.txt
cat genehancer_data"${DataNo}"_depth2.csv | awk -F"," 'NR>1{if($4 == "Enhancer") print $2"\t"$3}' > gene_GHID_enhancer_list2.txt
cat genehancer_data"${DataNo}"_depth2.csv | awk -F"," 'NR>1{if($4 == "Promoter/Enhancer") print $2"\t"$3}' > gene_GHID_promoterenhancer_list2.txt

## Extract the GHIDs in the 3rd column and the TFBSs in the 9th column to create a list of GHIDs and TFBSs.
cat genehancer_data"${DataNo}"_depth2.csv | awk -F"," 'NR>1{print $3"\t"$9}' > GHID_TFBS_list2.txt
cat genehancer_data"${DataNo}"_depth2.csv | awk -F"," 'NR>1{if($4 == "Promoter") print $3"\t"$9}' > GHID_TFBS_promoter_list2.txt
cat genehancer_data"${DataNo}"_depth2.csv | awk -F"," 'NR>1{if($4 == "Enhancer") print $3"\t"$9}' > GHID_TFBS_enhancer_list2.txt
cat genehancer_data"${DataNo}"_depth2.csv | awk -F"," 'NR>1{if($4 == "Promoter/Enhancer") print $3"\t"$9}' > GHID_TFBS_promoterenhancer_list2.txt

## Create a list with GHID in the 1st column and the name of TFBS in the 2nd column.
cat GHID_TFBS_list2.txt | awk -F '\t|\\|\\|' '{for (i=2; i<=NF; i++){printf "%s,%s\n",$1,$i}}' > data"${DataNo}"_TFBS_list2.txt
cat GHID_TFBS_promoter_list2.txt | awk -F '\t|\\|\\|' '{for (i=2; i<=NF; i++){printf "%s,%s\n",$1,$i}}' > data"${DataNo}"_promoter_TFBS_list2.txt
cat GHID_TFBS_enhancer_list2.txt | awk -F '\t|\\|\\|' '{for (i=2; i<=NF; i++){printf "%s,%s\n",$1,$i}}' > data"${DataNo}"_enhancer_TFBS_list2.txt
cat GHID_TFBS_promoterenhancer_list2.txt | awk -F '\t|\\|\\|' '{for (i=2; i<=NF; i++){printf "%s,%s\n",$1,$i}}' > data"${DataNo}"_promoterenhancer_TFBS_list2.txt

## Erase duplicates of the TFBS and create a list.
cat data"${DataNo}"_TFBS_list2.txt | awk -F"," '{print $2}' | sort | uniq | sed '/^$/d' > data"${DataNo}"_TFBS_names2.txt
cat data"${DataNo}"_promoter_TFBS_list2.txt | awk -F"," '{print $2}' | sort | uniq | sed '/^$/d' > data"${DataNo}"_promoter_TFBS_names2.txt
cat data"${DataNo}"_enhancer_TFBS_list2.txt | awk -F"," '{print $2}' | sort | uniq | sed '/^$/d' > data"${DataNo}"_enhancer_TFBS_names2.txt
cat data"${DataNo}"_promoterenhancer_TFBS_list2.txt | awk -F"," '{print $2}' | sort | uniq | sed '/^$/d' > data"${DataNo}"_promoterenhancer_TFBS_names2.txt

## By using the list of DEGs, extract the TFBSs in Layer2 that are DEGs.
gjoin data"${DataNo}"_DEGs.txt data"${DataNo}"_TFBS_names2.txt > data"${DataNo}"_TFBS_DEGs2.txt
gjoin data"${DataNo}"_DEGs.txt data"${DataNo}"_promoter_TFBS_names2.txt > data"${DataNo}"_promoter_TFBS_DEGs2.txt
gjoin data"${DataNo}"_DEGs.txt data"${DataNo}"_enhancer_TFBS_names2.txt > data"${DataNo}"_enhancer_TFBS_DEGs2.txt
gjoin data"${DataNo}"_DEGs.txt data"${DataNo}"_promoterenhancer_TFBS_names2.txt > data"${DataNo}"_promoterenhancer_TFBS_DEGs2.txt


# Layer3
## Save "Genehancer" tab from downloaded data as genehancer_dataFIXME_depth3.csv.
## Extract the gene symbols in the 2nd column and the GHIDs in the 3rd column to create a list of gene names and GHIDs.
cat genehancer_data"${DataNo}"_depth3.csv | awk -F"," 'NR>1{print $2"\t"$3}' > gene_GHID_list3.txt
## Extract the GHIDs in the 3rd column and the TFBSs in the 9th column to create a list of GHIDs and TFBSs.
cat genehancer_data"${DataNo}"_depth3.csv | awk -F"," 'NR>1{print $3"\t"$9}' > GHID_TFBS_list3.txt
## Create a list with GHID in the 1st column and the name of TFBS in the 2nd column.
cat GHID_TFBS_list3.txt | awk -F '\t|\\|\\|' '{for (i=2; i<=NF; i++){printf "%s,%s\n",$1,$i}}' > data"${DataNo}"_TFBS_list3.txt
## Erase duplicates of the TFBS and create a list.
cat data"${DataNo}"_TFBS_list3.txt | awk -F"," '{print $2}' | sort | uniq | sed '/^$/d' > data"${DataNo}"_TFBS_names3.txt
## By using the list of DEGs, extract the TFBSs in Layer3 that are DEGs.
gjoin data"${DataNo}"_DEGs.txt data"${DataNo}"_TFBS_names3.txt > data"${DataNo}"_TFBS_DEGs3.txt


# Layer4
## Save "Genehancer" tab from downloaded data as genehancer_dataFIXME_depth4.csv.
## Extract the gene symbols in the 2nd column and the GHIDs in the 3rd column to create a list of gene names and GHIDs.
cat genehancer_data"${DataNo}"_depth4.csv | awk -F"," 'NR>1{print $2"\t"$3}' > gene_GHID_list4.txt
## Extract the GHIDs in the 3rd column and the TFBSs in the 9th column to create a list of GHIDs and TFBSs.
cat genehancer_data"${DataNo}"_depth4.csv | awk -F"," 'NR>1{print $3"\t"$9}' > GHID_TFBS_list4.txt
## Create a list with GHID in the 1st column and the name of TFBS in the 2nd column.
cat GHID_TFBS_list4.txt | awk -F '\t|\\|\\|' '{for (i=2; i<=NF; i++){printf "%s,%s\n",$1,$i}}' > data"${DataNo}"_TFBS_list4.txt
## Erase duplicates of the TFBS and create a list.
cat data"${DataNo}"_TFBS_list4.txt | awk -F"," '{print $2}' | sort | uniq | sed '/^$/d' > data"${DataNo}"_TFBS_names4.txt
## By using the list of DEGs, extract the TFBSs in Layer4 that are DEGs.
gjoin data"${DataNo}"_DEGs.txt data"${DataNo}"_TFBS_names4.txt > data"${DataNo}"_TFBS_DEGs4.txt


# Layer5
## Save "Genehancer" tab from downloaded data as genehancer_dataFIXME_depth5.csv.
## Extract the gene symbols in the 2nd column and the GHIDs in the 3rd column to create a list of gene names and GHIDs.
cat genehancer_data"${DataNo}"_depth5.csv | awk -F"," 'NR>1{print $2"\t"$3}' > gene_GHID_list5.txt
## Extract the GHIDs in the 3rd column and the TFBSs in the 9th column to create a list of GHIDs and TFBSs.
cat genehancer_data"${DataNo}"_depth5.csv | awk -F"," 'NR>1{print $3"\t"$9}' > GHID_TFBS_list5.txt
## Create a list with GHID in the 1st column and the name of TFBS in the 2nd column.
cat GHID_TFBS_list5.txt | awk -F '\t|\\|\\|' '{for (i=2; i<=NF; i++){printf "%s,%s\n",$1,$i}}' > data"${DataNo}"_TFBS_list5.txt
## Erase duplicates of the TFBS and create a list.
cat data"${DataNo}"_TFBS_list5.txt | awk -F"," '{print $2}' | sort | uniq | sed '/^$/d' > data"${DataNo}"_TFBS_names5.txt
## By using the list of DEGs, extract the TFBSs in Layer5 that are DEGs.
gjoin data"${DataNo}"_DEGs.txt data"${DataNo}"_TFBS_names5.txt > data"${DataNo}"_TFBS_DEGs5.txt


# Convert TFBS of Layer1 to Ensembl ID
gjoin -a 1 -o 1.1,2.1  -e "---" -1 1 -2 2 <(sort data"${DataNo}"_TFBS_DEGs.txt) <(sort -k 2 -i ensembl_taiouhyou.txt) | sort | uniq > data"${DataNo}"_TFBS_depth1.txt

# Convert TFBS of Layer2 to Ensembl ID
gjoin -a 1 -o 1.1,2.1  -e "---" -1 1 -2 2 <(sort data"${DataNo}"_TFBS_DEGs2.txt) <(sort -k 2 -i ensembl_taiouhyou.txt) | sort | uniq > data"${DataNo}"_TFBS_depth2.txt
