#!/bin/bash

# $1 == {species}_pathway_list.txt
# $2 == path.{species}.xrefs

aTotalHeader="TOTAL_NUMBER_OF_GENES"

join -t"	" -1 1 -2 1 -o1.1 -o2.2 $1 <(sort -k1,1 $2) | cut -f1 | sort | uniq -c | awk '{ print $2"\t"$1 }'

aTotalGeneNum=$(join -t"	" -1 1 -2 1 -o1.1 -o2.2 $1 <(sort -k1,1 $2 ) | cut -f2 | sort -u | wc -l)

echo ${aTotalHeader}"	"${aTotalGeneNum}
