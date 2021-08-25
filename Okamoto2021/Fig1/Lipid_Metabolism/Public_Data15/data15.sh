# Genome-wide transcriptional analysis of human iPSC-derived healty control vs. schizophrenia cortical interneurons. ( https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE118313 )

# p_005.csvの5列目(symbol)の2行目を抽出、ソートしてsorted_public_data.txtとして保存する．
cat p_005.csv | awk -F"," 'NR>1{print $5}' | sed 's/"//g' | sort -b -f | uniq > sorted_p_005.txt

# sorted_p_005.txtの1列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -i -a 1 -o auto -e "---" -2 2 sorted_p_005.txt sorted_KEGG_ID_list.txt > p_005_KEGG_ID_all.txt

# sorted_p_005.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -2 2 sorted_p_005.txt sorted_KEGG_ID_list.txt > P_005_KEGG_ID.txt

# sorted_public_data1.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -2 2 -a 1 -v 1 sorted_p_005.txt sorted_KEGG_ID_list.txt > P_005_NO_KEGG_ID.txt

# P_005_KEGG_ID.txtの2列目とlipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
gjoin -1 2 -2 2 <(cat P_005_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2) <(sort -t : -k 3 lipid_enzyme_list.txt) > P_005_lipid_genes.txt

# 脂質代謝関連遺伝子はなし
cat P_005_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 20      20     133
