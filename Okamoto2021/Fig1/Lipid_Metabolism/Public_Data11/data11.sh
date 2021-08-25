# Genome-wide transcriptome analysis of human iPSC-derived healty control and schizophrenia cortical interneurons under inflammation conditions. (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE132689)

# Extract the 2nd column (Ensembl ID) of GSE152438_TPM32_Nor_DEG.csv, sort it, and save it as sorted_public_data11.txt.
cat GSE152438_TPM32_Nor_DEG.csv | awk -F"," 'NR>1{print $2}' | sed 's/"//g' | sort | uniq > sorted_public_data11.txt

# Transform Ensembl ID into gene name.
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
cat sorted_public_data11.txt | sort -k 1 | uniq > sorted_public_data11_2.txt
gjoin -a 1 -o 1.1,2.2 -e "---" -1 1 -2 1 sorted_public_data11_2.txt sorted_ensembl.txt | sed '/---/d' | awk -F" " '{print $2}' | sort | uniq > sorted_public_data11_genelist.txt


# Perform a left join on the 1st column of sorted_public_data11_genelist.txt and the 2nd column of sorted_KEGG_ID_list.txt. Put '---' if there is no corresponding KEGG ID.
gjoin -i -a 1 -o 1.1,2.1,1.2 -e "---" -1 1 -2 2 <(sort -b -f -k 1 sorted_public_data11_genelist.txt) sorted_KEGG_ID_list.txt > data11_KEGG_ID_all.txt
wc data11_KEGG_ID_all.txt
## 1262    3786   42455 data11_KEGG_ID_all.txt

# List the genes in sorted_public_data11_genelist.txt that possess corresponding KEGG ID.
gjoin -i -o 1.1,2.1,1.2 -1 1 -2 2 <(sort -b -f -k 1 sorted_public_data11_genelist.txt) sorted_KEGG_ID_list.txt > data11_KEGG_ID.txt
wc data11_KEGG_ID.txt
## 1141    3423   38500 data11_KEGG_ID.txt

# List the genes in sorted_public_data11_genelist.txt that do not possess corresponding KEGG ID.
gjoin -i -1 1 -2 2 -a 1 -v 1 <(sort -b -f -k 1 sorted_public_data11_genelist.txt) sorted_KEGG_ID_list.txt > data11_NO_KEGG_ID.txt
wc data11_NO_KEGG_ID.txt
## 121     242    3471 data11_NO_KEGG_ID.txt

# Join the 2nd column of data11_KEGG_ID.txt and the 2nd column of sorted_lipid_enzyme_list.txt to identify the genes that belong to the lipid metabolism pathway of KEGG database.
cat data11_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data11_KEGG_ID.txt
gjoin -1 2 -2 2 sorted_data11_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data11_lipid_genes.txt

# Put the number of genes that belong to the lipid metabolism pathway.
cat data11_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 24      24     149
