%{
/* includes, C defs */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "ast.h"

struct decl *parser_result;

extern int yylineno;
int yylex();
void yyerror(const char *s);

%}

%union{
    struct decl *decl;
    struct stmt *stmt;
    struct expr *expr;
    struct type *type;
    struct param_list *plist;
    char *name;
    int d;
}

/* declare tokens */
%token <name> ID
%token <d> NUM
%token DO
%token ELSE
%token IF
%token INT
%token RETURN
%token VOID
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

%type <decl>  program
%type <decl>  declaration_list declaration
%type <decl>  var_declaration fun_declaration
%type <decl>  local_declarations
%type <type>  type_specifier
%type <plist> params param_list param
%type <stmt>  compound_stmt
%type <stmt>  statement_list statement
%type <stmt>  stmt_matched stmt_unmatched 
%type <stmt>  iteration_stmt return_stmt
%type <stmt>  expression_stmt
%type <expr>  expression simple_expression
%type <expr>  additive_expression factor term call var
%type <expr>  args args_list

%start program

%%

program: declaration_list { parser_result = $1; $$ = $1; }
;

declaration_list:
  declaration_list declaration { $$ = insert_decl($1,$2); }
| declaration { $$ = $1; }
;

declaration
: var_declaration { $$ = $1; }
| fun_declaration
;

var_declaration
: type_specifier ID SEMIC { $$ = var_decl_create($2,$1); }
| type_specifier ID OPENB NUM CLOSEB SEMIC 
  { $$ = array_decl_create($2,$1,$4); }
;

fun_declaration:
  type_specifier ID OPENP params CLOSEP compound_stmt
  { $$ = func_decl_create($2,$1,$4,$6); }
;

type_specifier:
  INT  { $$ = type_create(TYPE_INTEGER,0,0); }
| VOID { $$ = type_create(TYPE_VOID,0,0); }
;

params:
  param_list
| VOID { $$ = (struct param_list *) 0; }
;

param_list:
  param_list COMMA param  { $$ = insert_param($1,$3); }
| param { $$ = $1; }
;

param:
  type_specifier ID { $$ = param_create($2,$1); }
| type_specifier ID OPENB CLOSEB { $$ = param_array_create($2,$1); }
;

compound_stmt
: OPENC local_declarations statement_list CLOSEC
        { $$ = compound_stmt_create(STMT_BLOCK,$2,$3); }
| OPENC local_declarations CLOSEC
        { $$ = compound_stmt_create(STMT_BLOCK,$2,0); }
| OPENC statement_list CLOSEC
        { $$ = compound_stmt_create(STMT_BLOCK,0,$2); }
| OPENC CLOSEC
        { $$ = compound_stmt_create(STMT_BLOCK,0,0); }
;

local_declarations:
  var_declaration { $$ = $1; }
| local_declarations var_declaration { $$ = insert_decl($1,$2); }
;

statement_list:
  statement { $$ = $1;}
| statement_list statement { $$ = insert_stmt($1,$2); }
;

statement
: stmt_matched
| stmt_unmatched
;

stmt_unmatched
: IF OPENP expression CLOSEP statement { $$ = if_create($3,$5); }
| IF OPENP expression CLOSEP stmt_matched ELSE stmt_unmatched
  { $$ = if_else_create($3,$5,$7); }
;

stmt_matched
: IF OPENP expression CLOSEP stmt_matched ELSE stmt_matched
  { $$ = if_else_create($3,$5,$7); }
| expression_stmt
| compound_stmt
| iteration_stmt
| return_stmt
;

expression_stmt
: expression SEMIC { $$ = stmt_create(STMT_EXPR,0,0,$1,0,0,0,0); }
| SEMIC            { $$ = stmt_create(STMT_EXPR,0,0,0,0,0,0,0); }
;

iteration_stmt
: WHILE OPENP expression CLOSEP DO statement { $$ = while_create($3,$6); }
;

return_stmt
: RETURN SEMIC { $$ = stmt_create(STMT_RETURN,0,0,0,0,0,0,0); }
| RETURN expression SEMIC { $$ = stmt_create(STMT_RETURN,0,0,$2,0,0,0,0); }
;

expression:
  var ASSIGN expression { $$ = expr_create(EXPR_ASSIGN,$1,$3); }
| simple_expression { $$ = $1; }
;

var:
  ID { $$ = expr_create_var($1); }
| ID OPENB expression CLOSEB { $$ = expr_create_array($1,$3); }
;

simple_expression
: additive_expression
| additive_expression LT additive_expression
    { $$ = expr_create(EXPR_LT,$1,$3); }
| additive_expression GT additive_expression
    { $$ = expr_create(EXPR_GT,$1,$3); }
| additive_expression GTE additive_expression
    { $$ = expr_create(EXPR_GTEQ,$1,$3); }
| additive_expression LTE additive_expression
    { $$ = expr_create(EXPR_LTEQ,$1,$3); }
| additive_expression EQ additive_expression
    { $$ = expr_create(EXPR_EQ,$1,$3); }
| additive_expression NEQ additive_expression
    { $$ = expr_create(EXPR_NEQ,$1,$3); }
;

additive_expression
: term
| additive_expression ADD term { $$ = expr_create(EXPR_ADD, $1, $3); }
| additive_expression MINUS term { $$ = expr_create(EXPR_SUB, $1, $3); }
;

term
: factor
| term TIMES factor { $$ = expr_create(EXPR_MUL, $1, $3); }
| term DIV factor { $$ = expr_create(EXPR_DIV, $1, $3); }
;

factor
: NUM { $$ = expr_create_integer($1); }
| OPENP expression CLOSEP { $$ = $2; }
| var
| call
;

call
: ID OPENP args CLOSEP { $$ = expr_create_call($1,$3); }
;

args
: /* empty */ { $$ = (struct expr *) 0; }
| args_list
;

args_list:
  args_list COMMA expression { $$ = expr_create_arg($3,$1); }
| expression { $$ = expr_create_arg($1,0); }
;


%%

void yyerror(const char *s){
	printf("%s\n", s);
}

