# For macOS, enable these aliases.
# shopt -s expand_aliases
# alias sort='gsort'
# alias sed='gsed'
# alias join='gjoin'
# alias awk='gawk'

Network_File=$1 # '../Data/network_hsa_data*.txt'

Data_Dir=../Data
GTEx_Dir=../Preprocess/GTEx

##
## Preprocessing the multi-layered network
##

# Add KEGG IDs of homologous human genes
awk -F"\t" 'NR > 1 { print $1"\t"$0 }' ${Network_File} > ${Data_Dir}/network_hsa.txt

# Add gene names and annotations for the human IDs
for Gene_ID in $(cut -f1 ${Data_Dir}/network_hsa.txt | sort) ; do
    curl http://rest.kegg.jp/get/${Gene_ID} |
	awk -F" {2,}" -v anID=${Gene_ID} '/^NAME/{ n=split($2, aName , ", ") } ; /^DEFINITION/{ aDef=$2 } ; END{ for(i=1;i<=n;i++){ print anID"\t"aName[i]"\t"aDef} }'
    sleep 0.3s
done > ${Data_Dir}/hsa.name.def.xrefs

##
## Connecting eQTL - Network
##

# Add RefSeq annotation to the network file
join -t$'\t' -1 1 -2 1 -a1 -o1.{1,2,3,4,5} -o2.2 ${Data_Dir}/network_hsa.txt <(cut -f1,3 ${Data_Dir}/hsa.name.def.xrefs | sed -e "s/(RefSeq) //g" | sort -t$'\t' -k1,1 | uniq) > ${Data_Dir}/network_annotated.txt

rm ${Data_Dir}/network_hsa.txt

# Connect the network and the GTEx files via KEGG gene ID for human 
echo -e "kegg_human_id\tkegg_mouse_id\tmouse_gene_name\tlayer\tInc_Dec\tgene_annotation\tens_gene_id\tvariant_id\ttissue\ttss_distance\tma_samples\tma_count\tmaf\tpval_nominal\tslope\tslope_se\tpval_nominal_threshold\tmin_pval_nominal\tpval_beta\trs_id\thuman_gene_name" > ${Data_Dir}/Brain.GTEx.network.txt

join -t$'\t' -1 1 -2 16 -a1 -o1.{1,2,3,4,5,6} -o2.{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15} ${Data_Dir}/network_annotated.txt ${GTEx_Dir}/Brain.GTEx.hsa_sorted.txt >> ${Data_Dir}/Brain.GTEx.network.txt

