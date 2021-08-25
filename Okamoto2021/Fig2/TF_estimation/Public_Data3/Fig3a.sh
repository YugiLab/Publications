#!/bin/bash

DataNo=$1
echo "Public Data${DataNo}"


echo "layer1のTFBSの種類"
wc data"${DataNo}"_TFBS_DEGs.txt

echo "layer2のTFBSの種類"
wc data"${DataNo}"_TFBS_DEGs2.txt

echo "layer3のTFBSの種類"
wc data"${DataNo}"_TFBS_DEGs3.txt

echo "layer4のTFBSの種類"
wc data"${DataNo}"_TFBS_DEGs4.txt

echo "layer5のTFBSの種類"
wc data"${DataNo}"_TFBS_DEGs5.txt
