#
# Data analysis pipeline used in Okamoto _et al_.
#

## Fig 1
### KEGG_scraping
KEGG_scraping contains scripts to obtain KEGG ID lists and lipid enzyme lists for the analysis coming next. Please follow the steps below.

1. Run "get_KEGG_ID_list.sh"
2. Run "get_lipid_enzyme_list.sh"
3. Obtain list of lipid matabolism pathways from KEGG REST(http://rest.kegg.jp/get/br:br08901) and save as "lipid_metabolism_pathways.txt"

### Public_Data
Public_Data contains scripts to extract DEGs from the downloaded transcriptome datasets. Please follow the steps below.

1. Access to each Accession No. page at NCBI GEO Datasets(https://www.ncbi.nlm.nih.gov/gds) and download files of the transcriptome datasets.
2. Run "DEG_Rscripts/data*_DEG.R" to extract DEGs. In case of data12 and data13, we used the authors-defined DEG lists that are presented in their supplemental data.
3. If needed, run "volcano.R" to draw a volcano plot of the DEG.

### Lipid_Metabolism
Lipid_Metabolism contains subdirectories "Public_Data1~15". Each subdirectory contains the files below:
* A csv/tsv file containing the list of DEGs that has been obtained in the step of "Public_Data"
* "data1.sh" ~ "data15.sh", respectively
* "sorted_KEGG_ID_list.txt"
* "lipid_enzyme_list.txt"
* "ensembl_taiouhyou.txt" (not in all directories)
* Various files generated as the result of data processing

The script will process the list of DEGs, link them to KEGG IDs, and extract lipid metabolism genes inside each file directory. In some cases, the Ensembl IDs are converted to Gene Symbols during the process. Please follow the steps below.

1. Make sure that all the files shown above are present in each subdirectory.
2. Run

`$ bash data*.sh`

in each subdirectory.

## Fig 2

### TF_estimation
TF_estimation contains subdirectories "Public_Data1~15". Each subdirectory contains the files below:

* "TF_estimation.sh"
* "Fig2a.sh"
* "Fig3a.sh"
* "dataFIXME_lipid_genes.txt" (FIXME is the number of the public data) is the input gene list of GeneALaCart Query
* "dataFIXME_DEGs.txt" is used to identify and extract DEGs from the estimated TFBSs
* xlsx files containing results of TF estimation via GeneALaCart Query
* csv files containing list of TFs (GHIDs), taken out from the xlsx file with TF estimation results
* Various files generated as the result of data processing

The script will process the list of TFs and output the list of corresponding TFBSs (i.e. extract the GeneHancer ID (GHID) and Transcription factor Binding Site (TFBS) corresponding to each gene from the acquired data.). Please follow the steps below:

1. Enter genelist(lipid metabolism genes identified above) in the Input field of GeneALaCart Query(https://genealacart.genecards.org/Query), with 'GeneHancer' selected as the Requested Data per Gene.
2. Take out the GeneHancer tab from the downloaded data (xlsx file) and save it as "genehancer_dataFIXME.csv"
3. Run

`$ bash TF_estimation.sh FIXME`

(Add number of public data you want to process in FIXME).

4. Enter genelist("dataFIXME_TFBS_DEGs.txt") in the Input field of GeneALaCart Query, with 'GeneHancer' selected as the Requested Data per Gene (Repeat the procedure from step 2.)
5. When done, run

`$ bash Fig2a.sh FIXME > results_dataFIXME.txt`

`$ bash Fig3a.sh FIXME > fig3a_results.txt`

and obtain number of data.
- When taking out the GeneHancer tab from the downloaded data (from Layer2 or more) and saving it, do not forget to save as "genehancer_dataFIXME_depth2.csv"

### Rplot
Rplot contains files for drawing Fig2a~c and consists of the files below:

* fig2a.R
* fig2b_layer1.R
* fig2c_layer2.R

The scripts will generate barplots using R. Please follow the steps below:
1. Run "fig2a.R". (The data in this script comes from "dataFIXME_lipid_genes.txt")
2. Run "fig2b_layer1.R". (The data in this script comes from "dataFIXME_promoter_TFBS_DEGs.txt","dataFIXME_enhancer_TFBS_DEGs.txt","dataFIXME_promoterenhancer_TFBS_DEGs.txt")
3. Run "fig2c_layer2.R". (The data in this script comes from "dataFIXME_promoter_TFBS_DEGs2.txt","dataFIXME_enhancer_TFBS_DEGs2.txt","dataFIXME_promoterenhancer_TFBS_DEGs2.txt")

## Fig 3
### TFTGs_and_TFclasses
TFTGs_and_TFclasses contains subdirectories "Data1~15". Each subdirectory contains the files below:

* target_gene.sh
* README.md
* genehancer_dataFIXME.csv
* genehancer_dataFIXME_depth2.csv
* dataFIXME_TFBS_DEGs.txt
* dataFIXME_TFBS_DEGs2.txt
* dataFIXME_TFBS_list.txt
* dataFIXME_TFBS_list2.txt
* files generated as the result of data processing

The script will link TFs with target genes and generate TF-TG pairs. Please follow the steps below:

1. Make sure that all the files shown above are present in the working directory. You can find these query files under Fig2/TF_estimation/Public_Data*.
2. Run scripts below:  

`$ bash target_gene.sh FIXME`

`$ cd Result`

3. Go to the "PANTHER Tools" tab of http://pantherdb.org, and choose "Gene List Analysis". Next, paste the list of genes (Result/data*_panther.txt) in "Enter IDs" and choose "Homo sapiens" in Select Organism, then submit. To download, push "Send list to file".

4. Run script below to obtain the TF class.  
`$ cat pantherGeneList.txt | awk -F"\t" 'NR>1{print $2"\t"$5}' > dataFIXME_TFclass.txt`

### Rplot
Rplot contains files for drawing Fig3a~c and consists of the files below:
* alldata_TFTGs_count.txt
* alldata_TFTG_merge.py
* alldata_as_matrix_forR.py
* fig3a_data.txt
* fig3a.R
* fig3b_figS2_heatmap.R
* fig3c.csv
* fig3c_barplot.R
* generate_alldata_TFTGs_count.sh
* subdirectories data* that contain the result files of Fig3/TFTGs_and_TFclasses/Data*

The scripts will generate barplot of the number of DEGs in each cluster and heatmap of TF-TG pairs.

1. Make sure that all the files shown above are present in the working directory.
2. Run "fig3a.R" to obtain the graph of Fig.3a.
3. Run

`$ bash generate_TG_lis.sh FIXME`

in each subdirectory dataFIXME to produce dataFIXME_TGs.txt.

4. Run scripts below:  

`$ bash generate_alldata_TFTGs_count.sh`

`$ python alldata_TFTG_mergy.py`

`$ python alldata_as_matrix_forR.py`

5. Run "fig3b_figS2_heatmap.R".(For figS2, the data in this script comes from "FigS2_data/data*_dotplot_matrix_pro_enh.txt".)
6. Run "fig3c_barplot.R".

### enrichment_analysis
The directory enrichment_analysis contains files for enrichment analysis and consists of the files below:
* alldata_TFclass_each_clusters_for_enrichment.txt
* all_TGcluster_appearance_pathway.txt
* Fig3c_cluster_enrichment.py

The scripts will perform enrichment analysis. Please follow the steps below:
1. Make sure that all the files shown above are present in the working directory.
2. Run the script below:

`$ python Fig3c_cluster_enrichment.py FIXME`

where FIXME should be replaced to the number of the cluster of interest.

3. Change the value of the variant 'filename' in Fig3c_cluster_enrichment.py to perform the enrichment analysis of the other query file.

## Fig 4

### Barplot
Barplot contains the file below:
* bar_graph_ggplot.R

"bar_graph_ggplot.R" will generate barplot of the number of DEGs and SNPs associated with DEGs via GTEx v8 eQTL.  

### Heatmap
Heatmap contains the files below:
* fig4a_data.txt
* Fig4a_heatmap.R

The script will generate heatmap of the SNP enrichment analysis.  

Please Run "Fig4a_heatmap.R".

### Dotplot
Dotplot contains the files below:
* graph.csv
* dotplot_with_color.R

The script will generate dorplot of MeSH search results in Pubmed of EFO terms.    

Please Run "dotplot_with_color.R".

## Fig S1
FigS1/KEGG_Pathway_Enrichment contains scripts to perform KEGG pathway enrichment analysis against the KEGG ID-attributed DEGs of each 15 dataset. Follow the steps below to complete the procedure:

1. Copy the KEGG ID list of DEGs located in Fig1/Lipid_Metabolism/Public_DataFIXME and paste it in the same working direcotry as enrich.sh. (The lists have been already collected in FigS1/DEG_lists).
2. Run the scripts below:

`$ bash preproc.sh hsa`

`$ bash enrich.sh hsa <(cat dataFIXME_KEGG_ID.txt | cut -d" " -f3 | sort | uniq) ./Data/hsa_non_disease_pathway_list.txt dataFIXME_enrich_non_disease.txt`

Please change the value of the -f option of `cut` according to the position of KEGG ID column in dataFIXME_KEGG_ID.txt.

3. Run "pathway_enrichment.R" in FigS1/Rplot against the 15 output files of Step2.

## Fig S3

Fig S3 contains the file below:
* XGR.R
* subdirectory list_of_SNPs

1. Download GTEx_Analysis_v8_eQTL.tar and GTEx_Analysis_2017-06-05_v8_WholeGenomeSeq_838Indiv_Analysis_Freeze.lookup_table.txt.gz from GTEx Portal (https://gtexportal.org/).
2. Decompress downloaded files to the same working directory as eQTL_SNP.sh.
3. Copy dataFIXME_TFBS_depth1.txt and dataFIXME_TFBS_depth2.txt from Fig2/TF_estimation/Public_DataFIXME and paste them to the same working directory as eQTL_SNP.sh.
4. Run

`$ bash eQTL_SNP.sh FIXME`

and you will obtain dataFIXME_SNPs_only.txt that contains the list of identified SNP rs IDs.

5. Run "XGR.R" and you can perform enrichment analysis of SNPs.  
