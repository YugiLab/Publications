# Genome-wide transcriptome analysis of human iPSC-derived cortical interneurons under inflammation conditions (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE152438)

# GSE152438_TPM32_DEG.csvの2列目(Ensembl ID)と35列目のFoldChangeを抽出、ソートしてsorted_public_data3.txtとして保存する．
cat GSE152438_TPM32_ND_DEG.csv | awk -F"," 'NR>1{print $2"\t"$35}' | sed 's/"//g' | sort | uniq > sorted_public_data10.txt

# Ensembl IDを遺伝子名に変換する
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
cat sorted_public_data10.txt | sort -k 1 | uniq > sorted_public_data10_2.txt
gjoin -a 1 -o 1.1,1.2,2.2 -e "---" -1 1 -2 1 sorted_public_data10_2.txt sorted_ensembl.txt | sed '/---/d' > sorted_public_data10_genelist.txt

# sorted_public_data10_genelist.txtの3列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -i -a 1 -o 1.3,1.2,2.1 -e "---" -1 3 -2 2 <(sort -b -f -k 3 sorted_public_data10_genelist.txt) sorted_KEGG_ID_list.txt > data10_KEGG_ID_all.txt
wc data10_KEGG_ID_all.txt
## 2217    6651   73906 data10_KEGG_ID_all.txt

# sorted_public_data10.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -o 1.3,1.2,2.1 -1 3 -2 2 <(sort -b -f -k 3 sorted_public_data10_genelist.txt) sorted_KEGG_ID_list.txt > data10_KEGG_ID.txt
wc data10_KEGG_ID.txt
## 2148    6444   71771 data10_KEGG_ID.txt

# sorted_public_data10.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -1 3 -2 2 -a 1 -v 1 <(sort -b -f -k 3 sorted_public_data10_genelist.txt) sorted_KEGG_ID_list.txt > data10_NO_KEGG_ID.txt
wc data10_NO_KEGG_ID.txt
## 69     207    2963 data10_NO_KEGG_ID.txt

# data10_KEGG_ID.txtの3列目とsorted_lipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data10_KEGG_ID.txt | awk -F" " '{print $1"\t"$3}' | sort -t : -k 2 > sorted_data10_KEGG_ID.txt
gjoin -1 2 -2 2 sorted_data10_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data10_lipid_genes.txt

# 脂質代謝関連遺伝子
cat data10_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 34      34     209
