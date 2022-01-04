## data6_DEG.txtをソートして1行目と小数点以降を除き、sorted_public_dat6.txtとして保存する．
tr -d "\r" <data6_DEG.txt >aaa.txt
sed -e '1d' aaa.txt | sort | uniq | sed 's/[.].*//' > sorted_public_data6.txt
rm aaa.txt

# Ensembl IDを遺伝子名に変換する
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
gjoin -a 1 -o 1.1,2.2 -e "---" -1 1 -2 1 sorted_public_data6.txt sorted_ensembl.txt | sed '/---/d' > sorted_public_data6_genelist.txt

# sorted_public_data6_genelist.txtとsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -a 1 -o 1.2,2.1 -e "---" -1 2 -2 2 <(cat sorted_public_data6_genelist.txt | sort -k2 | uniq ) <(cat sorted_KEGG_ID_list.txt | sort -k2 | uniq) > data6_KEGG_ID_all.txt

wc data6_KEGG_ID_all.txt
##  791    1582   12661 data6_KEGG_ID_all.txt

# sorted_public_data6.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -o 1.2,2.1 -1 2 -2 2 <(cat sorted_public_data6_genelist.txt | sort -k2| uniq ) <(cat sorted_KEGG_ID_list.txt | sort -k2 | uniq) > data6_KEGG_ID.txt

wc data6_KEGG_ID.txt
##  707    1414   11443 data6_KEGG_ID.txt

# sorted_public_data6.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -1 2 -2 2 -a 1 -v 1 <(cat sorted_public_data6_genelist.txt | sort -k2| uniq ) <(cat sorted_KEGG_ID_list.txt | sort -k2 | uniq) > data6_NO_KEGG_ID.txt

wc data6_NO_KEGG_ID.txt
##  84     168    2226 data6_NO_KEGG_ID.txt

# data6_KEGG_ID.txtとlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data6_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data6_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data6_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data6_lipid_genes.txt

# 脂質代謝関連遺伝子
cat data6_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
##  11      11      65
