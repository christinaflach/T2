/* main.c */

#include <stdio.h>
#include <stdlib.h>

extern struct decl* parser_result;
struct decl * yyparse();

extern void print(struct decl*);

int main(int argc, char **argv) {

    extern FILE *yyin;
    FILE *fout;

    if (argc > 2) {
        if(!(yyin = fopen(argv[1], "r"))) {
            fprintf(stderr,"Erro na abertura do arquivo de entrada %s\n",argv[1]);
            return (1);
        }
        if(!(fout = fopen(argv[2], "w"))) {
            fprintf(stderr,"Erro na criacao do arquivo de saida %s\n",argv[2]);
            return (1);
        }
    }
    else {
        fprintf(stderr,"Erro no número de argumentos passados para cminus\n");
        return (1);
    }

    if ((parser_result=yyparse()))
	print(parser_result);
    else {
	fprintf(stderr,"Erro Sintático.\n");
	return (1);
    }
}    

