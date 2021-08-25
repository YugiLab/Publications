#!/bin/bash

DataNo=$1
echo "Public Data${DataNo}"


echo "The number of TFBSs on layer1"
wc data"${DataNo}"_TFBS_DEGs.txt

echo "The number of TFBSs on layer2"
wc data"${DataNo}"_TFBS_DEGs2.txt

echo "The number of TFBSs on layer3"
wc data"${DataNo}"_TFBS_DEGs3.txt

echo "The number of TFBSs on layer4"
wc data"${DataNo}"_TFBS_DEGs4.txt

echo "The number of TFBSs on layer5"
wc data"${DataNo}"_TFBS_DEGs5.txt
