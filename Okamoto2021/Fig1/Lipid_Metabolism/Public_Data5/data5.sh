
# data5_DEG.txtをソートしてsorted_public_data5.txtとして保存する．
cat data5_DEG.txt | sort | uniq > sorted_public_data5.txt

# Ensembl IDを遺伝子名に変換する
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
gjoin -a 1 -o 1.1,2.1,2.2 -e "---" -1 1 -2 1 sorted_public_data5.txt sorted_ensembl.txt | sed '/---/d' > sorted_public_data5_genelist.txt

# sorted_public_data5_genelist.txtとsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -i -a 1 -o 1.1,2.1 -e "---" -1 1 -2 2 <(cat sorted_public_data5_genelist.txt | awk -F" " '{print $3}' | sort | uniq ) sorted_KEGG_ID_list.txt > data5_KEGG_ID_all.txt

wc data5_KEGG_ID_all.txt
## 252     504    3924 data5_KEGG_ID_all.txt

# sorted_public_data5.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -o 1.1,2.1 -1 1 -2 2 <(cat sorted_public_data5_genelist.txt | awk -F" " '{print $3}' | sort | uniq ) sorted_KEGG_ID_list.txt > data5_KEGG_ID.txt

wc data5_KEGG_ID.txt
## 235     470    3686 data5_KEGG_ID.txt

# sorted_public_data5.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -1 1 -2 2 -a 1 -v 1 <(cat sorted_public_data5_genelist.txt | awk -F" " '{print $3}' | sort | uniq ) sorted_KEGG_ID_list.txt > data5_NO_KEGG_ID.txt

wc data5_NO_KEGG_ID.txt
## 17      17     170 data5_NO_KEGG_ID.txt

# data5_KEGG_ID.txtとlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data5_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data5_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data5_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data5_lipid_genes.txt

# 脂質代謝関連遺伝子
cat data5_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
##  1       1       5
