/* main.c */

#include <stdio.h>
#include <stdlib.h>

extern struct decl* parser_result;
<<<<<<< HEAD
struct decl * yyparse();

extern void print(struct decl*);
=======
extern int yyparse();
extern void bracket(struct decl* program);
>>>>>>> ae95bf9876cf37a2b231ed12e2fa432fab87b4aa

int main(int argc, char **argv) {

    extern FILE *yyin;
<<<<<<< HEAD
    FILE *fout;
=======
    FILE *yyout;
>>>>>>> ae95bf9876cf37a2b231ed12e2fa432fab87b4aa

    if (argc > 2) {
        if(!(yyin = fopen(argv[1], "r"))) {
            fprintf(stderr,"Erro na abertura do arquivo de entrada %s\n",argv[1]);
            return (1);
        }
<<<<<<< HEAD
        if(!(fout = fopen(argv[2], "w"))) {
=======
        if(!(yyout = fopen(argv[2], "w"))) {
>>>>>>> ae95bf9876cf37a2b231ed12e2fa432fab87b4aa
            fprintf(stderr,"Erro na criacao do arquivo de saida %s\n",argv[2]);
            return (1);
        }
    }
    else {
        fprintf(stderr,"Erro no número de argumentos passados para cminus\n");
        return (1);
    }

<<<<<<< HEAD
    if ((parser_result=yyparse()))
	print(parser_result);
    else {
	fprintf(stderr,"Erro Sintático.\n");
	return (1);
    }
}    

=======
    int result = yyparse();
    if (!result)
	bracket(parser_result);
    return result;
} 
>>>>>>> ae95bf9876cf37a2b231ed12e2fa432fab87b4aa
