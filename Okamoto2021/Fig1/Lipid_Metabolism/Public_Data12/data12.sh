# Molecular profile of parvalbumin-immunoreactive neurons in superior temporal cortex in schizophrenia (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE46509)

# Extract the 2nd column (Gene symbol) of GSE46509_DEG.txt, sort it, and save it as sorted_public_data12.txt.
cat GSE46509_DEG.txt | awk -F"\t" 'NR>2{print $2}' | sed 's/"//g' | awk -F"///" '{print $1}' | sort | uniq > sorted_public_data12.txt

# Perform a left join on the 1st column of sorted_public_data12.txt and the 2nd column of sorted_KEGG_ID_list.txt. Put '---' if there is no corresponding KEGG ID.
gjoin -i -a 1 -o 1.1,2.1 -e "---" -1 1 -2 2 <(sort -b -f sorted_public_data12.txt) sorted_KEGG_ID_list.txt > data12_KEGG_ID_all.txt
wc data12_KEGG_ID_all.txt
## 797    1594   12674 data12_KEGG_ID_all.txt

# List the genes in sorted_public_data12.txt that possess corresponding KEGG ID.
gjoin -i -o 1.1,2.1 -1 1 -2 2 <(sort -b -f sorted_public_data12.txt) sorted_KEGG_ID_list.txt > data12_KEGG_ID.txt
wc data12_KEGG_ID.txt
## 715    1430   11564 data12_KEGG_ID.txt

# List the genes in sorted_public_data12.txt that do not possess corresponding KEGG ID.
gjoin -i -1 1 -2 2 -a 1 -v 1 <(sort -b -f sorted_public_data12.txt) sorted_KEGG_ID_list.txt > data12_NO_KEGG_ID.txt
wc data12_NO_KEGG_ID.txt
## 82      88     815 data12_NO_KEGG_ID.txt

# Join the 2nd column of data12_KEGG_ID.txt and the 2nd column of sorted_lipid_enzyme_list.txt to identify the genes that belong to the lipid metabolism pathway of KEGG database.
cat data12_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data12_KEGG_ID.txt
gjoin -1 2 -2 2 sorted_data12_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data12_lipid_genes.txt

# Put the number of genes that belong to the lipid metabolism pathway.
cat data12_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 17      17     108
