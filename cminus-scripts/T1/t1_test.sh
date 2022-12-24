#!/bin/bash

user=$(whoami)
testenv=$(pwd)
srcparser=/src/parser/
srclexer=/src/lexer/
feedback=/feedback
inputs=/feedback/inputs/
outputs=/feedback/outputs/
# outputsc=/feedback/outputsc/
oracle=/feedback/oracle/
oracleok=/feedback/oracleok/
oraclenok=/feedback/oraclenok/
passou=/feedback/passou/
naopassou=/feedback/naopassou/
mydiff=/feedback/diffc/
mydiffTP=/feedback/TP/
mydiffTN=/feedback/TN/
mydiffFP=/feedback/FP/
mydiffFN=/feedback/FN/

function total_files {
    find $1 -type f | wc -l
}

function is_green {
    find "$testenv$passou" -name "$1" | wc -l
}

function is_OK {
    find "$testenv$oracleok" -name "$1" | wc -l
}

function is_red {
    find "$testenv$naopassou" -name "$1" | wc -l
}

function is_NOK {
    find "$testenv$oraclenok" -name "$1" | wc -l
}

NUMT=`ls "$testenv$inputs" | wc -l`

echo
echo "# Correção do Trabalho T1 - MATA61 2022.1"
echo 
# find, set context and run compile.sh
echo "compiling .............................."
./compile_lexer.sh
echo
# find, set context and run lexer
echo "running ................................"
./run_lexer.sh
echo

if [ "$(ls -A $testenv$outputs)" ]; then

# compare outputs with oracle
echo "testing .............................."
echo
./diff_lexer.sh

echo
# reporta 
echo "## Resultados"
echo
mkdir "$testenv$mydiffTP"
mkdir "$testenv$mydiffTN"
mkdir "$testenv$mydiffFP"
mkdir "$testenv$mydiffFN"

cd "$testenv$oracle"
mytests=$(ls)
cd $testenv

for t in $mytests; do
    g=`is_green $t`
    r=`is_red $t`
    o=`is_OK $t`
    n=`is_NOK $t`

    if [[ $g -gt 0  &&  $o -gt 0 ]]; then
        cp "$testenv$oracle$t" "$testenv$mydiffTP$t"
    fi

    if [[ $g -gt 0 ]] && [[ $n -gt 0 ]]; then
        cp "$testenv$oracle$t" "$testenv$mydiffTN$t"
    fi

    if [[ $r -gt 0 ]] && [[ $o -gt 0 ]]; then
        cp "$testenv$oracle$t" "$testenv$mydiffFN$t"
    fi

    if [[ $r -gt 0 ]] && [[ $n -gt 0 ]]; then
        cp "$testenv$oracle$t" "$testenv$mydiffFP$t"
    fi
done

TP=`ls "$testenv$mydiffTP" | wc -l`
echo "TP: $TP"
TN=`ls "$testenv$mydiffTN" | wc -l`
echo "TN: $TN"
FP=`ls "$testenv$mydiffFP" | wc -l`
echo "FP: $FP"
FN=`ls "$testenv$mydiffFN" | wc -l`
echo "FN: $FN"
echo

A=$(( TP + FP ))
B=$(( TP + FN ))
C=$(( TP + TN ))
D=$(( TP + TN + FP + FN ))
E=$(( TN + FP ))
#TPRd=$(( 100 * TP ))
#TPR=$(( TPRd / B )) 
#TNRd=$(( 100 * TN ))
#TNR=$(( TNRd / E ))
#F=$(( TPR + TNR ))
#BA=$(( F / 2 ))

echo
echo \`\`\`
echo "                   -------------------------------------"
echo "                              Your lexer                "
echo "                   -------------------------------------"
echo "                  | output_OK      | output_NOK         "
echo "--------------------------------------------------------"
echo " O   | oracle_OK  |  $TP (TP) |   $FP (FP)              "
echo " RA  |------------|----------------|--------------------"
echo " CLE | oracle_NOK |  $FN (FN) |   $TN (TN)              "
echo "--------------------------------------------------------"
echo \`\`\`
echo
echo
echo \`\`\`
if [[ $A -gt 0 ]]; then 
echo "Precision = TP / (TP + FP) = $(( 100 * TP / A ))"
fi
if [[ $B -gt 0 ]]; then 
echo "Recall = TP / (TP + FN) = $(( 100 * TP / B ))"
fi
if [[ $E -gt 0 ]]; then 
echo "Specificity = TN / (TN + FP) = $(( 100 * TN / E ))"
fi
if [[ $D -gt 0 ]]; then 
echo "Accuracy = (TP + TN) / (TP + TN + FP + FN) = $(( 100 * C / D ))"
fi
echo
#echo "Balanced Accuracy = $BA"
echo \`\`\`
echo

#end of if [ "$(ls -A $testenv$outputs)" ]; then
else
    echo "tp1_test.sh: The outputs folder is empty."
fi

echo
echo "--------------------------------------------------------"
echo
