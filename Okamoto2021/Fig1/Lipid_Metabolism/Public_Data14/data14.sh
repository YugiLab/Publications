# Comparing Control and Schizophrenic hiPSC-derived Neurons (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE25673)

# GSE25673_fold_change_analysis_pval005.txtの4列目(Gene Symbol)を抽出、ソートしてsorted_public_data14.txtとして保存する．
cat GSE25673_fold_change_analysis_pval005.txt | awk -F"\t" 'NR>1{print $4}' | sed '/^$/d' | sort -b -f | uniq > sorted_public_data14.txt

# sorted_public_data14.txtの1列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -t$'\t' -i -a 1 -o 1.1,2.1 -e "---" -1 1 -2 2 sorted_public_data14.txt sorted_KEGG_ID_list.txt > data14_KEGG_ID_all.txt
wc data14_KEGG_ID_all.txt
## 1945    3890   30137 data14_KEGG_ID_all.txt

# sorted_public_data14.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -t$'\t' -i -o 1.1,2.1 -1 1 -2 2 sorted_public_data14.txt sorted_KEGG_ID_list.txt > data14_KEGG_ID.txt
wc data14_KEGG_ID.txt
## 1622    3244   26174 data14_KEGG_ID.txt

# sorted_public_data14.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -t$'\t' -i -1 1 -2 2 -a 1 -v 1 sorted_public_data14.txt sorted_KEGG_ID_list.txt > data14_NO_KEGG_ID.txt
wc data14_NO_KEGG_ID.txt
## 323     323    2671 data14_NO_KEGG_ID.txt

# data14_KEGG_ID.txtの2列目とlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 <(sort -t : -k 2 data14_KEGG_ID.txt) sorted_lipid_enzyme_list.txt > data14_lipid_genes.txt

# 脂質代謝関連遺伝子の個数
cat data14_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 34      34     221
