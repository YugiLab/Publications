# RNA-seq in neurons derived from iPSCs in controls and patients with schizophrenia and 22q11 del (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE46562)

# GSE46562_FPKM_expression_table_DEG.csvの2列目(Ensembl ID)と22列目のFoldChangeを抽出、ソートしてsorted_public_data5.txtとして保存する．
cat GSE46562_FPKM_expression_table_DEG.csv | awk -F"," 'NR>1{print $2"|"$22}' | sed 's/"//g' | awk -F"|" '{print $3"\t"$4}' | sort -b -f | uniq > sorted_public_data6.txt

# sorted_public_data5.txtの1列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -t$'\t' -i -a 1 -o 1.1,1.2,2.1 -e "---" -1 1 -2 2 sorted_public_data6.txt sorted_KEGG_ID_list.txt > data6_KEGG_ID_all.txt
wc data6_KEGG_ID_all.txt
## 391    1173   12955 data5_KEGG_ID_all.txt

# sorted_public_data6.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -t$'\t' -i -o 1.1,2.1 -1 1 -2 2 sorted_public_data6.txt sorted_KEGG_ID_list.txt > data6_KEGG_ID.txt
wc data6_KEGG_ID.txt
## 311     622    5022 data6_KEGG_ID.txt

# sorted_public_data6.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -t$'\t' -i -1 1 -2 2 -a 1 -v 1 sorted_public_data6.txt sorted_KEGG_ID_list.txt > data6_NO_KEGG_ID.txt
wc data6_NO_KEGG_ID.txt
## 80     160    2235 data6_NO_KEGG_ID.txt

# data6_KEGG_ID.txtの2列目とlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data6_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data6_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data6_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data6_lipid_genes.txt

# 脂質代謝関連遺伝子
cat data6_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 8       8      46
