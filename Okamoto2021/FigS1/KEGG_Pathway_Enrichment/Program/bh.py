'''
A simple program for Benjamini-Hochberg correction

Usage :
  $ python bh.py [input_file]

Input format :
'input_file' includes tab-limited strings and p-values in a format below:

  [string 1][tab][p-value 1]
  [string 2][tab][p-value 2]
    .
    .
    .
  [string m][tab][p-value m]

Output format :

  [string 1][tab][p-value 1][tab][BH-corrected q-value 1]
  [string 2][tab][p-value 2][tab][BH-corrected q-value 2]
    .
    .
    .
  [string m][tab][p-value m][tab][BH-corrected q-value m]
'''

import sys

aFileName = sys.argv[1]

def loadPvalue( aFileName ):

    aName2PQvalueListDic = {}

    f = open( aFileName )
    aLineList = f.readlines()
    f.close()

    for aLine in aLineList:
        aTokenList = aLine[:-1].split("\t")

        aName = aTokenList[0]
        aPvalue = float( aTokenList[1] )
        aQprime = '-'
        aQvalue = '-'
        
        aName2PQvalueListDic[ aName ] = [ aPvalue , aQprime, aQvalue ]

    return aName2PQvalueListDic


def calcQprime( aName2PQvalueListDic ):
    i = 1
    m = len( aName2PQvalueListDic )

    for aKey, aValue in sorted( aName2PQvalueListDic.items(), key=lambda x:x[1][0] ) :
        aPvalue = aName2PQvalueListDic[ aKey ][ 0 ]
        aQprime = m * aPvalue / i
        aName2PQvalueListDic[ aKey ][ 1 ] = aQprime
        i += 1

    return aName2PQvalueListDic


def calcQvalue( aName2PQvalueListDic ): 
    m = len( aName2PQvalueListDic )

    i = m
    for aKey, aValue in sorted( aName2PQvalueListDic.items(), key=lambda x:x[1][0], reverse=True ) :
        if i == m :
            aQvalue = aName2PQvalueListDic[ aKey ][ 1 ]
        else :
            aQprime = aName2PQvalueListDic[ aKey ][ 1 ]
            aQvalue = min( aQprime , aQvalue )

        aName2PQvalueListDic[ aKey ][ 2 ] = aQvalue
            
        i -= 1

    return aName2PQvalueListDic 


def main( aFileName ):
    aName2PQvalueListDic = loadPvalue( aFileName )
    aName2PQvalueListDic = calcQprime( aName2PQvalueListDic )
    aName2PQvalueListDic = calcQvalue( aName2PQvalueListDic )

    for aName in aName2PQvalueListDic.keys():
        [ aPvalue , aQprime, aQvalue ] = aName2PQvalueListDic[ aName ]
        print( "\t".join( map(str, [ aName, aPvalue , aQvalue ]) ) )

main( aFileName )
