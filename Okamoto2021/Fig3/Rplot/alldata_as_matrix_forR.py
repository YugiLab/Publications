import pandas as pd

dataset="alldata_TFTGs_pro_enh_merge_count.txt"
def readData(dataset):
    with open(dataset) as d:
        aLineList = d.readlines()

    TFs = []
    TFnameList = []
    TGs = []
    TGnameList = []
    positionList = []
    appearanceList = []

    for aline in aLineList:
        aTokenList = aline.rstrip().split("\t")
        TF = aTokenList[0]
        TG = aTokenList[1]
        position = aTokenList[2]
        appearance = aTokenList[3]

        TFs.append(TF)
        TGs.append(TG)
        positionList.append(position)
        appearanceList.append(appearance)

        if TF in TFnameList:
            pass
        else:
            TFnameList.append(TF)
        if TG in TGnameList:
            pass
        else:
            TGnameList.append(TG)

    GeneNameList = TFnameList + TGnameList
    GeneNames = sorted(set(GeneNameList))
    #print(GeneNames)
    DataforDotplot = []
    for gene in GeneNames:
        DataforDotplot.append(["\t",gene])
    #print(DataforDotplot)

    for TFgene in TFnameList:
        aTFrow = ["\n",TFgene,"\t"]
        theTGlist=[]
        thePositionList=[]
        theAppearanceList = []
        n=0
        for aTF in TFs:
            if aTF == TFgene:
                theTG = TGs[n]
                thePosition = positionList[n]
                theAppearance = appearanceList[n]
                theTGlist.append(theTG)
                thePositionList.append(thePosition)
                theAppearanceList.append(theAppearance)
            else:
                pass
            n+=1

        i=0
        for theTF in GeneNames:
            if theTF in theTGlist:
                aTFrow.append(theAppearanceList[i])
                i+=1
            else:
                aTFrow.append("0")
            aTFrow.append("\t")

        DataforDotplot.append(aTFrow)

    with open('alldata_dotplot_matrix.txt', 'w') as dp:
        for i in DataforDotplot:
            print(i)
            dp.writelines(i)

readData(dataset)
