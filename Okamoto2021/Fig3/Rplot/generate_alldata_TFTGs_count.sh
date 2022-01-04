cat data1/data1_TFTGs.txt \
    data2/data2_TFTGs.txt \
    data3/data3_TFTGs.txt \
    data4/data4_TFTGs.txt \
    data5/data5_TFTGs.txt \
    data6/data6_TFTGs.txt \
    data7/data7_TFTGs.txt \
    data9/data9_TFTGs.txt \
    data10/data10_TFTGs.txt \
    data11/data11_TFTGs.txt \
    data12/data12_TFTGs.txt \
    data14/data14_TFTGs.txt | sort | uniq -c | sort -k2 > alldata_TFTGs_count_2.txt
cat alldata_TFTGs_count_2.txt | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*$//g' |
    tr " ," "\t" > alldata_TFTGs_count.txt
rm alldata_TFTGs_count_2.txt
