/* ast.c
 * Adaptação de partes do código do livro de Compiladores
 * de Douglas Thain para a disciplina MATA61-UFBA
 * Christina von Flach (github: christinaflach)
 * 2020
 */ 

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "ast.h"

extern FILE * yyout; 
struct type * type_create(type_t kind,
                  struct type *subtype,
                  struct param_list *params)
{
    struct type *t = malloc(sizeof(*t));
    if (t) {
        t->kind = kind;
        t->subtype = subtype;
        t->params = params;
    }
    else
        fprintf(yyout,"No memory\n");
    return t;
}

struct decl *insert_decl(struct decl *head,
                         struct decl *elem) {
    struct decl *p = head;
    struct decl *i = elem;
    while (p->next) {
        p = p->next;
    }
    p->next = i;
    return head;
}

struct stmt *insert_stmt(struct stmt *head,
                         struct stmt *elem) {
    struct stmt *p = head;
    struct stmt *i = elem;
    while (p->next) {
        p = p->next;
    }
    p->next = i;
    return head;
}

struct param_list *insert_param(
                    struct param_list *head,
                    struct param_list *elem) {
    struct param_list *p = head;
    struct param_list *i = elem;
    while (p->next) {
        p = p->next;
    }
    p->next = i;
    return head;
}

struct decl * decl_create(
       char *name, struct type *type,
       struct expr *expr,
       struct stmt *code,
       struct decl *next )
{
    struct decl *d = malloc(sizeof(*d));
    if (d) {
        d->name = name;
        d->type = type;
        d->expr = expr;
        d->code = code;
        d->next = next;
    }
    else
        fprintf(yyout,"No memory\n");
    return d;
}

struct expr * create_integer(int i)
{
    struct expr *ei =
        expression_create(EXPR_INTEGER_LITERAL,0,0,0,i);
    return ei;
}

struct decl * var_decl_create(char *name, struct type *type)
{
    struct decl *vd = decl_create(name, type, 0, 0, 0);
    return vd;
}

struct decl * array_decl_create(char *name, struct type *type, int i)
{
    struct type *at = type_create(TYPE_ARRAY,type,0);
    struct expr *array_size = create_integer(i);
    struct decl *ad = decl_create(name,at,array_size,0,0);
    return ad;
}

struct decl * func_decl_create(char *name, struct type *type, struct param_list *plist, struct stmt *body)
{
    struct type *ft = type_create(TYPE_FUNCTION,type,plist);
    struct decl *fd = decl_create(name,ft,0,body,0);
    return fd;
}

struct param_list * param_create(char *name, struct type *type)
{
    struct param_list *pl = malloc(sizeof(*pl));
    if (pl) {
        pl->name = name;
        pl->type = type;
        pl->next = 0;
    }
    else
        fprintf(yyout,"No memory\n");
    return pl;
}

struct param_list * enum_param_create(char *name)
{
    struct param_list *pl = malloc(sizeof(*pl));
    if (pl) {
        pl->name = name;
        pl->next = 0;
    }
    else
        fprintf(yyout,"No memory\n");
    return pl;
}

struct param_list * param_array_create(char *name, struct type *type)
{
    struct type *at = type_create(TYPE_ARRAY,type,0);
    struct param_list *pl =
        param_create(name,at);
    return pl;
}

struct stmt * stmt_create( stmt_t kind,
    struct decl *decl, struct expr *init_expr,
    struct expr *expr, struct expr *next_expr,
    struct stmt *body, struct stmt *else_body,
    struct stmt *next )
{
    struct stmt *s = malloc(sizeof(*s));
    if (s) {
        s->kind = kind;
        s->decl = decl;
        s->init_expr = init_expr;
        s->expr = expr;
        s->next_expr = next_expr;
        s->body = body;
        s->else_body = else_body;
        s->next = next;
    }
    else
        fprintf(yyout,"No memory\n");
    return s;
}

struct stmt * compound_stmt_create(
                stmt_t kind,
                struct decl *localdecl,
                struct stmt *body)
{
    struct stmt *cs =
        stmt_create(kind,localdecl,0,0,0,body,0,0);
    return cs;
}

struct stmt * if_create(struct expr *expr,
                        struct stmt *body)
{
    struct stmt *ifs =
        stmt_create(STMT_IF_ELSE,0,0,expr,0,body,0,0);
    return ifs;
}

