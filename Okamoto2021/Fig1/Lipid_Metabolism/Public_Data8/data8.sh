# Next Generation Sequencing Facilitates Comparisons of Control and Schizophrenia-Patient derived hiPSC-derived neurons (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE63734)

# Extract the 2nd column (Gene Feature) and the 14th column (FoldChange) of GSE63734_SCZ_Neurons.ucsc.Clean_DEG.csv, sort them, and save them as sorted_public_data8.txt.
cat GSE63734_SCZ_Neurons.ucsc.Clean_DEG.csv | awk -F"," 'NR>1{print $2"\t"$14}' | sed 's/"//g' | sort | uniq > sorted_public_data8.txt

# Perform a left join on the 1st column of sorted_public_data8.txt and the 2nd column of sorted_KEGG_ID_list.txt. Put '---' if there is no corresponding KEGG ID.
gjoin -i -a 1 -o 1.1,1.2,2.1 -e "---" -1 1 -2 2 sorted_public_data8.txt sorted_KEGG_ID_list.txt > data8_KEGG_ID_all.txt
wc data8_KEGG_ID_all.txt
## 578    1734   18898 data8_KEGG_ID_all.txt

# List the genes in sorted_public_data8.txt that possess corresponding KEGG ID.
gjoin -i -o 1.1,2.1 -1 1 -2 2 sorted_public_data8.txt sorted_KEGG_ID_list.txt > data8_KEGG_ID.txt
wc data8_KEGG_ID.txt
## 519    1038    8483 data8_KEGG_ID.txt

# List the genes in sorted_public_data8.txt that do not possess corresponding KEGG ID.
gjoin -i -1 1 -2 2 -a 1 -v 1 sorted_public_data8.txt sorted_KEGG_ID_list.txt > data8_NO_KEGG_ID.txt
wc data8_NO_KEGG_ID.txt
## 59     118    1529 data8_NO_KEGG_ID.txt

# Join the 2nd column of data8_KEGG_ID.txt and the 2nd column of sorted_lipid_enzyme_list.txt to identify the genes that belong to the lipid metabolism pathway of KEGG database.
cat data8_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data8_KEGG_ID.txt
gjoin -1 2 -2 2 sorted_data8_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data8_lipid_genes.txt

# Put the number of genes that belong to the lipid metabolism pathway.
cat data8_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 9       9      58
