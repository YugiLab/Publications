# Comparing Control and Schizophrenic hiPSC-derived NPCs (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE40102)

# GSE40102_analysis_DEG.csvの2行目以降の4列目のGene.Symbol)と15列目のFoldChange抽出、ソートしてsorted_public_data3.txtとして保存する．
cat GSE40102_analysis_DEG_tsv.tsv | awk -F"\t" 'NR>1{if($4 != "")print $4"\t"$15}' | sed 's/"//g' | sed 's/^[ \t]*//' | grep -v '^\s*\t' | sort -b -f | uniq > sorted_public_data3.txt

# sorted_public_data3.txtの1列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -t $'\t' -i -a 1 -o auto -e "---" -1 1 -2 2 sorted_public_data3.txt sorted_KEGG_ID_list.txt > data3_KEGG_ID_all.txt

wc data3_KEGG_ID_all.txt
## 3445   13519   91749 data3_KEGG_ID_all.txt

# sorted_public_data3.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -t $'\t' -i -1 1 -2 2 sorted_public_data3.txt sorted_KEGG_ID_list.txt > data3_KEGG_ID.txt

wc data3_KEGG_ID.txt
## 2101    6303   51468 data3_KEGG_ID.txt

# sorted_public_data3.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -t $'\t' -i -2 2 -a 1 -v 1 sorted_public_data3.txt sorted_KEGG_ID_list.txt > data3_NO_KEGG_ID.txt

wc data3_NO_KEGG_ID.txt
## 1344    5872   34905 data3_NO_KEGG_ID.txt

# data3_KEGG_ID.txtの3列目とlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data3_KEGG_ID.txt | awk -F " " '{print $1"\t"$3}' | sort -t : -k 2 > sorted_data3_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data3_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data3_lipid_genes.txt

# 脂質代謝関連遺伝子
cat data3_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 29      29     168
