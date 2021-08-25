# Next Generation Sequencing Facilitates Comparisons of Control and Schizophrenia-Patient derived hiPSC-derived neurons (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE63734)

# GSE63734_SCZ_Neurons.ucsc.Clean_DEG.csvの2列目(Gene Feature)と14列目のFoldChangeを抽出、ソートしてsorted_public_data8.txtとして保存する．
cat GSE63734_SCZ_Neurons.ucsc.Clean_DEG.csv | awk -F"," 'NR>1{print $2"\t"$14}' | sed 's/"//g' | sort | uniq > sorted_public_data8.txt

# sorted_public_data8.txtの1列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -i -a 1 -o 1.1,1.2,2.1 -e "---" -1 1 -2 2 sorted_public_data8.txt sorted_KEGG_ID_list.txt > data8_KEGG_ID_all.txt
wc data8_KEGG_ID_all.txt
## 578    1734   18898 data8_KEGG_ID_all.txt

# sorted_public_data8.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -o 1.1,2.1 -1 1 -2 2 sorted_public_data8.txt sorted_KEGG_ID_list.txt > data8_KEGG_ID.txt
wc data8_KEGG_ID.txt
## 519    1038    8483 data8_KEGG_ID.txt

# sorted_public_data8.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -1 1 -2 2 -a 1 -v 1 sorted_public_data8.txt sorted_KEGG_ID_list.txt > data8_NO_KEGG_ID.txt
wc data8_NO_KEGG_ID.txt
## 59     118    1529 data8_NO_KEGG_ID.txt

# data8_KEGG_ID.txtの2列目とsorted_lipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data8_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data8_KEGG_ID.txt
gjoin -1 2 -2 2 sorted_data8_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data8_lipid_genes.txt

# 脂質代謝関連遺伝子
cat data8_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 9       9      58
