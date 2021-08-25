# Transcriptional signatures of schizophrenia in hiPSC-derived NPCs and neurons are concordant with signatures from post mortem adult brains (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE106589)

# GSE106589_geneCounts_DEG.csvの2列目(Ensembl ID)と97列目のFoldChangeを抽出、ソートしてsorted_public_data9.txtとして保存する．
cat GSE106589_geneCounts_DEG.csv | awk -F"," 'NR>1{print $2"\t"$97}' | sed 's/"//g' | sort | uniq > sorted_public_data9.txt

# Ensembl IDを遺伝子名に変換する
cat ensembl_taiouhyou.txt | awk -F" " '{print $1"\t"$2}' | sort -k 1 | uniq > sorted_ensembl.txt
cat sorted_public_data9.txt | sort -k 1 | uniq > sorted_public_data9_2.txt
gjoin -a 1 -o 1.1,1.2,2.2 -e "---" -1 1 -2 1 sorted_public_data9_2.txt sorted_ensembl.txt | sed '/---/d' > sorted_public_data9_genelist.txt

# sorted_public_data9_genelist.txtの3列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -i -a 1 -o 1.3,1.2,2.1 -e "---" -1 3 -2 2 <(sort -b -f -k 3 sorted_public_data9_genelist.txt) sorted_KEGG_ID_list.txt > data9_KEGG_ID_all.txt
wc data9_KEGG_ID_all.txt
## 2522    7566   84149 data9_KEGG_ID_all.txt

# sorted_public_data9.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -o 1.3,1.2,2.1 -1 3 -2 2 <(sort -b -f -k 3 sorted_public_data9_genelist.txt) sorted_KEGG_ID_list.txt > data9_KEGG_ID.txt
wc data9_KEGG_ID.txt
## 1940    5820   65926 data9_KEGG_ID.txt

# sorted_public_data4.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -1 3 -2 2 -a 1 -v 1 <(sort -b -f -k 3 sorted_public_data9_genelist.txt) sorted_KEGG_ID_list.txt > data9_NO_KEGG_ID.txt
wc data9_NO_KEGG_ID.txt
## 582    1746   25207 data9_NO_KEGG_ID.txt

# data9_KEGG_ID.txtの3列目とsorted_lipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data9_KEGG_ID.txt | awk -F" " '{print $1"\t"$3}' | sort -t : -k 2 > sorted_data9_KEGG_ID.txt
gjoin -1 2 -2 2 sorted_data9_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data9_lipid_genes.txt

# 脂質代謝関連遺伝子
cat data9_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 59      59     362
