# Pilot transcriptome analysis of human iPSC-derived healthy control vs. schizophrenia cortical interneurons (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE125805)

# GSE125805_TPM_9pairs_DEG.csvの2列目(Ensembl ID)と63列目のFoldChangeを抽出、ソートしてsorted_public_data3.txtとして保存する．
cat GSE125805_TPM_9pairs_DEG.csv | awk -F"," 'NR>1{print $2"\t"$21}' | sed 's/"//g' | sort -b -f | uniq > sorted_public_data4.txt

# Ensembl IDを遺伝子名に変換する
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
cat sorted_public_data4.txt | sort -k 1 | uniq > sorted_public_data4_2.txt
gjoin -a 1 -o 1.1,1.2,2.2 -e "---" -1 1 -2 1 sorted_public_data4_2.txt sorted_ensembl.txt | sed '/---/d' > sorted_public_data4_genelist.txt

# sorted_public_data4_genelist.txtの3列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．

gjoin -i -a 1 -o 1.3,1.2,2.1 -e "---" -1 3 -2 2 <(sort -k 3 sorted_public_data4_genelist.txt) sorted_KEGG_ID_list.txt > data4_KEGG_ID_all.txt

wc data4_KEGG_ID_all.txt
## 406    1218   13405 data4_KEGG_ID_all.txt

# sorted_public_data4.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -o 1.3,1.2,2.1 -1 3 -2 2 <(sort -k 3 sorted_public_data4_genelist.txt) sorted_KEGG_ID_list.txt > data4_KEGG_ID.txt

wc data4_KEGG_ID.txt
## 370    1110   12300 data4_KEGG_ID.txt

# sorted_public_data4.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -1 3 -2 2 -a 1 -v 1 <(sort -k 3 sorted_public_data4_genelist.txt) sorted_KEGG_ID_list.txt > data4_NO_KEGG_ID.txt

wc data4_NO_KEGG_ID.txt
## 36     108    1537 data4_NO_KEGG_ID.txt

# data4_KEGG_ID.txtの3列目とlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data4_KEGG_ID.txt | awk -F" " '{print $1"\t"$3}' | sort -t : -k 2 > sorted_data4_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data4_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data4_lipid_genes.txt

# 脂質代謝関連遺伝子
cat data4_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 10      10      60