struct stmt * if_else_create(struct expr *expr,
                             struct stmt *body,
                             struct stmt *else_body)
{
    struct stmt *ifs =
        stmt_create(STMT_IF_ELSE,0,0,expr,0,body,else_body,0);
    return ifs;
}

struct stmt * while_create(struct expr *expr,
                           struct stmt *body)
{
    struct stmt *ws =
        stmt_create(STMT_WHILE,0,0,expr,0,body,0,0);
    return ws;
}


struct expr * expression_create(expr_t kind, struct expr *left, struct expr *right, char *name, int value)
{
    struct expr *e = malloc(sizeof(*e));
    if (e) {
        e->kind = kind;
        e->left = left;
        e->right = right;
        e->name = name;
        e->integer_value = value;
    }
    else
        fprintf(yyout,"No memory\n");
    return e;
}

struct expr * expr_create(expr_t kind,struct expr *left,struct expr *right)
{
    struct expr *e2 =
expression_create(kind,left,right,0,0);
    return e2;
}

struct expr * expr_create_name(char *name)
{
    struct expr *en = expression_create(EXPR_NAME,0,0,name,0);
    return en;
}

struct expr * expr_create_var(char *n)
{
    struct expr *name= expr_create_name(n);
    struct expr *en = expr_create(EXPR_VAR,name,0);
    return en;
}

struct expr * expr_create_uni(char *n)
{
    struct expr *name = expr_create_name(n);
    struct expr *ae = expr_create(EXPR_ARRAY,name,0);
    return ae;
}


struct expr * expr_create_array(char *n, struct expr *indexexpr)
{
    struct expr *name= expr_create_name(n);
    struct expr *ae = expr_create(EXPR_ARRAY,name,indexexpr);
    return ae;
}

struct expr * expr_create_integer(int i)
{
    struct expr *ei =
        expression_create(EXPR_INTEGER_LITERAL,0,0,0,i);
    return ei;
}

struct expr * expr_create_call(char *name, struct expr *expr)
{
    struct expr *n =
        expr_create_name(name);
    struct expr *ec =
        expr_create(EXPR_CALL, n, expr);

    return ec;
}

struct expr * expr_create_arg(struct expr *expr, struct expr *next)
{
    struct expr *arg =
        expr_create(EXPR_ARG,expr,next);
    return arg;
}

void print_name(char *name) {
    fprintf(yyout,"[%s]", name);
}

void print_type(struct type *type) {
  struct type *t = type;
  if (t) {
    switch(t->kind) {
        case TYPE_VOID: {
            fprintf(yyout,"[void]");
            break;
        }
        case TYPE_INTEGER: {
            fprintf(yyout,"[int]");
            break;
        }
        case TYPE_ARRAY: {
            if (t->subtype)
                print_type(t->subtype);
            break;
        }
        case TYPE_FUNCTION: {
            if (t->subtype)
                print_type(t->subtype);
            break;
        }
        default: break;
     }
   }
}

void print_params(struct param_list *pl){
    struct param_list *p = pl;
    while (p) {
        fprintf(yyout,"\n[param ");
        print_type(p->type);
        fprintf(yyout,"[%s]",p->name);
        fprintf(yyout,"]");
        p = p->next;
    }
}

void print_var(struct decl *var) {
    if(var->expr==0){
        fprintf(yyout,"\n[var-declaration ");
        print_type(var->type);
        print_name(var->name);
    }
    fprintf(yyout,"]");
}

void print_array(struct decl *array) {
    fprintf(yyout,"\n[var-declaration ");
    struct type *t = array->type;
    print_type(array->type);
    print_name(array->name);
    print_expr(array->expr);
    fprintf(yyout,"]");
}

void print_func(struct decl *func) {
    fprintf(yyout,"\n[func-declaration \n");
    print_type(func->type);
    fprintf(yyout,"\n");
    print_name(func->name);
    fprintf(yyout,"\n[params");
    struct type *t = func->type;
    if (t->params)
        print_params(t->params);
    fprintf(yyout,"\n]");
    if (func->code)
       print_stmt(func->code);
    fprintf(yyout,"]");
}

void print_decl(struct decl *decl) {
  while (decl) {
    struct type *t = decl->type;
    switch(t->kind) {
        case TYPE_VOID: {
            fprintf(yyout,"[void]");
            break;
        }
        case TYPE_INTEGER: {
            print_var(decl);
            break;
        }
        case TYPE_ARRAY: {
            print_array(decl);
            break;
        }
        case TYPE_FUNCTION: {
            print_func(decl);
            break;
        }
        default: {
            fprintf(yyout,"tipo desconhecido\n");
            break;
        }
     }
     decl = decl->next;
   }
}

