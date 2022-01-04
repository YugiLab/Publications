# Comparison of post-mortem tissue from Brodman Brain BA22 region between schizophrenic and control patients (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE21935)

# data13_DEG.txtの1列目(HUGO symbol)を抽出、ソートしてsorted_public_data13.txtとして保存する．
cat data13_DEG.txt | awk -F"," 'NR>1{print $1}' | sort | uniq > sorted_public_data13.txt

# sorted_public_data13.txtの改行コードがCRLF (= \r\n)だったので\nに変更し、sorted_public_data13_2.txtとして保存する．
tr -d "\r" < sorted_public_data13.txt > sorted_public_data13_2.txt

# sorted_public_data13_2.txtの1列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -i -a 1 -o 1.1,2.1 -e "---" -1 1 -2 2 <(sort -k 3 sorted_public_data13_2.txt) sorted_KEGG_ID_list.txt > data13_KEGG_ID_all.txt
wc data13_KEGG_ID_all.txt
## 56     112     904 data13_KEGG_ID_all.txt

# sorted_public_data13_2.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -o 1.1,2.1 -1 1 -2 2 <(sort -k 3 sorted_public_data13_2.txt) sorted_KEGG_ID_list.txt > data13_KEGG_ID.txt
wc data13_KEGG_ID.txt
## 55     110     895 data13_KEGG_ID.txt

# sorted_public_data13_2.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -1 1 -2 2 -a 1 -v 1 <(sort -k 3 sorted_public_data13_2.txt) sorted_KEGG_ID_list.txt > data13_NO_KEGG_ID.txt
wc data13_NO_KEGG_ID.txt
## 1       1       5 data13_NO_KEGG_ID.txt

# data13_KEGG_ID.txtの2列目とsorted_lipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data13_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data13_KEGG_ID.txt
gjoin -1 2 -2 2 sorted_data13_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data13_lipid_genes.txt

# 脂質代謝関連遺伝子の数
cat data13_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 0       0       0
