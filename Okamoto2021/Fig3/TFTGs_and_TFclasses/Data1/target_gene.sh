#!/bin/bash
#　Connect the list of TFBSs obtained as a result of TF estimation to the Target Gene (enhancer, promoter).
mkdir Result
PublicData=$1
echo "${PublicData}"
## Use genehancer_data*.csv, which is the result of TF estimation from GeneALaCart.
## Extract the symbols in the 2nd column, GHIDs in the 3rd column, and GHtype in the 4th column to create a list of gene names, GH types, and GHIDs.
cat genehancer_data"${PublicData}".csv | awk -F"," 'NR>1{print $2","$3","$4}' > gene_GHID_list.txt

## Link TFBS and GHID by joining the 1st column of data1_TFBS_DEGs.txt and the 2nd column of data*_TFBS_list.txt.
join -t $',' -a 1 -o 1.1,2.1 -e "---" -1 1 -2 2 <(sort data"${PublicData}"_TFBS_DEGs.txt) <(sort -t "," -k 2 -f data"${PublicData}"_TFBS_list.txt | sed -e "/,\$/d") > data"${PublicData}"_TFBS_GHIDs_layer1.txt

## Join the 2nd column of data*_TFBS_GHIDs_layer1.txt with the 2nd column of gene_GHID_list.txt to link TFBS and GeneTarget.
join -t $',' -o 1.1,2.1,2.3 -1 2 -2 2 <(sort -t "," -k 2 data"${PublicData}"_TFBS_GHIDs_layer1.txt ) <(sort -t "," -k 2 gene_GHID_list.txt) > ./Result/data"${PublicData}"_targetgenes_layer1.txt

## Use genehancer_data*_depth2.csv, which is the result of TF estimation (layer2) from GeneALaCart.
## Extract the symbol in the 2nd column, GHIDs in the 3rd column, and GHtype in the 4th column to create a list of gene names, GH types, and GHIDs.
cat genehancer_data"${PublicData}"_depth2.csv | awk -F"," 'NR>1{print $2","$3","$4}' > gene_GHID_list2.txt

## Link TFBS to GHID by joining the 1st column of data*_TFBS_DEGs2.txt and the 2nd column of data1_TFBS_list2.txt.
join -t $',' -a 1 -o 1.1,2.1 -e "---" -1 1 -2 2 <(sort data"${PublicData}"_TFBS_DEGs2.txt) <(sort -t "," -k 2 -f data"${PublicData}"_TFBS_list2.txt | sed -e "/,\$/d") > data"${PublicData}"_TFBS_GHIDs_layer2.txt

## Join the 2nd column of data*_TFBS_GHIDs_layer2.txt with the 2nd column of gene_GHID_list2.txt to link TFBS and GeneTarget.
join -t $',' -o 1.1,2.1,2.3 -1 2 -2 2 <(sort -t "," -k 2 data"${PublicData}"_TFBS_GHIDs_layer2.txt ) <(sort -t "," -k 2 gene_GHID_list2.txt) > ./Result/data"${PublicData}"_targetgenes_layer2.txt

cd Result
cat data"${PublicData}"_targetgenes_layer1.txt | awk -F"," '{print $2}' | sort -k 2,2 | uniq > lipid_gene_targets.txt
cat data"${PublicData}"_targetgenes_layer1.txt | awk -F"," '{print $1"\t"$2}' > data"${PublicData}"_targetgenes.txt
cat data"${PublicData}"_targetgenes_layer2.txt | awk -F"," '{print $1"\t"$2}' >> data"${PublicData}"_targetgenes.txt

# Three-column data for CIRCOS
cat data"${PublicData}"_targetgenes_layer1.txt > a.txt
cat data"${PublicData}"_targetgenes_layer2.txt >> a.txt
cat a.txt | sort -k 2,2 | uniq > a_sorted.txt
cat a_sorted.txt | awk -F"," '
    {
        if($3 == "Promoter/Enhancer"){
            print $0
            print $1","$2",Enhancer"
        }else{
            print $0
        }
    }
' | awk -F"," '{ sub("/.*$",""); print $0; }' | sort -k 2,2 | uniq > data"${PublicData}"_TFTGs.txt

# TF list for PANTHER
cat data"${PublicData}"_targetgenes.txt | awk -F"\t" '{print $1}' | sort | uniq > data"${PublicData}"_panther.txt

# cat pantherGeneList.txt | awk -F"\t" 'NR>1{print $2"\t"$5}' > data2_TFclass.txt
