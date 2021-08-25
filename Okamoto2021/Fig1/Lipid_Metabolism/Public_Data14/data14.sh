# Comparing Control and Schizophrenic hiPSC-derived Neurons (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE25673)

# Extract the 4th column of GSE25673_fold_change_analysis_pval005.txt, sort it, and save it as sorted_public_data14.txt.
cat GSE25673_fold_change_analysis_pval005.txt | awk -F"\t" 'NR>1{print $4}' | sed '/^$/d' | sort -b -f | uniq > sorted_public_data14.txt

# Perform a left join on the 1st column of sorted_public_data14.txt and the 2nd column of sorted_KEGG_ID_list.txt. Put '---' if there is no corresponding KEGG ID.
gjoin -t$'\t' -i -a 1 -o 1.1,2.1 -e "---" -1 1 -2 2 sorted_public_data14.txt sorted_KEGG_ID_list.txt > data14_KEGG_ID_all.txt
wc data14_KEGG_ID_all.txt
## 1945    3890   30137 data14_KEGG_ID_all.txt

# List the genes in sorted_public_data14.txt that possess corresponding KEGG ID.
gjoin -t$'\t' -i -o 1.1,2.1 -1 1 -2 2 sorted_public_data14.txt sorted_KEGG_ID_list.txt > data14_KEGG_ID.txt
wc data14_KEGG_ID.txt
## 1622    3244   26174 data14_KEGG_ID.txt

# List the genes in sorted_public_data14.txt that do not possess corresponding KEGG ID.
gjoin -t$'\t' -i -1 1 -2 2 -a 1 -v 1 sorted_public_data14.txt sorted_KEGG_ID_list.txt > data14_NO_KEGG_ID.txt
wc data14_NO_KEGG_ID.txt
## 323     323    2671 data14_NO_KEGG_ID.txt

# Join the 2nd column of data14_KEGG_ID.txt and the 2nd column of lipid_enzyme_list.txt to identify the genes that belong to the lipid metabolism pathway of KEGG database.
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 <(sort -t : -k 2 data14_KEGG_ID.txt) sorted_lipid_enzyme_list.txt > data14_lipid_genes.txt

# Put the number of genes that belong to the lipid metabolism pathway.
cat data14_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 34      34     221
