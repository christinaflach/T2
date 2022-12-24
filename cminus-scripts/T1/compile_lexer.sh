#!/bin/bash
# Run inside individual repo 
  
testenv=$(pwd)
src=/src/

echo "Dir: "
echo "$testenv" 
# cd "$testenv$src"
"$testenv/compile.sh"

#flex "lexer.l" 
#cc -o lexer "lex.yy.c" -ll

#lexer=`find . -name "lexer" | wc -l"
#if [[ $lexer -eq 0 ]]; then
#    g++ -o lexer "lex.yy.c" -ll
#fi

cd "$testenv"
echo "lexer compilado."
echo


