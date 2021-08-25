#!/bin/bash

# $1 == GOI_path.{species}.txt

aTotalHeader="TOTAL_NUMBER_OF_GENES"

sort -k1,1 $1 | uniq | cut -f1 | uniq -c | awk '{print $2"\t"$1}'

aTotalGeneNum=$(sort -k1,1 $1 | cut -f2 | sort -u | wc -l)

echo ${aTotalHeader}"	"${aTotalGeneNum}
