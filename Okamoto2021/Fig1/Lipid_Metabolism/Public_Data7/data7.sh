# Next Generation Sequencing Facilitates Comparisons of Control and Schizophrenia-Patient derived hiPSC-derived NPCs (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE63738)

# GSE63738_SCZ_NPC.ucsc.Clean_DEG.csvの2列目(Gene Feature)と15列目のFoldChangeを抽出、ソートしてsorted_public_data7.txtとして保存する．
cat GSE63738_SCZ_NPC.ucsc.Clean_DEG.csv | awk -F"," 'NR>1{print $2"\t"$15}' | sed 's/"//g' | sort | uniq > sorted_public_data7.txt

# sorted_public_data7.txtの1列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -i -a 1 -o 1.1,1.2,2.1 -e "---" -1 1 -2 2 sorted_public_data7.txt sorted_KEGG_ID_list.txt > data7_KEGG_ID_all.txt
wc data7_KEGG_ID_all.txt
## 674    2022   22382 data7_KEGG_ID_all.txt

# sorted_public_data7.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -o 1.1,2.1 -1 1 -2 2 sorted_public_data7.txt sorted_KEGG_ID_list.txt > data7_KEGG_ID.txt
wc data7_KEGG_ID.txt
## 620    1240   10049 data7_KEGG_ID.txt

# sorted_public_data7.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -1 1 -2 2 -a 1 -v 1 sorted_public_data7.txt sorted_KEGG_ID_list.txt > data7_NO_KEGG_ID.txt

wc data7_NO_KEGG_ID.txt
## 54     108    1462 data7_NO_KEGG_ID.txt

# data7_KEGG_ID.txtの2列目とsorted_lipid_enzyme_list.txtの2列目をjoinコマンドで結合し、KEGGの脂質代謝パスウェイマップ上にあるGeneを特定する．
cat data7_KEGG_ID.txt | awk -F" " '{print $1"\t"$2}' | sort -t : -k 2 > sorted_data7_KEGG_ID.txt
gjoin -1 2 -2 2 sorted_data7_KEGG_ID.txt sorted_lipid_enzyme_list.txt > data7_lipid_genes.txt

# 脂質代謝関連遺伝子の個数
cat data7_lipid_genes.txt | awk -F" " '{print $2}' | sort | uniq | wc
## 8       8      49
