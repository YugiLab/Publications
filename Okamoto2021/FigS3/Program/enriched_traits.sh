EF_ENRICH_FILE=$1
GTEx_NETWORK=$2
FDR_CUTOFF=0.05
Data_Dir=../Data
TMP_EF_RS=tmp_ef_rs.txt

# Extract the significantly-enriched EFO terms' data
awk -v aCutOff=${FDR_CUTOFF} -F"\t" '{ if( $8 < aCutOff ){ print $1"\t"$2"\t"$8"\t"$14}}' ${EF_ENRICH_FILE} |
    sed -e s/\"//g |
    awk -F"\t" '{ n=split($4, aTokenList, ", ") ; for(i=1;i<=n;i++){ print $1"\t"$2"\t"$3"\t"aTokenList[i] } }' > ${TMP_EF_RS}

# Prepare final result table (gtex_enriched_efo.txt)
echo -e "rs_id\tefo_id\tefo_term\tefo_adjp\tkegg_human_id\tkegg_mouse_id\tmouse_gene_name\tlayer\twt_ob\tgene_annotation\tens_gene_id\tvariant_id\ttissue\ttss_distance\tma_samples\tma_count\tmaf\tpval_nominal\tslope\tslope_se\tpval_nominal_threshold\tmin_pval_nominal\tpval_beta\thuman_gene_name"
join -t$'\t' -1 4 -2 20 <(sort -t$'\t' -k4,4 ${TMP_EF_RS}) <(sort -t$'\t' -k20,20 ${GTEx_NETWORK}) | sort -t$'\t' -k2,5 

rm ${TMP_EF_RS}
