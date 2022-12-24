%{
/* cminus.y */

#include <stdio.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

extern int yylineno;
int yylex();

void yyerror(const char *msg) {
	fprintf(stderr, "%s\n", msg);
}
%}

%token ID
%token NUM

%token INT
%token VOID
%token DO
%token ELSE
%token IF
%token RETURN
%token WHILE

%token ADD
%token MINUS
%token TIMES
%token DIV
%token ASSIGN

%token LT
%token GT
%token LTE
%token GTE
%token EQ
%token NEQ

%token SEMIC
%token COMMA

%token OPENP
%token CLOSEP
%token OPENB
%token CLOSEB
%token OPENC
%token CLOSEC

%token ERROR

%nonassoc EQ
%nonassoc NEQ
%nonassoc LT
%nonassoc GT
%nonassoc LTE
%nonassoc GTE

%nonassoc ELSE

%start program

%%

program
: declaration_list
;

declaration_list
: declaration_list declaration
| declaration
;

declaration:
  var_declaration
| fun_declaration
;

var_declaration:
  type_specifier ID SEMIC
| type_specifier ID OPENB NUM CLOSEB SEMIC
;

fun_declaration:
  type_specifier ID OPENP params CLOSEP compound_stmt
;

type_specifier:
  INT
| VOID
;

params:
  param_list
| VOID
;

param_list:
  param_list COMMA param
| param
;

param:
  type_specifier ID
| type_specifier ID OPENB CLOSEB
;


compound_stmt:
  OPENC local_declarations statement_list CLOSEC
| OPENC local_declarations CLOSEC
| OPENC statement_list CLOSEC
| OPENC CLOSEC
;

local_declarations:
  var_declaration
| local_declarations var_declaration
;


statement_list:
  statement 
| statement_list statement
;

statement:
  expression_stmt
| compound_stmt
| selection_stmt
| iteration_stmt
| return_stmt
;

expression_stmt:
  expression SEMIC
| SEMIC
;

selection_stmt:
  IF OPENP expression CLOSEP statement
| IF OPENP expression CLOSEP statement ELSE statement
;

iteration_stmt:
  WHILE OPENP expression CLOSEP DO statement
;

return_stmt
: RETURN SEMIC
| RETURN expression SEMIC
;

expression
: var ASSIGN expression
| simple_expression
;

var:
  ID
| ID OPENB expression CLOSEB
;


simple_expression
: additive_expression
| additive_expression LT additive_expression
| additive_expression GT additive_expression
| additive_expression LTE additive_expression
| additive_expression GTE additive_expression
| additive_expression EQ additive_expression
| additive_expression NEQ additive_expression
;

additive_expression:
  term
| additive_expression ADD term
| additive_expression MINUS term
;

term:
  factor
| term TIMES factor
| term DIV factor
;

factor:
  NUM
| OPENP expression CLOSEP
| var
| call
;

call
: ID OPENP args CLOSEP
;

args
: { /* void */ }
| args_list
;

args_list:
  args_list COMMA expression
| expression
;

%%


