# Genome-wide transcriptional analysis of human iPSC-derived healthy control vs. schizophrenia cortical interneurons. (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE125999)

# GSE125999_TPM_15pair_DEGnew.csvの2列目(Ensembl ID)と63列目のFoldChangeを抽出、ソートしてsorted_public_data1.txtとして保存する．
cat GSE125999_TPM_15pair_DEG_new.csv | awk -F"," 'NR>1{print $2"\t"$63}' | sed 's/"//g' | sort | uniq > sorted_public_data1.txt

# Ensembl IDを遺伝子名に変換する
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
cat sorted_public_data1.txt | sort -k 1 | uniq > sorted_public_data1_2.txt
gjoin -a 1 -o 1.1,1.2,2.2 -e "---" -1 1 -2 1 sorted_public_data1_2.txt sorted_ensembl.txt | sed '/---/d' > sorted_public_data1_genelist.txt

# sorted_public_data1_genelist.txtの3列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．

gjoin -i -a 1 -o 1.3,1.2,2.1 -e "---" -1 3 -2 2 <(sort -k 3 sorted_public_data1_genelist.txt) sorted_KEGG_ID_list.txt > data1_KEGG_ID_all.txt

wc data1_KEGG_ID_all.txt


# sorted_public_data1.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -o 1.3,1.2,2.1 -1 3 -2 2 <(sort -k 3 sorted_public_data1_genelist.txt) sorted_KEGG_ID_list.txt > data1_KEGG_ID.txt

wc data1_KEGG_ID.txt


# sorted_public_data1.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -1 3 -2 2 -a 1 -v 1 <(sort -k 3 sorted_public_data1_genelist.txt) sorted_KEGG_ID_list.txt > data1_NO_KEGG_ID.txt

wc data1_NO_KEGG_ID.txt


# data1_KEGG_ID.txtの3列目とlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data1_KEGG_ID.txt | awk -F" " '{print $1"\t"$3}' | sort -t : -k 2 > sorted_data1_KEGG_ID.txt
cat lipid_enzyme_list.txt | sort -t : -k 3 | sed  '/^$/d' > sorted_lipid_enzyme_list.txt
gjoin -1 2 -2 2 sorted_data1_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data1_lipid_genes.txt

# 脂質代謝関連遺伝子の個数
cat data1_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc

