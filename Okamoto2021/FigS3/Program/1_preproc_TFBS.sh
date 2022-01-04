# For macOS, enable these aliases.
# shopt -s expand_aliases
# alias sort='gsort'
# alias sed='gsed'
# alias join='gjoin'
# alias awk='gawk'

Data_Dir=../Data
Ens_Dir=../Preprocess/Ensembl
GTEx_Dir=../Preprocess/GTEx

DataNo=$1
echo "Public Data${DataNo}"

# Merge the TF lists of Layer 1 and Layer 2.
cat ${Data_Dir}/data"${DataNo}"_TFBS_depth1.txt ${Data_Dir}/data"${DataNo}"_TFBS_depth2.txt  | sort | uniq | cut -d " " -f 2 > ${Data_Dir}/data"${DataNo}"_TFBS.txt

# Obtain network file
join -t$'\t' -1 1 -2 1 <(cat ${Data_Dir}/data"${DataNo}"_TFBS.txt | sort | uniq) <(cat ${Ens_Dir}/ens_hsa.name.ncbi.xrefs | sort | uniq) > ${Data_Dir}/network_temp1.txt
awk -F"\t" '{ print "hsa:"$3"\t"$2"\tTranscriptome\tchanged" }' ${Data_Dir}/network_temp1.txt | sort | uniq > ${Data_Dir}/network_hsa_data"${DataNo}".txt
sed -i '1iID\tName\tLayer\tIncDec' ${Data_Dir}/network_hsa_data"${DataNo}".txt

# Delete temporary files
rm ${Data_Dir}/network_temp1.txt
