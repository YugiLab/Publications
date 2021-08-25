# Acquisition of KEGG lipid metabolism pathways and gene IDs within the pathways
for aPathway in $(curl http://rest.kegg.jp/get/br:br08901 | awk '/B  Lipid metabolism/,/B  Nucleotide metabolism/ { print "hsa"$2}' | tail -n+2 | sed '$d' | xargs)
do
curl http://rest.kegg.jp/link/hsa/${aPathway} >> lipid_enzyme_list.txt
done

# Obtain lipid metabolism pathways from KEGG REST (http://rest.kegg.jp/get/br:br08901)
# Save as lipid_metabolism_pathways.txt
