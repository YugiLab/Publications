# Genome-wide transcriptome profiles in Control and Schizophrenia hiPSC-dervied NPC [RNA-seq] (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE92874)

# Extract the 2nd column (Gene) and the 11th column (log_2_fold_change) of GSE92874_RNA_DEG.csv, sort them, and save them as sorted_public_data2.txt.
cat GSE92874_RNA_DEG.csv | awk -F"," 'NR>1{print $2"\t"$11}' | sed 's/"//g' | sort -b -f | uniq > sorted_public_data2.txt

# Perform a left join on the 1st column of sorted_public_data2.txt and the 2nd column of sorted_KEGG_ID_list.txt. Put '---' if there is no corresponding KEGG ID.
gjoin -i -a 1 -o auto -e "---" -2 2 sorted_public_data2.txt sorted_KEGG_ID_list.txt > data2_KEGG_ID_all.txt

wc data2_KEGG_ID_all.txt
## 1443    4329   34938 data2_KEGG_ID_all.txt

# List the genes in sorted_public_data2.txt that possess corresponding KEGG ID.
gjoin -i -2 2 sorted_public_data2.txt sorted_KEGG_ID_list.txt > data2_KEGG_ID.txt

wc data2_KEGG_ID.txt
## 1414    4245   34340 data2_KEGG_ID.txt

# List the genes in sorted_public_data2.txt that do not possess corresponding KEGG ID.
gjoin -i -2 2 -a 1 -v 1 sorted_public_data2.txt sorted_KEGG_ID_list.txt > data2_NO_KEGG_ID.txt

wc data2_NO_KEGG_ID.txt
## 29      58     513 data2_NO_KEGG_ID.txt

# Join the 3rd column of data2_KEGG_ID.txt and the 2nd column of lipid_enzyme_list.txt to identify the genes that belong to the lipid metabolism pathway of KEGG database.
cat data2_KEGG_ID.txt | sort -t : -k 2 | awk -F" " '{print $1"\t"$3}' > sorted_data2_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data2_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data2_lipid_genes.txt

## Put the number of genes that belong to the lipid metabolism pathway.
cat data2_lipid_genes.txt | awk '{print $2}' | sort | uniq | wc
## 37      37     223
