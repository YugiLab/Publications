# For macOS, enable these aliases.
# shopt -s expand_aliases
# alias sort='gsort'
# alias sed='gsed'
# alias join='gjoin'
# alias awk='gawk'
# alias zcat='gzcat'

echo -e "variant_id\ttissue\tgene_id\ttss_distance\tma_samples\tma_count\tmaf\tpval_nominal\tslope\tslope_se\tpval_nominal_threshold\tmin_pval_nominal\tpval_beta\trs_id"

aBaseDir=GTEx_Analysis_v8_eQTL
aRawLookUpTable=GTEx_Analysis_2017-06-05_v8_WholeGenomeSeq_838Indiv_Analysis_Freeze.lookup_table.txt # GTEx_Analysis_2016-01-15_v7_WholeGenomeSeq_635Ind_PASS_AB02_GQ20_HETX_MISS15_PLINKQC.lookup_table.txt
aLookUpTable=variant_lookup_table.txt 

# Prepare the Tissue-EnsemblGeneID-rsID table.
# In This study, we focused on only brain-related tissues.
# Save the table as Brain.v8.signif_rs_gene_pairs.txt (~ 1.6 GB)
awk -F"\t" '($7~/^rs/){ print $1"\t"$7 }' ${aRawLookUpTable} | sort -t$'\t' -k1,1 > ${aLookUpTable}
# For v7: awk -F"\t" '($7~/^rs/){ print $3"\t"$7 }' ${aRawLookUpTable} | sort -t$'\t' -k1,1 > ${aLookUpTable}

for aFile in $(ls ${aBaseDir}/Brain*signif_variant_gene_pairs.txt.gz | xargs) ; do
    aTissue=$(echo ${aFile} | cut -d'/' -f2 | cut -d'.' -f1) ;

    join -t$'\t' -1 2 -2 1 <(zcat ${aFile} | tail -n+2 | awk -v tissue=${aTissue} -F"\t" '{ n=split($2,aToken,".") ; OFS="\t" ; $2=aToken[1] ; print tissue"\t"$0 }' | sort -t$'\t' -k2,2) ${aLookUpTable}
done
