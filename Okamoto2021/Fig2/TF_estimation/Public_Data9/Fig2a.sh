#!/bin/bash

DataNo=$1
echo "Public Data${DataNo}"

#以下Fig2a_TFBSnumbers_layer1.txt用
echo "layer1でPromoterに結合するTFBS数"
wc data"${DataNo}"_promoter_TFBS_DEGs.txt
echo "layer1でEnhancerに結合するTFBS数"
wc data"${DataNo}"_enhancer_TFBS_DEGs.txt
echo "layer1でPromoter/Enhancerに結合するTFBS数"
wc data"${DataNo}"_promoterenhancer_TFBS_DEGs.txt

#以下Fig2a_TFBSnumbers_layer2.txt用
echo "layer2でPromoterに結合するTFBS数"
wc data"${DataNo}"_promoter_TFBS_DEGs2.txt
echo "layer2でEnhancerに結合するTFBS数"
wc data"${DataNo}"_enhancer_TFBS_DEGs2.txt
echo "layer1でPromoter/Enhancerに結合するTFBS数"
wc data"${DataNo}"_promoterenhancer_TFBS_DEGs2.txt

#以下Fig2a_TFBStypes_layer1.txt用
echo "layer1でPromoterまたはEnhancerに結合するTFBSの種類"
wc data"${DataNo}"_TFBS_DEGs.txt
#以下Fig2a_TFBStypes_layer2.txt用
echo "layer2でPromoterまたはEnhancerに結合するTFBSの種類"
wc data"${DataNo}"_TFBS_DEGs2.txt

