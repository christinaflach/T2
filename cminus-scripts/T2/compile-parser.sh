#!/bin/bash

user=$(whoami)
testenv=$(pwd)
inputs=/feedback/inputs/
outputs=/feedback/outputs/

bison --defines=token.h cminus.y
flex cminus.l
cc -o cminus cminus.tab.c lex.yy.c main.c
chmod +x cminus

