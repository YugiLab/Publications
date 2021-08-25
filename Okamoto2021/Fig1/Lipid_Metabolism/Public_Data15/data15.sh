# Genome-wide transcriptional analysis of human iPSC-derived healty control vs. schizophrenia cortical interneurons. ( https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE118313 )

# Extract the 5th column (symbol) of p_005.csv, sort it, and save it as sorted_public_data.txt.
cat p_005.csv | awk -F"," 'NR>1{print $5}' | sed 's/"//g' | sort -b -f | uniq > sorted_p_005.txt

# Perform a left join on the 1st column of sorted_p_005.txt and the 2nd column of sorted_KEGG_ID_list.txt. Put '---' if there is no corresponding KEGG ID.
gjoin -i -a 1 -o auto -e "---" -2 2 sorted_p_005.txt sorted_KEGG_ID_list.txt > p_005_KEGG_ID_all.txt

# List the genes in sorted_p_005.txt that possess corresponding KEGG ID.
gjoin -i -2 2 sorted_p_005.txt sorted_KEGG_ID_list.txt > P_005_KEGG_ID.txt

# List the genes in sorted_public_data1.txt that do not possess corresponding KEGG ID.
gjoin -i -2 2 -a 1 -v 1 sorted_p_005.txt sorted_KEGG_ID_list.txt > P_005_NO_KEGG_ID.txt

# Join the 2nd column of P_005_KEGG_ID.txt and the 2nd column of lipid_enzyme_list.txt to identify the genes that belong to the lipid metabolism pathway of KEGG database.
gjoin -1 2 -2 2 <(cat P_005_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2) <(sort -t : -k 3 lipid_enzyme_list.txt) > P_005_lipid_genes.txt

# Put the number of genes that belong to the lipid metabolism pathway.
cat P_005_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 20      20     133
