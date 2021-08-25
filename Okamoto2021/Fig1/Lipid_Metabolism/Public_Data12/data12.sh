# Molecular profile of parvalbumin-immunoreactive neurons in superior temporal cortex in schizophrenia (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE46509)

# GSE46509_DEG.txtの2列目(Gene symbol)を抽出、ソートしてsorted_public_data12.txtとして保存する．
cat GSE46509_DEG.txt | awk -F"\t" 'NR>2{print $2}' | sed 's/"//g' | awk -F"///" '{print $1}' | sort | uniq > sorted_public_data12.txt

# sorted_public_data12.txtの1列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -i -a 1 -o 1.1,2.1 -e "---" -1 1 -2 2 <(sort -b -f sorted_public_data12.txt) sorted_KEGG_ID_list.txt > data12_KEGG_ID_all.txt
wc data12_KEGG_ID_all.txt
## 797    1594   12674 data12_KEGG_ID_all.txt

# sorted_public_data12.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -o 1.1,2.1 -1 1 -2 2 <(sort -b -f sorted_public_data12.txt) sorted_KEGG_ID_list.txt > data12_KEGG_ID.txt
wc data12_KEGG_ID.txt
## 715    1430   11564 data12_KEGG_ID.txt

# sorted_public_data12.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -1 1 -2 2 -a 1 -v 1 <(sort -b -f sorted_public_data12.txt) sorted_KEGG_ID_list.txt > data12_NO_KEGG_ID.txt
wc data12_NO_KEGG_ID.txt
## 82      88     815 data12_NO_KEGG_ID.txt

# data12_KEGG_ID.txtの2列目とsorted_lipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data12_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data12_KEGG_ID.txt
gjoin -1 2 -2 2 sorted_data12_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data12_lipid_genes.txt

# 脂質代謝関連遺伝子の数
cat data12_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 17      17     108
