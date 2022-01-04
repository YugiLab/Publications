# Pilot transcriptome analysis of human iPSC-derived healthy control vs. schizophrenia cortical interneurons (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE125805)

# data4_DEG.txtをソートしてsorted_public_data4.txtとして保存する．
cat data4_DEG.txt | sort | uniq > sorted_public_data4.txt

# Ensembl IDを遺伝子名に変換する
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
gjoin -a 1 -o 1.1,2.1,2.2 -e "---" -1 1 -2 1 sorted_public_data4.txt sorted_ensembl.txt | sed '/---/d' > sorted_public_data4_genelist.txt

# sorted_public_data4_genelist.txtとsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -i -a 1 -o 1.1,2.1 -e "---" -1 1 -2 2 <(cat sorted_public_data4_genelist.txt | awk -F" " '{print $3}' | sort | uniq ) sorted_KEGG_ID_list.txt > data4_KEGG_ID_all.txt

wc data4_KEGG_ID_all.txt
## 305     610    4753 data4_KEGG_ID_all.txt

# sorted_public_data4.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -o 1.1,2.1 -1 1 -2 2 <(cat sorted_public_data4_genelist.txt | awk -F" " '{print $3}' | sort | uniq ) sorted_KEGG_ID_list.txt > data4_KEGG_ID.txt

wc data4_KEGG_ID.txt
## 286     572    4483 data4_KEGG_ID.txt

# sorted_public_data4.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -1 1 -2 2 -a 1 -v 1 <(cat sorted_public_data4_genelist.txt | awk -F" " '{print $3}' | sort | uniq ) sorted_KEGG_ID_list.txt > data4_NO_KEGG_ID.txt

wc data4_NO_KEGG_ID.txt
## 19      19     194 data4_NO_KEGG_ID.txt

# data4_KEGG_ID.txtとlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data4_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data4_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data4_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data4_lipid_genes.txt

# 脂質代謝関連遺伝子
cat data4_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
##  3       3      17
