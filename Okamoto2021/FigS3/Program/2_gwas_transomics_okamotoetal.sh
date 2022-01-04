# For macOS, enable these aliases.
# shopt -s expand_aliases
# alias sort='gsort'
# alias sed='gsed'
# alias join='gjoin'
# alias awk='gawk'

Network_File=$1 # '../Data/network_hsa_data*.txt'

Data_Dir=../Data
Ens_Dir=../Preprocess/Ensembl
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
## Preprocessing GTEx
##

GTEx_eQTL=${GTEx_Dir}/Brain.v8.signif_rs_gene_pairs.txt 
VARIANT_RS_TABLE=${GTEx_Dir}/variant_lookup_table.txt

# Add human gene names and KEGG IDs to the GTEx data
sort -t$'\t' -k3,3 ${GTEx_eQTL} > ${Data_Dir}/Brain.GTEx.ens_sorted.txt

join -t$'\t' -1 3 -2 1 ${Data_Dir}/Brain.GTEx.ens_sorted.txt ${Ens_Dir}/ens_sorted.name.hsa.xrefs > ${Data_Dir}/Brain.GTEx.hsa.txt

rm ${Data_Dir}/Brain.GTEx.ens_sorted.txt

# Sort the data by KEGG gene id (Entrez gene id)
# Col 16 (out of 16) == KEGG gene ID for human (e.g. hsa:7105)
sort -t$'\t' -k16,16 ${Data_Dir}/Brain.GTEx.hsa.txt > ${Data_Dir}/Brain.GTEx.hsa_sorted.txt

rm ${Data_Dir}/Brain.GTEx.hsa.txt

##
## Connecting eQTL - Network
##

# Add RefSeq annotation to the network file
join -t$'\t' -1 1 -2 1 -a1 -o1.{1,2,3,4,5} -o2.2 ${Data_Dir}/network_hsa.txt <(cut -f1,3 ${Data_Dir}/hsa.name.def.xrefs | sed -e "s/(RefSeq) //g" | sort -t$'\t' -k1,1 | uniq) > ${Data_Dir}/network_annotated.txt

rm ${Data_Dir}/network_hsa.txt

# Connect the network and the GTEx files via KEGG gene ID for human 
echo -e "kegg_human_id\tkegg_mouse_id\tmouse_gene_name\tlayer\tInc_Dec\tgene_annotation\tens_gene_id\tvariant_id\ttissue\ttss_distance\tma_samples\tma_count\tmaf\tpval_nominal\tslope\tslope_se\tpval_nominal_threshold\tmin_pval_nominal\tpval_beta\trs_id\thuman_gene_name" > ${Data_Dir}/Brain.GTEx.network.txt

join -t$'\t' -1 1 -2 16 -a1 -o1.{1,2,3,4,5,6} -o2.{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15} ${Data_Dir}/network_annotated.txt ${Data_Dir}/Brain.GTEx.hsa_sorted.txt >> ${Data_Dir}/Brain.GTEx.network.txt

rm ${Data_Dir}/Brain.GTEx.hsa_sorted.txt

