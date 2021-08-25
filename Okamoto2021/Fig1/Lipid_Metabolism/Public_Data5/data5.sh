# Genome-wide transcriptional analysis of human iPSC-derived healthy control vs. schizophrenia cortical interneurons (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE121376)

# GSE121376_TPM_14pairs_DEG.csvの2列目(Ensembl ID)と59列目のFoldChangeを抽出、ソートしてsorted_public_data5.txtとして保存する．
cat GSE121376_TPM_14pairs_DEG.csv | awk -F"," 'NR>1{print $2"\t"$59}' | sed 's/"//g' | sort | uniq > sorted_public_data5.txt

# Ensembl IDを遺伝子名に変換する
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
cat sorted_public_data5.txt | sort -k 1 | uniq > sorted_public_data5_2.txt
gjoin -a 1 -o 1.1,1.2,2.2 -e "---" -1 1 -2 1 sorted_public_data5_2.txt sorted_ensembl.txt | sed '/---/d' > sorted_public_data5_genelist.txt

# sorted_public_data5_genelist.txtの3列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -i -a 1 -o 1.3,1.2,2.1 -e "---" -1 3 -2 2 <(sort -k 3 sorted_public_data5_genelist.txt) sorted_KEGG_ID_list.txt > data5_KEGG_ID_all.txt

wc data5_KEGG_ID_all.txt
## 1121    3363   37820 data5_KEGG_ID_all.txt

# sorted_public_data5.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -o 1.3,1.2,2.1 -1 3 -2 2 <(sort -k 3 sorted_public_data5_genelist.txt) sorted_KEGG_ID_list.txt > data5_KEGG_ID.txt

wc data5_KEGG_ID.txt
## 1029    3087   34989 data5_KEGG_ID.txt

# sorted_public_data5.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -1 3 -2 2 -a 1 -v 1 <(sort -k 3 sorted_public_data5_genelist.txt) sorted_KEGG_ID_list.txt > data5_NO_KEGG_ID.txt

wc data5_NO_KEGG_ID.txt
## 92     276    3935 data5_NO_KEGG_ID.txt

# data5_KEGG_ID.txtの3列目とlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data5_KEGG_ID.txt | awk -F" " '{print $1"\t"$3}' | sort -t : -k 2 > sorted_data5_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data5_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data5_lipid_genes.txt

# 脂質代謝関連遺伝子
cat data5_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 30      30     189
