# Transcriptional signatures of schizophrenia in hiPSC-derived NPCs and neurons are concordant with signatures from post mortem adult brains (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE106589)

# Extract the 2nd column (Ensembl ID) and the 97th column (FoldChange) of GSE106589_geneCounts_DEG.csv, sort them, and save them as sorted_public_data9.txt.
cat GSE106589_geneCounts_DEG.csv | awk -F"," 'NR>1{print $2"\t"$97}' | sed 's/"//g' | sort | uniq > sorted_public_data9.txt

# Transform Ensembl ID into gene name.
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
cat sorted_public_data9.txt | sort -k 1 | uniq > sorted_public_data9_2.txt
gjoin -a 1 -o 1.1,1.2,2.2 -e "---" -1 1 -2 1 sorted_public_data9_2.txt sorted_ensembl.txt | sed '/---/d' > sorted_public_data9_genelist.txt

# Perform a left join on the 3rd column of sorted_public_data9_genelist.txt and the 2nd column of sorted_KEGG_ID_list.txt. Put '---' if there is no corresponding KEGG ID.
gjoin -i -a 1 -o 1.3,1.2,2.1 -e "---" -1 3 -2 2 <(sort -b -f -k 3 sorted_public_data9_genelist.txt) sorted_KEGG_ID_list.txt > data9_KEGG_ID_all.txt
wc data9_KEGG_ID_all.txt
## 2522    7566   84149 data9_KEGG_ID_all.txt

# List the genes in sorted_public_data9.txt that possess correspondin KEGG ID.
gjoin -i -o 1.3,1.2,2.1 -1 3 -2 2 <(sort -b -f -k 3 sorted_public_data9_genelist.txt) sorted_KEGG_ID_list.txt > data9_KEGG_ID.txt
wc data9_KEGG_ID.txt
## 1940    5820   65926 data9_KEGG_ID.txt

# List the genes in sorted_public_data4.txt that do not possess corresponding KEGG ID.
gjoin -i -1 3 -2 2 -a 1 -v 1 <(sort -b -f -k 3 sorted_public_data9_genelist.txt) sorted_KEGG_ID_list.txt > data9_NO_KEGG_ID.txt
wc data9_NO_KEGG_ID.txt
## 582    1746   25207 data9_NO_KEGG_ID.txt

# Join the 3rd column of data9_KEGG_ID.txt and the 2nd column of sorted_lipid_enzyme_list.txt to identify the genes that belong to the lipid metabolism pathway of KEGG database.
cat data9_KEGG_ID.txt | awk -F" " '{print $1"\t"$3}' | sort -t : -k 2 > sorted_data9_KEGG_ID.txt
gjoin -1 2 -2 2 sorted_data9_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data9_lipid_genes.txt

# Put the number of genes that belong to the lipid metabolism pathway.
cat data9_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 59      59     362
