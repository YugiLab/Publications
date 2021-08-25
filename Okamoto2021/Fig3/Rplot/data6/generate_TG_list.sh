DataNo=$1

cat data"${DataNo}"_TFTGs.txt | cut -d"," -f2 | sort | uniq > data"${DataNo}"_TGs.txt
