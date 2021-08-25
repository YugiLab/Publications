head -1 GSE25673_fold_change_analysis.txt > GSE25673_fold_change_analysis_pval005.txt
awk -F"\t" '($6<0.05){ print}' GSE25673_fold_change_analysis.txt >> GSE25673_fold_change_analysis_pval005.txt
