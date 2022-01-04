# For macOS, enable these aliases.
# shopt -s expand_aliases
# alias sort='gsort'
# alias sed='gsed'
# alias join='gjoin'
# alias awk='gawk'

# Obtain Ensembl Gene IDs and Entrez Gene IDs of Homo sapiens
wget -O ens_hsa.ncbi.xrefs "http://www.ensembl.org/biomart/martservice?query=$(tr -d "\n" < ens_hsa.ncbi.xml)"

# Obtain Ensembl Gene IDs and Entrez Gene IDs of Mus musculus
wget -O ens_mmu.ncbi.xrefs "http://www.ensembl.org/biomart/martservice?query=$(tr -d "\n" < ens_mmu.ncbi.xml)"

# Prepare the gene ortholog table between Homo sapiens and Mus musculus
wget -O ensembl_ortholog.txt "http://www.ensembl.org/biomart/martservice?query=$(tr -d "\n" < hsa.mmu.xml)"

# Obtain Ensembl IDs, Gene names and Entrez IDs of Homo sapiens simultaneously.
wget -O ens_hsa.name.ncbi.xrefs "http://www.ensembl.org/biomart/martservice?query=$(tr -d "\n" < ens_hsa.name.ncbi.xml)"

# Sort ens_hsa.name.ncbi.xrefs by Ensembl Gene ID
sort -t$'\t' -k1,1 ens_hsa.name.ncbi.xrefs > ens_hsa_sorted.name.xrefs

# Add "hsa:" to Entrez gene ID
awk -F"\t" '{ if($3!=""){ print $1"\t"$2"\thsa:"$3 } else { print } }' ens_hsa_sorted.name.xrefs > ens_sorted.name.hsa.xrefs

# Join the Ensembl Gene ID / Entrez Gene ID table and the gene ortholog table
join -t$'\t' -1 1 -2 1 <(sort -k1,1 ens_hsa.ncbi.xrefs) <(sort -k1,1 ensembl_ortholog.txt) > ens_hsa.ncbi_hsa.ens_mmu.xrefs

# Add the information of Entrez Gene ID to ens_hsa.ncbi_hsa.ens_mmu.xrefs
join -t$'\t' -1 5 -2 1 -o1.1 -o1.2 -o1.3 -o1.4 -o1.5 -o2.2 -o1.6 -o1.7 -o1.8 <(sort -t$'\t' -k5,5 ens_hsa.ncbi_hsa.ens_mmu.xrefs) <(sort -k1,1 ens_mmu.ncbi.xrefs ) > ens_hsa.ncbi_hsa.ens_mmu.ncbi_mmu.xrefs

# Extract the information of human Entrez Gene IDs and their mouse orthologs' Entrez Gene IDs
# Simultaneously, add "hsa:" or "mmu:" to extracted Entrez Gene IDs
awk -F"\t" '($2!="" && $6!=""){ print "hsa:"$2"\tmmu:"$6 }' ens_hsa.ncbi_hsa.ens_mmu.ncbi_mmu.xrefs > hsa.mmu.xrefs

# Extract the information of human Ensembl Gene IDs and their mouse orthologs' Enrez Gene IDs
# Simultaneously, add "mmu:" to extracted Entrez Gene IDs
awk -F"\t" '($1!="" && $6!=""){ print $1"\tmmu:"$6 }' ens_hsa.ncbi_hsa.ens_mmu.ncbi_mmu.xrefs | sort -t$'\t' -k1,1 > ens_hsa.mmu.xrefs
