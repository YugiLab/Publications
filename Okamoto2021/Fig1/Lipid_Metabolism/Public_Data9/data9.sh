# data9_DEG.txtをソートしてsorted_public_data9.txtとして保存する．
cat data9_DEG.txt | sort | uniq > sorted_public_data9.txt

# Ensembl IDを遺伝子名に変換する
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
gjoin -a 1 -o 1.1,2.1,2.2 -e "---" -1 1 -2 1 sorted_public_data9.txt sorted_ensembl.txt | sed '/---/d' > sorted_public_data9_genelist.txt

# sorted_public_data9_genelist.txtとsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -i -a 1 -o 1.1,2.1 -e "---" -1 1 -2 2 <(cat sorted_public_data9_genelist.txt | awk -F" " '{print $3}' | sort | uniq ) sorted_KEGG_ID_list.txt > data9_KEGG_ID_all.txt

wc data9_KEGG_ID_all.txt
## 568    1136    8706 data9_KEGG_ID_all.txt

# sorted_public_data9.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -o 1.1,2.1 -1 1 -2 2 <(cat sorted_public_data9_genelist.txt | awk -F" " '{print $3}' | sort | uniq ) sorted_KEGG_ID_list.txt > data9_KEGG_ID.txt

wc data9_KEGG_ID.txt
## 411     822    6488 data9_KEGG_ID.txt

# sorted_public_data9.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -1 1 -2 2 -a 1 -v 1 <(cat sorted_public_data9_genelist.txt | awk -F" " '{print $3}' | sort | uniq ) sorted_KEGG_ID_list.txt > data9_NO_KEGG_ID.txt

wc data9_NO_KEGG_ID.txt
## 157     157    1590 data9_NO_KEGG_ID.txt

# data9_KEGG_ID.txtとlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data9_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data9_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data9_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data9_lipid_genes.txt

# 脂質代謝関連遺伝子
cat data9_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 6       6      38
