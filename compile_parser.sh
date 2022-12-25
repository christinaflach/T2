#!/bin/bash

user=$(whoami)
testenv=$(pwd)
inputs=/feedback/inputs/
outputs=/feedback/outputs/

bison --defines=token.h src/cminus.y
flex src/cminus.l
cp token.h src/token.h
cp src/ast.h .
cc -o cminus cminus.tab.c lex.yy.c src/ast.c src/main.c
chmod +x cminus

