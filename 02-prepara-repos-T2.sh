#!/bin/bash
# Has 1 argument - repo name
# Run outside T2 repos to prepare each repo

testenv=$(pwd)
t2=$1
testenvparser="$testenv/$t2"
feedback=/feedback/
inputs=/feedback/inputs/
oracle=/feedback/oracle/
oraclec=/feedback/oraclec/
oracleok=/feedback/oracleok/
oraclenok=/feedback/oraclenok/

cd "$testenvparser" 
repos=$(ls)

for r in $repos; do
    echo "Repo name: $r"
    repotestenv="$testenvparser/$r"
    echo "Dir: $repotestenv"
    cd  "$repotestenv" 

# create branch feedback and checkout
    git checkout main
    git branch -D feedback
    git branch feedback
    git checkout feedback

    rm -rf "$repotestenv$feedback"
    mkdir "$repotestenv$feedback"

    echo "copiando /cminus-tests para /feedback"
    cp -r "$testenv/cminus-tests/$t2/inputs" "$repotestenv$feedback/"
    cp -r "$testenv/cminus-tests/$t2/oracle" "$repotestenv$feedback/"
    cp -r "$testenv/cminus-tests/$t2/oracleok" "$repotestenv$feedback/"
    cp -r "$testenv/cminus-tests/$t2/oraclenok" "$repotestenv$feedback/"
    cp "$testenv/cminus-tests/$t2/README.md" "$repotestenv$feedback/"

    echo "copiando /cminus-scripts para /."
    cp -r "$testenv/cminus-scripts/$t2/" "$repotestenv/"

    echo "done with Folder $r."
    echo "------------------------"
done

echo
echo "número de programas C- sem erro no oráculo: `ls "$testenv/cminus-tests/T2/oracleok" | wc -l`"
echo
echo "número de programas C- com erro no oráculo: `ls "$testenv/cminus-tests/T2/oraclenok" | wc -l`"

echo
echo "done T2 prepare $testenvparser."
