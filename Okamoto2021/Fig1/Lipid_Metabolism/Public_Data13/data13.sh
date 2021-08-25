# Comparison of post-mortem tissue from Brodman Brain BA22 region between schizophrenic and control patients (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE21935)

# Extract the 1st column (HUGO symbol) of publicdata13.csv, sort it, and save it as sorted_public_data13.txt.
cat publicdata13.csv | awk -F"," 'NR>1{print $1}' | sort | uniq > sorted_public_data13.txt

# Change the line feed code of sorted_public_data13.txt from \r\n to \n and save it as sorted_public_data13_2.txt.
tr -d "\r" < sorted_public_data13.txt > sorted_public_data13_2.txt

# Perform a left join on the 1st column of sorted_public_data13_2.txt and the 2nd column of sorted_KEGG_ID_list.txt. Put '---' if there is no corresponding KEGG ID.
gjoin -i -a 1 -o 1.1,2.1 -e "---" -1 1 -2 2 <(sort -k 3 sorted_public_data13_2.txt) sorted_KEGG_ID_list.txt > data13_KEGG_ID_all.txt
wc data13_KEGG_ID_all.txt
## 56     112     904 data13_KEGG_ID_all.txt

# List the genes in sorted_public_data13_2.txt that possess corresponding KEGG ID.
gjoin -i -o 1.1,2.1 -1 1 -2 2 <(sort -k 3 sorted_public_data13_2.txt) sorted_KEGG_ID_list.txt > data13_KEGG_ID.txt
wc data13_KEGG_ID.txt
## 55     110     895 data13_KEGG_ID.txt

# List the genes in sorted_public_data13_2.txt that do not possess corresponding KEGG ID.
gjoin -i -1 1 -2 2 -a 1 -v 1 <(sort -k 3 sorted_public_data13_2.txt) sorted_KEGG_ID_list.txt > data13_NO_KEGG_ID.txt
wc data13_NO_KEGG_ID.txt
## 1       1       5 data13_NO_KEGG_ID.txt

# Join the 2nd column of data13_KEGG_ID.txt and the 2nd column of sorted_lipid_enzyme_list.txt to identify the genes that belong to the lipid metabolism pathway of KEGG database.
cat data13_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data13_KEGG_ID.txt
gjoin -1 2 -2 2 sorted_data13_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data13_lipid_genes.txt

# Put the number of genes that belong to the lipid metabolism pathway.
cat data13_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 0       0       0
