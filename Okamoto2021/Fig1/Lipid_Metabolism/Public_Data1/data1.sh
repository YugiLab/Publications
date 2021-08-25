# Genome-wide transcriptional analysis of human iPSC-derived healthy control vs. schizophrenia cortical interneurons. (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE125999)

# Extract the 2nd column (Ensembl ID) and the 63rd column (FoldChange) of GSE125999_TPM_15pair_DEGnew.csv, sort them, and save them as sorted_public_data1.txt.
cat GSE125999_TPM_15pair_DEG_new.csv | awk -F"," 'NR>1{print $2"\t"$63}' | sed 's/"//g' | sort | uniq > sorted_public_data1.txt

# Transform Ensembl ID into gene name.
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
cat sorted_public_data1.txt | sort -k 1 | uniq > sorted_public_data1_2.txt
gjoin -a 1 -o 1.1,1.2,2.2 -e "---" -1 1 -2 1 sorted_public_data1_2.txt sorted_ensembl.txt | sed '/---/d' > sorted_public_data1_genelist.txt

# Perform a left join on the 3rd column of sorted_public_data1_genelist.txt and the 2nd column of sorted_KEGG_ID_list.txt. Put '---' if there is no corresponding KEGG ID.
gjoin -i -a 1 -o 1.3,1.2,2.1 -e "---" -1 3 -2 2 <(sort -k 3 sorted_public_data1_genelist.txt) sorted_KEGG_ID_list.txt > data1_KEGG_ID_all.txt

wc data1_KEGG_ID_all.txt


# List the genes in sorted_public_data1.txt that possess corresponding KEGG ID.
gjoin -i -o 1.3,1.2,2.1 -1 3 -2 2 <(sort -k 3 sorted_public_data1_genelist.txt) sorted_KEGG_ID_list.txt > data1_KEGG_ID.txt

wc data1_KEGG_ID.txt


# List the genes in sorted_public_data1.txt that do not possess corresponding KEGG ID.
gjoin -i -1 3 -2 2 -a 1 -v 1 <(sort -k 3 sorted_public_data1_genelist.txt) sorted_KEGG_ID_list.txt > data1_NO_KEGG_ID.txt

wc data1_NO_KEGG_ID.txt


# Join the 3rd column of data1_KEGG_ID.txt and the 2nd column of lipid_enzyme_list.txt to identify the genes that belong to the lipid metabolism pathway of KEGG database.
cat data1_KEGG_ID.txt | awk -F" " '{print $1"\t"$3}' | sort -t : -k 2 > sorted_data1_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data1_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data1_lipid_genes.txt

# Put the number of genes that belong to the lipid metabolism pathway.
cat data1_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc

