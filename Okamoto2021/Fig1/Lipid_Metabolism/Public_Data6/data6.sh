# RNA-seq in neurons derived from iPSCs in controls and patients with schizophrenia and 22q11 del (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE46562)

# Extract the 2nd column (Ensembl ID) and the 22nd column (FoldChange) of GSE46562_FPKM_expression_table_DEG.csv, sort them, and save them as sorted_public_data6.txt.
cat GSE46562_FPKM_expression_table_DEG.csv | awk -F"," 'NR>1{print $2"|"$22}' | sed 's/"//g' | awk -F"|" '{print $3"\t"$4}' | sort -b -f | uniq > sorted_public_data6.txt

# Perform a left join on the 1st column of sorted_public_data6.txt and the 2nd column of sorted_KEGG_ID_list.txt. Put '---' if there is no corresponding KEGG ID.
gjoin -t$'\t' -i -a 1 -o 1.1,1.2,2.1 -e "---" -1 1 -2 2 sorted_public_data6.txt sorted_KEGG_ID_list.txt > data6_KEGG_ID_all.txt
wc data6_KEGG_ID_all.txt
## 391    1173   12955 data5_KEGG_ID_all.txt

# List the genes in sorted_public_data6.txt that possess corresponding KEGG ID.
gjoin -t$'\t' -i -o 1.1,2.1 -1 1 -2 2 sorted_public_data6.txt sorted_KEGG_ID_list.txt > data6_KEGG_ID.txt
wc data6_KEGG_ID.txt
## 311     622    5022 data6_KEGG_ID.txt

# List the genes in sorted_public_data6.txt that do not possess corresponding KEGG ID.
gjoin -t$'\t' -i -1 1 -2 2 -a 1 -v 1 sorted_public_data6.txt sorted_KEGG_ID_list.txt > data6_NO_KEGG_ID.txt
wc data6_NO_KEGG_ID.txt
## 80     160    2235 data6_NO_KEGG_ID.txt

# Join the 2nd column of data6_KEGG_ID.txt and the 2nd column of lipid_enzyme_list.txt to identify the genes that belong to the lipid metabolism pathway of KEGG database.
cat data6_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data6_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data6_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data6_lipid_genes.txt

# Put the number of genes that belong to the lipid metabolism pathway.
cat data6_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 8       8      46
