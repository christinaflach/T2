/* main.c */

#include <stdio.h>
#include <stdlib.h>

extern int yyparse();

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

    fprintf(stderr,"Finished compilation with cminus parser.\n");

    if (!yyparse())
	fprintf(stderr,"No syntax errors.\n");
    else {
	// fprintf(stderr,"\nErro sintático.\n");
	return (1);
    }
}    


