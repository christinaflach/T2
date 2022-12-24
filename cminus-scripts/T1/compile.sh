#!/bin/bash
# no parameters
# add your Flex code to scr/lexer.l  to get rid of the warning message:
# "src/lexer.l:18: warning, -s option given but default rule can be matched" 

flex src/lexer.l           
cc -o lexer lex.yy.c   #  "lexer" is the lexical analyzer for C-
rm lex.yy.c

