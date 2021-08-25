aFileName="alldata_TFTGs_count.txt"
def ProEnhMerge( aFileName ):
    with open(aFileName) as f:
        aLineList = f.readlines()

    TFList = []
    TGList = []
    mergeData = []

    for aline in aLineList:
        aTokenList = aline.rstrip().split("\t")
        appearance = aTokenList[0]
        TF = aTokenList[1]
        TG = aTokenList[2]
        position = aTokenList[3]

        if position == "Enhancer":
            TFList.append(TF)
            TGList.append(TG)
            mergeData.append([TF, "\t", TG, "\t", position, "\t", appearance, "\n"])

        elif position == "Promoter":
            if TF in TFList:
                if TG in TGList:
                    mergeData[-1][4] = "Promoter/Enhancer"
                    mergeData[-1][6] = str(int(appearance)*2)
                else:
                    TGList.append(TG)
                    mergeData.append([TF, "\t", TG, "\t", position, "\t", appearance, "\n"])
            else:
                TFList.append(TF)
                TGList.append(TG)
                mergeData.append([TF, "\t", TG, "\t", position, "\t", appearance, "\n"])

    with open('./alldata_TFTGs_pro_enh_merge_count.txt', 'w') as m:
        for info in mergeData:
            print(info)
            m.writelines(info)

ProEnhMerge( aFileName )
