from scipy.stats import fisher_exact
import sys

aFileName = sys.argv[1]
theKey4total = 'TOTAL_NUMBER_OF_GENES'

def loadInputFile( aFileName ):

    aKO2freqListDic = {}

    f = open( aFileName )
    aLineList = f.readlines()
    f.close()

    for aLine in aLineList:
        aTokenList = aLine[:-1].split("\t")
        
        aKO = aTokenList[0]
        aFreq = int( aTokenList[1] )
        aChangedFreq = int( aTokenList[2] )

        if aKO == theKey4total :
            aTotalFreq = int( aTokenList[1] )
            aTotalChangedFreq = int( aTokenList[2] )
        else :
            anOddsRatio = '-'
            aPvalue = '-'
            aKO2freqListDic[ aKO ] = [ aFreq , aChangedFreq , anOddsRatio, aPvalue ]

    return [ aKO2freqListDic , aTotalFreq , aTotalChangedFreq ] 


def calcPvalue( aKO2freqListDic , aTotalFreq , aTotalChangedFreq ):

    for aKO in aKO2freqListDic.keys():
        [ aFreq , aChangedFreq , anOddsRatio, aPvalue ] = aKO2freqListDic[ aKO ]
        #aPvalue = hypergeom.cdf( aChanged, aTotalFreq, aTotalChangedFreq, aFreq ) 
        #( anOddsRatio , aPvalue ) = fisher_exact( [ [ aChangedFreq , aTotalChangedFreq - aChangedFreq ] , [ aFreq , aTotalFreq - aFreq ] ], alternative='greater' )

        anUnchangedFreq = aFreq - aChangedFreq
        anOtherChangedFreq = aTotalChangedFreq - aChangedFreq
        anOtherUnchangedFreq = aTotalFreq - aTotalChangedFreq - ( aFreq - aChangedFreq ) 

        ( anOddsRatio , aPvalue ) = fisher_exact( [ [ aChangedFreq , anOtherChangedFreq ] , [ anUnchangedFreq , anOtherUnchangedFreq ] ], alternative='greater' )
        
        aKO2freqListDic[ aKO ][ 2 ] = anOddsRatio
        aKO2freqListDic[ aKO ][ 3 ] = aPvalue 

    return aKO2freqListDic 


[ aKO2freqListDic, aTotalFreq , aTotalChangedFreq ] = loadInputFile( aFileName )
aKO2freqListDic = calcPvalue( aKO2freqListDic , aTotalFreq , aTotalChangedFreq )

for aKO in aKO2freqListDic.keys():
    [ aFreq , aChangedFreq , anOddsRatio, aPvalue ] = aKO2freqListDic[ aKO ]
    #anOddsRatio = ( float(aChangedFreq)/float(aFreq) ) / (float(aTotalChangedFreq)/float(aTotalFreq))

    print( "\t".join( map(str, [ aKO, aFreq, aChangedFreq, float(aChangedFreq)/float(aFreq), anOddsRatio, aPvalue ]) ) )

print( "\t".join( map(str, [ "Total", aTotalFreq, aTotalChangedFreq , float(aTotalChangedFreq)/float(aTotalFreq)])) )

