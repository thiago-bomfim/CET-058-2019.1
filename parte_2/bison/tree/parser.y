%{

/* Código C, use para #include, variáveis globais e constantes
 * este código ser adicionado no início do arquivo fonte em C
 * que será gerado.
 */

#include <stdio.h>
#include <stdlib.h>

typedef struct No {
    char token[50];
    struct No** filhos;
    int num_filhos;
} No;


No* allocar_no();
No** allocar_filhos();
void liberar_no(void* no);
void imprimir_arvore(No* raiz);
No* novo_no(char *, No**, int);

%}

/* Declaração de Tokens no formato %token NOME_DO_TOKEN */
%union 
{
    int number;
    char simbolo[50];
    struct No* no;
}
%token NUM
%token ADD
%token SUB
%token MUL
%token DIV
%token VARIAVEL
%token LOGICAS
%token APAR
%token FPAR
%token EOL

%type<no> calc
%type<no> termo
%type<no> fator
%type<no> exp
%type<no> operador

%type<simbolo> NUM
%type<simbolo> MUL
%type<simbolo> DIV
%type<simbolo> SUB
%type<simbolo> ADD
%type<simbolo> VARIAVEL
%type<simbolo> LOGICAS


%%
/* Regras de Sintaxe */

calc:
    | calc exp EOL { imprimir_arvore($2); printf("\n\n"); }

exp: fator                
    | exp ADD fator {
        No** filhos = allocar_filhos(3);
        filhos[0] = $1;
        filhos[1] = novo_no("+", NULL, 0);
        filhos[2] = $3;

        $$ = novo_no("exp", filhos, 3);
    }
    | exp SUB fator {
        No** filhos = allocar_filhos(3);
        filhos[0] = $1;
        filhos[1] = novo_no("-", NULL, 0);
        filhos[2] = $3;

        $$ = novo_no("exp", filhos, 3);
    }
    | exp operador fator {
        No** filhos = (No**) malloc(sizeof(No*)*3);
        filhos[0] = $1;
        filhos[1] = $2;
        filhos[2] = $3;
        $$ = novo_no("exp", filhos, 3);
    }
    ;

fator: termo
    | fator MUL termo {
        No** filhos = allocar_filhos(3);
        filhos[0] = $1;
        filhos[1] = novo_no("*", NULL, 0);
        filhos[2] = $3;

        $$ = novo_no("fator", filhos, 3);
    }
    | fator DIV termo {
        No** filhos = allocar_filhos(3);
        filhos[0] = $1;
        filhos[1] = novo_no("/", NULL, 0);
        filhos[2] = $3;

        $$ = novo_no("fator", filhos, 3);
    }
    ;
operador: LOGICAS { $$ = novo_no($1, NULL, 0); }
    ;

termo: NUM { $$ = novo_no($1, NULL, 0); }
    | VARIAVEL { $$ = novo_no($1, NULL, 0); }
    ;

%%

/* Código C geral, será adicionado ao final do código fonte 
 * C gerado.
 */

No* allocar_no() {
    return (No*) malloc(sizeof(No));
}

No** allocar_filhos(int num_filhos) {
    return (No**) malloc(num_filhos * sizeof(No*));
}

void liberar_no(void* no) {
    free(no);
}

No* novo_no(char* token, No** filhos, int num_filhos) {
   No* no = allocar_no();
   snprintf(no->token, 50, "%s", token);
   no->filhos = filhos;
   no->num_filhos = num_filhos;

   return no;
}

void imprimir_arvore(No* raiz) {
   if(raiz == NULL) { printf("***"); return; }
    printf("[%s", raiz->token);
    if (raiz->filhos != NULL)
    {
        imprimir_arvore(raiz->filhos[0]);
        imprimir_arvore(raiz->filhos[1]);
        imprimir_arvore(raiz->filhos[2]);
        // printf("]");
    }
    printf("]");

}

int main(int argc, char** argv) {
    yyparse();
}

yyerror(char *s) {
    fprintf(stderr, "error: %s\n", s);
}
