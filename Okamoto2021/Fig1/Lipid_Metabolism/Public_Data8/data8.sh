## data8_DEG.txtをソートしてsorted_public_data8.txtとして保存する．
cat data8_DEG.txt | sort | uniq > aaa.txt
tr -d "\r" <aaa.txt >sorted_public_data8_genelist.txt
rm aaa.txt

# sorted_public_data8_genelist.txtとsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -a 1 -o 1.1,2.1 -e "---" -1 1 -2 2 sorted_public_data8_genelist.txt <(cat sorted_KEGG_ID_list.txt | sort -k2 | uniq) > data8_KEGG_ID_all.txt

wc data8_KEGG_ID_all.txt
##  114     228    1727 data8_KEGG_ID_all.txt

# sorted_public_data8.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -o 1.1,2.1 -1 1 -2 2 sorted_public_data8_genelist.txt <(cat sorted_KEGG_ID_list.txt | sort -k2 | uniq) > data8_KEGG_ID.txt

wc data8_KEGG_ID.txt
##  101     202    1566 data8_KEGG_ID.txt

# sorted_public_data8.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -1 1 -2 2 -a 1 -v 1 sorted_public_data8_genelist.txt <(cat sorted_KEGG_ID_list.txt | sort -k2 | uniq) > data8_NO_KEGG_ID.txt

wc data8_NO_KEGG_ID.txt
##  13      12     106 data8_NO_KEGG_ID.txt

# data8_KEGG_ID.txtとlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data8_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data8_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data8_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data8_lipid_genes.txt

# 脂質代謝関連遺伝子
cat data8_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
##  0       0       0
