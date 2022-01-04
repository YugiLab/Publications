#!/bin/bash

DataNo=$1
Data_Dir=../Data

bash 1_preproc_TFBS.sh ${DataNo}
bash 2_gwas_transomics_okamotoetal.sh ${Data_Dir}/network_hsa_data"${DataNo}".txt
bash 3_snp_enrichment_okamotoetal.sh
Rscript 4_count_the_num_of_snps_and_genes.R ${Data_Dir}
