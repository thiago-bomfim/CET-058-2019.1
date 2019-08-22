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
%token APAR
%token FPAR
%token EOL

%type<no> calc
%type<no> termo
%type<no> fator
%type<no> exp
%type<simbolo> NUM
%type<simbolo> MUL
%type<simbolo> DIV
%type<simbolo> SUB
%type<simbolo> ADD


%%
/* Regras de Sintaxe */

calc:
    | calc exp EOL { imprimir_arvore($2); }

exp: fator                
    | exp ADD fator {
        No** filhos = allocar_filhos(3);
        filhos[0] = $1;
        filhos[1] = allocar_no();
        filhos[1]->token[0] = '+';
        filhos[1]->num_filhos = 0;
        filhos[2] = $3;
        $$ = novo_no("<expr>", filhos, 2);
    }
    | exp SUB fator {
        No** filhos = allocar_filhos(3);
        filhos[0] = $1;
        filhos[1] = allocar_no();
        filhos[1]->token[0] = '-';
        filhos[1]->num_filhos = 0;
        filhos[2] = $3;
        $$ = novo_no("<expr>", filhos, 2);
    }
    ;

fator: termo
    | fator MUL termo {
        No** filhos = allocar_filhos(3);
        filhos[0] = $1;
        filhos[1] = allocar_no();
        filhos[1]->token[0] = '*';
        filhos[1]->num_filhos = 0;
        filhos[2] = $3;
        $$ = novo_no("<expr>", filhos, 2);
    }
    | fator DIV termo {
        No** filhos = allocar_filhos(3);
        filhos[0] = $1;
        filhos[1] = allocar_no();
        filhos[1]->token[0] = '/';
        filhos[1]->num_filhos = 0;
        filhos[2] = $3;
        $$ = novo_no("<expr>", filhos, 2);
    }
    ;

termo: NUM { $$ = novo_no($1, NULL, 0); }

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
    int i;

    if(raiz == NULL) {
        printf("***"); 
        return;
    }
    
    printf("(%s)", raiz->token);

    // Imprime filhos
    printf("filhos>");

    if (raiz->num_filhos > 0) {
        for (i = 0; i < raiz->num_filhos; i++) {
            imprimir_arvore(raiz->filhos[i]);
        }
    } else {
        printf("<vazio>");
    }
}

int main(int argc, char** argv) {
    yyparse();
}

yyerror(char *s) {
    fprintf(stderr, "error: %s\n", s);
}
