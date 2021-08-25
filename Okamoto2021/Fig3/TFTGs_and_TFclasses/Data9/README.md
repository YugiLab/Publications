## TargetGeneの紐付け
### 必要なファイル: /GitHub/Neurometabolism/TF_estimation/下にある任意のデータのファイルの中から以下の6つ
・genehancer_data[任意のデータ].csv
・genehancer_data[任意のデータ]_depth2.csv
・data[任意のデータ]_TFBS_DEGs.txt
・data[任意のデータ]_TFBS_DEGs2.txt
・data[任意のデータ]_TFBS_list.txt
・data[任意のデータ]_TFBS_list2.txt

### 以下のコマンドを実行
$ bash target_gene.sh [任意のデータの番号]
$ cd Result
$ cat pantherGeneList.txt | awk -F"\t" 'NR>1{print $2"\t"$5}' > data[任意のデータの番号]_TFclass.txt
