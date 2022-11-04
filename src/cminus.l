%option noyywrap yylineno nodefault
%{

// yylineno    - variable to track line numbers 
// nodefault   - do not add a default rule at the end of the scanner 
//               that copies otherwise unmatched input to yyout.

#include <stdio.h>
#include "token.h"
%}

%%

"//".*                      { /* no action */ }

int                         { return TOKEN_INT; }
void                        { return TOKEN_VOID; }

do 			    { return TOKEN_DO; }

[A-Za-z]([A-Za-z_]|[0-9])*  { return TOKEN_ID; }
[0-9]+                      { return TOKEN_NUM; }

"+"			    { return TOKEN_ADD; }
"-" 			    { return TOKEN_MINUS; }
"*"			    { return TOKEN_TIMES; }
"/"			    { return TOKEN_DIV;}

[ \t\n]                     { /* no action */ }
.                           { return TOKEN_ERROR; }

%%

