#!/bin/bash
DataNo=$1
echo "Public Data${DataNo}"

# Create input for GeneHancer Query (https://genealacart.genecards.org/Query)
cat data"${DataNo}"_TFBS_depth1.txt | awk -F" " '{print $1}' | sort | uniq > data"${DataNo}"_GH_input1.txt
cat data"${DataNo}"_TFBS_depth2.txt | awk -F" " '{print $1}' | sort | uniq > data"${DataNo}"_GH_input2.txt

# Obtain GeneHancer GHIDs from GeneALaCArt. Save the GeneHancer tab as csv file.
# Extract the 1st and 3rd columns from the csv file and remove duplicates.
cat data"${DataNo}"_layer1.csv | sed -e '1d' | awk -F"," '{print $1"\t"$3}' | sort | uniq > data"${DataNo}"_layer1_GHIDs.txt
cat data"${DataNo}"_layer2.csv | sed -e '1d' | awk -F"," '{print $1"\t"$3}' | sort | uniq > data"${DataNo}"_layer2_GHIDs.txt

# Join the list of TFs with braintissue_list.txt
#join -t $'\t' -a 1 -o 1.1,1.2,2.2,2.3 -e "---" -1 2 -2 1 <(sort -k2 data"${DataNo}"_layer1_GHIDs.txt) <(sort -k1 braintissue_list.txt) > data"${DataNo}"_layer1_joined_results.txt
#join -t $'\t' -a 1 -o 1.1,1.2,2.2,2.3 -e "---" -1 2 -2 1 <(sort -k2 data"${DataNo}"_layer2_GHIDs.txt) <(sort -k1 braintissue_list.txt) > data"${DataNo}"_layer2_joined_results.txt

# Join the list of TFs with braintissue_list.txt and sort, excluding lines that do not match
join -t $'\t' -a 1 -o 1.1,1.2,2.2,2.3 -e "---" -1 2 -2 1 <(sort -k2 data"${DataNo}"_layer1_GHIDs.txt) <(sort -k1 braintissue_list.txt) | grep -v "[-]$" | awk -F"\t" '{print $1}' | sort | uniq > data"${DataNo}"_layer1_joined.txt
join -t $'\t' -a 1 -o 1.1,1.2,2.2,2.3 -e "---" -1 2 -2 1 <(sort -k2 data"${DataNo}"_layer2_GHIDs.txt) <(sort -k1 braintissue_list.txt) | grep -v "[-]$" | awk -F"\t" '{print $1}' | sort | uniq > data"${DataNo}"_layer2_joined.txt

# Convert brain tissue specific TFs to Ensembl ID
join -a 1 -o 1.1,2.1  -e "---" -1 1 -2 2 <(sort data"${DataNo}"_layer1_joined.txt) <(sort -k 2 -i ensembl_taiouhyou.txt) | sort | uniq > data"${DataNo}"_layer1_braintissue_only.txt
join -a 1 -o 1.1,2.1  -e "---" -1 1 -2 2 <(sort data"${DataNo}"_layer2_joined.txt) <(sort -k 2 -i ensembl_taiouhyou.txt) | sort | uniq > data"${DataNo}"_layer2_braintissue_only.txt
