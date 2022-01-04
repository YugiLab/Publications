## data15_DEG.txtをソートしてsorted_public_data15.txtとして保存する．
cat data15_DEG.txt | sort | uniq > aaa.txt
tr -d "\r" <aaa.txt >sorted_public_data15_genelist.txt
rm aaa.txt

# Ensembl IDを遺伝子名に変換する
#cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
#gjoin -a 1 -o 1.1,2.1,2.2 -e "---" -1 1 -2 1 sorted_public_data4.txt sorted_ensembl.txt | sed '/---/d' > sorted_public_data4_genelist.txt

# sorted_public_data15_genelist.txtとsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -a 1 -o 1.1,2.1 -e "---" -1 1 -2 2 sorted_public_data15_genelist.txt <(cat sorted_KEGG_ID_list.txt | sort -k2 | uniq) > data15_KEGG_ID_all.txt

wc data15_KEGG_ID_all.txt
##  24      48     390 data15_KEGG_ID_all.txt

# sorted_public_data15.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -o 1.1,2.1 -1 1 -2 2 sorted_public_data15_genelist.txt <(cat sorted_KEGG_ID_list.txt | sort -k2 | uniq) > data15_KEGG_ID.txt

wc data15_KEGG_ID.txt
##  13      26     233 data15_KEGG_ID.txt

# sorted_public_data15.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -1 1 -2 2 -a 1 -v 1 sorted_public_data15_genelist.txt <(cat sorted_KEGG_ID_list.txt | sort -k2 | uniq) > data15_NO_KEGG_ID.txt

wc data15_NO_KEGG_ID.txt
##  11      10     110 data15_NO_KEGG_ID.txt

# data15_KEGG_ID.txtとlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data15_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data15_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data15_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data15_lipid_genes.txt

# 脂質代謝関連遺伝子
cat data15_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
##  0       0       0
