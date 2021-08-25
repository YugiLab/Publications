# Genome-wide transcriptome analysis of human iPSC-derived healty control and schizophrenia cortical interneurons under inflammation conditions. (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE132689)

# GSE152438_TPM32_Nor_DEG.csvの2列目(Ensembl ID) を抽出、ソートしてsorted_public_data11.txtとして保存する．
cat GSE152438_TPM32_Nor_DEG.csv | awk -F"," 'NR>1{print $2}' | sed 's/"//g' | sort | uniq > sorted_public_data11.txt

# Ensembl IDを遺伝子名に変換する
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
cat sorted_public_data11.txt | sort -k 1 | uniq > sorted_public_data11_2.txt
gjoin -a 1 -o 1.1,2.2 -e "---" -1 1 -2 1 sorted_public_data11_2.txt sorted_ensembl.txt | sed '/---/d' | awk -F" " '{print $2}' | sort | uniq > sorted_public_data11_genelist.txt


# sorted_public_data11_genelist.txtの1列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -i -a 1 -o 1.1,2.1,1.2 -e "---" -1 1 -2 2 <(sort -b -f -k 1 sorted_public_data11_genelist.txt) sorted_KEGG_ID_list.txt > data11_KEGG_ID_all.txt
wc data11_KEGG_ID_all.txt
## 1262    3786   42455 data11_KEGG_ID_all.txt

# sorted_public_data11_genelist.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -o 1.1,2.1,1.2 -1 1 -2 2 <(sort -b -f -k 1 sorted_public_data11_genelist.txt) sorted_KEGG_ID_list.txt > data11_KEGG_ID.txt
wc data11_KEGG_ID.txt
## 1141    3423   38500 data11_KEGG_ID.txt

# sorted_public_data11_genelist.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -1 1 -2 2 -a 1 -v 1 <(sort -b -f -k 1 sorted_public_data11_genelist.txt) sorted_KEGG_ID_list.txt > data11_NO_KEGG_ID.txt
wc data11_NO_KEGG_ID.txt
## 121     242    3471 data11_NO_KEGG_ID.txt

# data11_KEGG_ID.txtの2列目とsorted_lipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data11_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data11_KEGG_ID.txt
gjoin -1 2 -2 2 sorted_data11_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data11_lipid_genes.txt

# 脂質代謝関連遺伝子の数
cat data11_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 24      24     149
