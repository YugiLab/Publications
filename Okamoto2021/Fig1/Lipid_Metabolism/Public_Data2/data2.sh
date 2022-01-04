# Genome-wide transcriptome profiles in Control and Schizophrenia hiPSC-dervied NPC [RNA-seq] (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE92874)

# GSE92874_RNA_DEG.csvの2列目(Gene)と11列目のlog_2_fold_changeを抽出、ソートしてsorted_public_data2.txtとして保存する．
cat data2_DEG.csv | awk -F"," 'NR>1{print $2"\t"$11}' | sed 's/"//g' | sort -b -f | uniq > sorted_public_data2.txt

# sorted_public_data2.txtの1列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -i -a 1 -o auto -e "---" -2 2 sorted_public_data2.txt sorted_KEGG_ID_list.txt > data2_KEGG_ID_all.txt

wc data2_KEGG_ID_all.txt
## 1443    4329   34948 data2_KEGG_ID_all.txt

# sorted_public_data2.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -2 2 sorted_public_data2.txt sorted_KEGG_ID_list.txt > data2_KEGG_ID.txt

wc data2_KEGG_ID.txt
## 1415    4248   34376 data2_KEGG_ID.txt

# sorted_public_data2.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -2 2 -a 1 -v 1 sorted_public_data2.txt sorted_KEGG_ID_list.txt > data2_NO_KEGG_ID.txt

wc data2_NO_KEGG_ID.txt
## 28      56     491 data2_NO_KEGG_ID.txt

# data2_KEGG_ID.txtの3列目とlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data2_KEGG_ID.txt | sort -t : -k 2 | awk -F" " '{print $1"\t"$3}' > sorted_data2_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data2_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data2_lipid_genes.txt

## 脂質代謝関連遺伝子
cat data2_lipid_genes.txt | awk '{print $2}' | sort | uniq | wc
## 37      37     223
