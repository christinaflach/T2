%option noyywrap yylineno nodefault
%{
#include "token.h"
%}

%%

"//".*                      { /* no action */ }

int             { return INT; }
void            { return VOID; }
do 		{ return DO; }
else            { return ELSE; }
if              { return IF; }
return          { return RETURN; }
while           { return WHILE; }

[A-Za-z]([A-Za-z_]|[0-9])* { yylval.name = strdup(yytext); return ID; }
[0-9]+          { yylval.d = atoi(yytext); return NUM; }

"+"		{ return ADD; }
"-" 		{ return MINUS; }
"*"		{ return TIMES; }
"/"		{ return DIV; }
"="             { return ASSIGN; }

"<"             { return LT; }
">"             { return GT; }
"<="       	{ return LTE; }
">="       	{ return GTE; }
"=="       	{ return EQ; }
"!="       	{ return NEQ; }

";"        	{ return SEMIC; }
","    		{ return COMMA; }

"("   		{ return OPENP; }
")"   		{ return CLOSEP; }
"["   		{ return OPENB; } 
"]"   		{ return CLOSEB; }
"{"   		{ return OPENC; }
"}"   		{ return CLOSEC; }

[ \t\n]         { /* no action */ }
.               { return ERROR; }

%%


