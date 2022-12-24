#!/bin/bash
# no parameters

cd ./src
bison --defines=token.h cminus.y
flex cminus.l
cc -c ast.c main.c lex.yy.c cminus.tab.c
cc -o cminus lex.yy.o cminus.tab.o ast.o main.o
mv ./cminus ../cminus
cd ..


