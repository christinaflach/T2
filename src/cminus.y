%{
/* cminus.y */

#include <stdio.h>
#include "src/ast.h"

void yyerror(const char* msg) {
   fprintf(stderr, "%s\n", msg);
}

struct decl *parser_result;
extern int yylex();
%}

%token TOKEN_INT
%token TOKEN_VOID
%token TOKEN_DO

%token TOKEN_ID
%token TOKEN_NUM

%token TOKEN_ADD
%token TOKEN_MINUS
%token TOKEN_TIMES
%token TOKEN_DIV

%token TOKEN_ASSIGN
%token TOKEN_LE
%token TOKEN_GT
%token TOKEN_LEQ

%token TOKEN_ERROR

%type <decl> program

%start program

%%

program
: /* */ 
;

%%