void print_stmt(struct stmt *s) {
  while (s) {
    switch(s->kind) {
        case STMT_EXPR: {
            if (s->expr)
                print_expr(s->expr);
            else
                fprintf(yyout,"\n[;]\n");
            break;
        }
        case STMT_IF_ELSE: {
            fprintf(yyout,"\n[selection-stmt ");
            print_expr(s->expr);
            print_stmt(s->body);
            if (s->else_body)
                print_stmt(s->else_body);
            fprintf(yyout,"]");
            break;
        }
        case STMT_WHILE: {
            fprintf(yyout,"\n[iteration-stmt ");
            print_expr(s->expr);
            print_stmt(s->body);
            fprintf(yyout,"]\n");
            break;
        }
        case STMT_PRINT: {
            break;
        }
        case STMT_RETURN: {
            fprintf(yyout,"\n[return-stmt ");
            if (s->expr)
                print_expr(s->expr);
            else
                fprintf(yyout,"[;]\n");
            fprintf(yyout,"]\n");
            break;
        }
        case STMT_BLOCK: {
            fprintf(yyout,"\n[compound-stmt ");
            if (s->decl)
                print_decl(s->decl);
            if (s->body)
                print_stmt(s->body);
            fprintf(yyout,"]\n");
            break;
        }
        default: break;
     }
     s = s->next;
  }
}

void print_bexpr(char *c, struct expr *l, struct expr *r) {
    fprintf(yyout,"\n[%s ",c);
    print_expr(l);
    if (r) print_expr(r);
    fprintf(yyout,"]");
}

void print_expr(struct expr *e) {
    if (e) {
    switch(e->kind) {
        case EXPR_ASSIGN: {
            print_bexpr("=", e->left, e->right);
            break;
        }
        case EXPR_ADD: {
            print_bexpr("+", e->left, e->right);
            break;
        }
        case EXPR_SUB:
        {
            print_bexpr("-", e->left, e->right);
            break;
        }
        case EXPR_MUL: {
            print_bexpr("*", e->left, e->right);
            break;
        }
        case EXPR_DIV:
        {
            print_bexpr("/", e->left, e->right);
            break;
        }
        case EXPR_NAME: {
            fprintf(yyout,"[%s]", e->name);
            break;
        }
        case EXPR_VAR: {
            fprintf(yyout,"[var ");
            print_expr(e->left);
            fprintf(yyout,"]");
            break;
        }
        case EXPR_ARRAY: {
            fprintf(yyout,"[var ");
            print_expr(e->left);
            print_expr(e->right);
            fprintf(yyout,"]");
            break;
        }
        case EXPR_INTEGER_LITERAL: {
            fprintf(yyout,"[");
            int i = e->integer_value;
            fprintf(yyout,"%d", i);
            fprintf(yyout,"]");
            break;
        }
        case EXPR_EQ:
        {
            print_bexpr("==", e->left, e->right);
            break;
        }
        case EXPR_NEQ:
        {
            print_bexpr("!=", e->left, e->right);
            break;
        }
        case EXPR_LT:
        {
            print_bexpr("<", e->left, e->right);
            break;
        }
        case EXPR_GT:
        {
            print_bexpr(">", e->left, e->right);
            break;
        }
        case EXPR_LTEQ:
        {
            print_bexpr("<=", e->left, e->right);
            break;
	}
        case EXPR_GTEQ:
        {
            print_bexpr(">=", e->left, e->right);
            break;
        }
        case EXPR_FUN: {
            break;
        }
        case EXPR_CALL: {
            fprintf(yyout,"\n[call ");
            fprintf(yyout,"\n");
            print_expr(e->left);
            fprintf(yyout,"\n[args ");
            print_expr(e->right);
            fprintf(yyout,"]\n");
            fprintf(yyout,"]");
            break;
        }
        case EXPR_ARG:  {
            print_expr(e->right);
            print_expr(e->left);
            break;
        }
        default: {
            fprintf(yyout,"internal error:\n");
        }
    }
  }
}


void bracket(struct decl *program) {
    fprintf(yyout,"[program ");
    print_decl(program);
    fprintf(yyout,"\n]\n");
}

