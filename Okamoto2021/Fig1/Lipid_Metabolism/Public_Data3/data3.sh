# data3_DEG.txtをソートしてsorted_public_data3.txtとして保存する．
cat data3_DEG.txt | sort | uniq > aaa.txt
tr -d "\r" <aaa.txt >sorted_public_data3_genelist.txt
rm aaa.txt

# sorted_public_data3_genelist.txtとsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -t $'\t' -a 1 -o 1.1,2.1 -e "---" -1 1 -2 2 sorted_public_data3_genelist.txt <(cat sorted_KEGG_ID_list.txt | sort -k2 | uniq ) > data3_KEGG_ID_all.txt

wc data3_KEGG_ID_all.txt

# sorted_public_data3.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -t $'\t' -o 1.1,2.1 -1 1 -2 2 sorted_public_data3_genelist.txt <(cat sorted_KEGG_ID_list.txt | sort -k2 | uniq ) > data3_KEGG_ID.txt

wc data3_KEGG_ID.txt

# sorted_public_data3.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -t $'\t' -1 1 -2 2 -a 1 -v 1 sorted_public_data3_genelist.txt <(cat sorted_KEGG_ID_list.txt | sort -k2 | uniq ) > data3_NO_KEGG_ID.txt

wc data3_NO_KEGG_ID.txt

# data3_KEGG_ID.txtとlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data3_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data3_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data3_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data3_lipid_genes.txt

# 脂質代謝関連遺伝子
cat data3_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
