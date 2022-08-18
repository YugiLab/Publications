# For macOS, enable these aliases.
# shopt -s expand_aliases
# alias sort='gsort'
# alias join='gjoin'

Ens_Dir=../Ensembl

# Add human gene names and KEGG IDs to the GTEx data
# Col 3 (out of 14) == Ensembl gene ID 
sort -t$'\t' -k3,3 Brain.v8.signif_rs_gene_pairs.txt > Brain.GTEx.ens_sorted.txt

join -t$'\t' -1 3 -2 1 Brain.GTEx.ens_sorted.txt ${Ens_Dir}/ens_sorted.name.hsa.xrefs > Brain.GTEx.hsa.txt

rm Brain.GTEx.ens_sorted.txt

# Sort the data by KEGG gene id (Entrez gene id)
# Col 16 (out of 16) == KEGG gene ID for human (e.g. hsa:7105)
sort -t$'\t' -k16,16 Brain.GTEx.hsa.txt > Brain.GTEx.hsa_sorted.txt

rm Brain.GTEx.hsa.txt
