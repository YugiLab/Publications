# Genome-wide transcriptome analysis of human iPSC-derived cortical interneurons under inflammation conditions (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE152438)

# Extract the 2nd column (Ensembl ID) and the 35th column (FoldChange) of GSE152438_TPM32_DEG.csv, sort them, and save them as sorted_public_data3.txt.
cat GSE152438_TPM32_ND_DEG.csv | awk -F"," 'NR>1{print $2"\t"$35}' | sed 's/"//g' | sort | uniq > sorted_public_data10.txt

# Transform Ensembl ID into gene name.
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
cat sorted_public_data10.txt | sort -k 1 | uniq > sorted_public_data10_2.txt
gjoin -a 1 -o 1.1,1.2,2.2 -e "---" -1 1 -2 1 sorted_public_data10_2.txt sorted_ensembl.txt | sed '/---/d' > sorted_public_data10_genelist.txt

# Perform a left join on the 3rd column of sorted_public_data10_genelist.txt and the 2nd column of sorted_KEGG_ID_list.txt. Put '---' if there is no corresponding KEGG ID.
gjoin -i -a 1 -o 1.3,1.2,2.1 -e "---" -1 3 -2 2 <(sort -b -f -k 3 sorted_public_data10_genelist.txt) sorted_KEGG_ID_list.txt > data10_KEGG_ID_all.txt
wc data10_KEGG_ID_all.txt
## 2217    6651   73906 data10_KEGG_ID_all.txt

# List the genes in sorted_public_data10.txt that possess corresponding KEGG ID.
gjoin -i -o 1.3,1.2,2.1 -1 3 -2 2 <(sort -b -f -k 3 sorted_public_data10_genelist.txt) sorted_KEGG_ID_list.txt > data10_KEGG_ID.txt
wc data10_KEGG_ID.txt
## 2148    6444   71771 data10_KEGG_ID.txt

# List the genes in sorted_public_data10.txt that do not possess corresponding KEGG ID.
gjoin -i -1 3 -2 2 -a 1 -v 1 <(sort -b -f -k 3 sorted_public_data10_genelist.txt) sorted_KEGG_ID_list.txt > data10_NO_KEGG_ID.txt
wc data10_NO_KEGG_ID.txt
## 69     207    2963 data10_NO_KEGG_ID.txt

# Join the 3rd column of data10_KEGG_ID.txt and the 2nd column of sorted_lipid_enzyme_list.txt to identify the genes that belong to the lipid metabolism pathway of KEGG database.
cat data10_KEGG_ID.txt | awk -F" " '{print $1"\t"$3}' | sort -t : -k 2 > sorted_data10_KEGG_ID.txt
gjoin -1 2 -2 2 sorted_data10_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data10_lipid_genes.txt

# Put the number of genes that belong to the lipid metabolism pathway.
cat data10_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 34      34     209
