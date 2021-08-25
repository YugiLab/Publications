# Next Generation Sequencing Facilitates Comparisons of Control and Schizophrenia-Patient derived hiPSC-derived NPCs (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE63738)

# Extract the 2nd column (Gene Feature) and the 15th column (FoldChange) of GSE63738_SCZ_NPC.ucsc.Clean_DEG.csv, sort them, and save them as sorted_public_data7.txt.
cat GSE63738_SCZ_NPC.ucsc.Clean_DEG.csv | awk -F"," 'NR>1{print $2"\t"$15}' | sed 's/"//g' | sort | uniq > sorted_public_data7.txt

# Perform a left join on the 1st column of sorted_public_data7.txt and the 2nd column of sorted_KEGG_ID_list.txt. Put '---' if there is no corresponding KEGG ID.
gjoin -i -a 1 -o 1.1,1.2,2.1 -e "---" -1 1 -2 2 sorted_public_data7.txt sorted_KEGG_ID_list.txt > data7_KEGG_ID_all.txt
wc data7_KEGG_ID_all.txt
## 674    2022   22382 data7_KEGG_ID_all.txt

# List the genes in sorted_public_data7.txt that possess corresponding KEGG ID.
gjoin -i -o 1.1,2.1 -1 1 -2 2 sorted_public_data7.txt sorted_KEGG_ID_list.txt > data7_KEGG_ID.txt
wc data7_KEGG_ID.txt
## 620    1240   10049 data7_KEGG_ID.txt

# List the genes in sorted_public_data7.txt that do not possess corresponding KEGG ID.
gjoin -i -1 1 -2 2 -a 1 -v 1 sorted_public_data7.txt sorted_KEGG_ID_list.txt > data7_NO_KEGG_ID.txt

wc data7_NO_KEGG_ID.txt
## 54     108    1462 data7_NO_KEGG_ID.txt

# Join the 2nd column of data7_KEGG_ID.txt and the 2nd column of sorted_lipid_enzyme_list.txt to identify the genes that belong to the lipid metabolism pathway of KEGG database.
cat data7_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data7_KEGG_ID.txt
gjoin -1 2 -2 2 sorted_data7_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data7_lipid_genes.txt

# Put the number of genes that belong to the lipid metabolism pathway.
cat data7_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 8       8      49
