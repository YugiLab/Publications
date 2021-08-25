# Comparing Control and Schizophrenic hiPSC-derived NPCs (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE40102)

# Extract the 4th column (Gene.Symbol) and the 15th column (FoldChange) of GSE40102_analysis_DEG.csv, sort them , and save them as sorted_public_data3.txt.
cat GSE40102_analysis_DEG_tsv.tsv | awk -F"\t" 'NR>1{if($4 != "")print $4"\t"$15}' | sed 's/"//g' | sed 's/^[ \t]*//' | grep -v '^\s*\t' | sort -b -f | uniq > sorted_public_data3.txt

# Perform a left join on the 1st column of sorted_public_data3.txt and the 2nd column of sorted_KEGG_ID_list.txt. Put '---' if there is no corresponding KEGG ID.
gjoin -t $'\t' -i -a 1 -o auto -e "---" -1 1 -2 2 sorted_public_data3.txt sorted_KEGG_ID_list.txt > data3_KEGG_ID_all.txt

wc data3_KEGG_ID_all.txt
## 3445   13519   91749 data3_KEGG_ID_all.txt

# List the genes in sorted_public_data3.txt that possess corresponding KEGG ID.
gjoin -t $'\t' -i -1 1 -2 2 sorted_public_data3.txt sorted_KEGG_ID_list.txt > data3_KEGG_ID.txt

wc data3_KEGG_ID.txt
## 2101    6303   51468 data3_KEGG_ID.txt

# List the genes in sorted_public_data3.txt that do not possess corresponding KEGG ID.
gjoin -t $'\t' -i -2 2 -a 1 -v 1 sorted_public_data3.txt sorted_KEGG_ID_list.txt > data3_NO_KEGG_ID.txt

wc data3_NO_KEGG_ID.txt
## 1344    5872   34905 data3_NO_KEGG_ID.txt

# Join the 3rd column of data3_KEGG_ID.txt and the 2nd column of lipid_enzyme_list.txt to identify the genes that belong to the lipid metabolism pathway of KEGG database.
cat data3_KEGG_ID.txt | awk -F " " '{print $1"\t"$3}' | sort -t : -k 2 > sorted_data3_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data3_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data3_lipid_genes.txt

# Put the number of genes that belong to the lipid metabolism pathway.
cat data3_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 29      29     168
