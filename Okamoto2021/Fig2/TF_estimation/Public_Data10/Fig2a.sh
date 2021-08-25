#!/bin/bash

DataNo=$1
echo "Public Data${DataNo}"

# Information for Fig2a_TFBSnumbers_layer1.txt
echo "The number of TFBSs within promoter region on layer1."
wc data"${DataNo}"_promoter_TFBS_DEGs.txt
echo "The number of TFBSs within enhancer region on layer1."
wc data"${DataNo}"_enhancer_TFBS_DEGs.txt
echo "The number of TFBSs within promoter/enhancer region on layer1."
wc data"${DataNo}"_promoterenhancer_TFBS_DEGs.txt

# Information for Fig2a_TFBSnumbers_layer2.txt
echo "The number of TFBSs within promoter region on layer2."
wc data"${DataNo}"_promoter_TFBS_DEGs2.txt
echo "The number of TFBSs within enhancer region on layer2"
wc data"${DataNo}"_enhancer_TFBS_DEGs2.txt
echo "The number of TFBSs within promoter/enhancer region on layer2."
wc data"${DataNo}"_promoterenhancer_TFBS_DEGs2.txt

# Information for Fig2a_TFBStypes_layer1.txt
echo "The number of TFBSs within promoter region or enhancer region on layer1."
wc data"${DataNo}"_TFBS_DEGs.txt
# Information for Fig2a_TFBStypes_layer2.txt
echo "The number of TFBSs within promoter region or enhancer region on layer2."
wc data"${DataNo}"_TFBS_DEGs2.txt

