from scipy import stats
import sys

args = sys.argv # obtain the commandline args
if len(args) > 1:
    if not args[1].isdigit():
        print('Please input the numerical value as an argument.')
        sys.exit()
else:
    print('Please input the numerical value as an argument.')
    sys.exit()

filename = "alldata_TFclass_each_clusters_for_enrichment.txt" #Target gene version : "all_TGcluster_appearance_pathway.txt"

def readData(filename):
    with open(filename, encoding="utf-8", errors="ignore") as f:
        lineList = f.readlines()

    ContingencyTable = []
    ChangedFreqList = []
    OtherChangedFreqList = []
    ClassFreqList = []
    TFclassList = []

    for line in lineList[1:]:
        cluster = []
        cluster.append(0) # append dummy value so as to adjust the index to the cluster number.

        TokenList = line.rstrip().split("\t")
        TFclass = TokenList[0]             #or pathway for TG enrichment
        all_cluster = int(TokenList[1])    #the appearances of each classes in all data
        cluster.append(int(TokenList[2]))
        cluster.append(int(TokenList[3]))
        cluster.append(int(TokenList[4]))
        cluster.append(int(TokenList[5]))
        cluster.append(int(TokenList[6]))
        cluster.append(int(TokenList[7]))

        if TFclass != "Total":
            changed_freq = cluster[int(args[1])] # Num of target cluster's TFs which belong to specific TF class.
            other_changed_freq = all_cluster - changed_freq # Num of other clusters' TFs which belong to specific TF class.
            ChangedFreqList.append(changed_freq)
            OtherChangedFreqList.append(other_changed_freq)
            ClassFreqList.append(all_cluster)
            TFclassList.append(TFclass)
        else: # In case of 'Total'
            total_class_freq = all_cluster
            total_cluster_freq = cluster[int(args[1])]

    i = 0
    PvalueDic = {}
    for changed_freq in ChangedFreqList:
        ClusterDataList = []
        OtherClusterDataList = []
        ClusterDataList.append(ChangedFreqList[i])
        OtherClusterDataList.append(OtherChangedFreqList[i])
        unchanged_freq = total_cluster_freq - ChangedFreqList[i] # Num of target cluster's TFs which do not belong to specific TF class.
        other_unchanged_freq = (total_class_freq - ClassFreqList[i]) - (total_cluster_freq - ChangedFreqList[i]) # Num of other clusters' TFs which do not belong to specific TF class.
        ClusterDataList.append(unchanged_freq)
        OtherClusterDataList.append(other_unchanged_freq)

        ContingencyTable.append(ClusterDataList)
        ContingencyTable.append(OtherClusterDataList)
        p = stats.fisher_exact(ContingencyTable, alternative="greater") # One-sided test
        PvalueDic[(TFclassList[i])] = (p[1]) # key: TFclass, value: p-value
        i += 1
        #print("cluster1", PvalueDic)
        ContingencyTable.clear()

    print('cluster' + str(args[1]), PvalueDic)
    sortedPvalueDic = sorted(PvalueDic.items(), key=lambda x:x[1]) # sort the dictionary by value.
    sortedKEGGbriteCategoryList = [x[0] for x in sortedPvalueDic] # List of the key of sortedPvalueDic
    sortedPvalueList = [x[1] for x in sortedPvalueDic] # List of the value of sortedPvalueDic

    j = 0
    for q_value in sortedPvalueList:
        q = float( sortedPvalueList[j] * ( len(ClassFreqList) / (j + 1) ) ) # https://www.pediatricsurgery.site/entry/2016/11/01/071347

        if q < 0.1:
            print( sortedKEGGbriteCategoryList[j] + "   q-value : " + str(q) )
            j += 1
        else:
            #print( PvalueDic.items(), sortedKEGGbriteCategoryList[j] + "   q-value : " + str(q) )
            j += 1

readData(filename)
