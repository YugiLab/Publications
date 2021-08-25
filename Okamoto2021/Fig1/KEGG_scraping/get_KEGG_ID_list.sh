# Create a table of corresponding gene IDs and gene names in KEGG
curl http://rest.kegg.jp/list/hsa | while read aLine ; do echo "$aLine" | cut -d';' -f1 | awk -F"\t" '{ n=split($2, aTokenList, ",") ; for(i=1;i<=n;i++){ print $1"\t"aTokenList[i] } }' ; done > KEGG_ID_list.txt

# Remove a space in front of any first character of gene name.
sed -e "s/$(printf "\t") /$(printf "\t")/g" KEGG_ID_list.txt > KEGG_ID_list_trimmed.txt

# Remove duplicates from KEGG_ID_list_trimmed.txt and sort it
sort -b -f -k 2 KEGG_ID_list_trimmed.txt | uniq > sorted_KEGG_ID_list.txt
