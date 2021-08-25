# p_005.csvの5行目の遺伝子名と34行目のfoldchangeを抽出、sortしてgene_foldchange.txtとして保存する．
cat p_005.csv | awk -F"," 'NR>1{print $5"\t"$34}'| sed 's/"//g'| sort | uniq > gene_foldchange.txt

# gene_foldchange.txtの1列目とsorted_KEGG_ID_list.txtの2列目をjoinコマンドで結合し，対応するKEGG IDがある遺伝子にはそのIDを，対応するKEGG IDがない遺伝子には---を表示する．
gjoin -i -a 1 -o auto -e "---" -1 1 -2 2 gene_foldchange.txt sorted_KEGG_ID_list.txt > all_KEGG_ID_foldchange.txt

## gene_foldchange.txtのGeneのうち、対応するKEGG　IDがあるもの．
gjoin -i -1 1 -2 2 gene_foldchange.txt sorted_KEGG_ID_list.txt > KEGG_ID_foldchange.txt

## gene_foldchange.txtのGeneうち、対応するKEGG IDがなかったもの．
gjoin -i -1 1 -2 2 -a 1 -v 1 gene_foldchange.txt sorted_KEGG_ID_list.txt > no_KEGG_ID_foldchange.txt

# KEGG_ID_foldchange.txtのfoldchangeが1以上のgeneのKEGG IDを抽出し、2列目にredと書く．
cat KEGG_ID_foldchange.txt | awk -F" " '($2 > 1){print}'| awk -F" " '{print $3"\t""red"}' > KEGG_mapper.txt

# KEGG_ID_foldchange.txtのfoldchangeが1以下のgeneのKEGG IDを抽出し、2列目にblueと書く．
cat KEGG_ID_foldchange.txt | awk -F" " '($2 < 1){print}'| awk -F" " '{print $3"\t""blue"}' >> KEGG_mapper.txt

# KEGG MAPPER( https://www.kegg.jp/kegg/tool/map_pathway2.html )にKEGG_mapper.txtをuploadし、Include aliasesとUse uncolored diagramsにチェックする．Execを押した後、hsa01100 Metabolic pathways - Homo sapiens (human)のマップを選択する。
