# Pilot transcriptome analysis of human iPSC-derived healthy control vs. schizophrenia cortical interneurons (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE125805)

# Extract the 2nd column (Ensembl ID) and the 63rd column (FoldChange) of GSE125805_TPM_9pairs_DEG.csv, sort them, and save them as sorted_public_data3.txt.
cat GSE125805_TPM_9pairs_DEG.csv | awk -F"," 'NR>1{print $2"\t"$21}' | sed 's/"//g' | sort -b -f | uniq > sorted_public_data4.txt

# Transform Ensembl ID into gene name.
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
cat sorted_public_data4.txt | sort -k 1 | uniq > sorted_public_data4_2.txt
gjoin -a 1 -o 1.1,1.2,2.2 -e "---" -1 1 -2 1 sorted_public_data4_2.txt sorted_ensembl.txt | sed '/---/d' > sorted_public_data4_genelist.txt

# Perform a left join on the 3rd column of sorted_public_data4_genelist.txt and the 2nd column of sorted_KEGG_ID_list.txt. Put '---' if there is no corresponding KEGG ID.
gjoin -i -a 1 -o 1.3,1.2,2.1 -e "---" -1 3 -2 2 <(sort -k 3 sorted_public_data4_genelist.txt) sorted_KEGG_ID_list.txt > data4_KEGG_ID_all.txt

wc data4_KEGG_ID_all.txt
## 406    1218   13405 data4_KEGG_ID_all.txt

# List the genes in sorted_public_data4.txt that possess corresponding KEGG ID.
gjoin -i -o 1.3,1.2,2.1 -1 3 -2 2 <(sort -k 3 sorted_public_data4_genelist.txt) sorted_KEGG_ID_list.txt > data4_KEGG_ID.txt

wc data4_KEGG_ID.txt
## 370    1110   12300 data4_KEGG_ID.txt

# List the genes in sorted_public_data4.txt that do not possess corresponding KEGG ID.
gjoin -i -1 3 -2 2 -a 1 -v 1 <(sort -k 3 sorted_public_data4_genelist.txt) sorted_KEGG_ID_list.txt > data4_NO_KEGG_ID.txt

wc data4_NO_KEGG_ID.txt
## 36     108    1537 data4_NO_KEGG_ID.txt

# Join the 3rd column of data4_KEGG_ID.txt and the 2nd column of lipid_enzyme_list.txt to identify the genes that belong to the lipid metabolism pathway of KEGG database.
cat data4_KEGG_ID.txt | awk -F" " '{print $1"\t"$3}' | sort -t : -k 2 > sorted_data4_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data4_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data4_lipid_genes.txt

# Put the number of genes that belong to the lipid metabolism pathway.
cat data4_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 10      10      60
