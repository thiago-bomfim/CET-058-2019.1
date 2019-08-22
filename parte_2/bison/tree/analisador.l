/* Escreva uma analisador capaz de extrair os tokens de uma expressão
 * aritimética simples, incluindo parenteses.*/

%{

/* Código Global C que será copiado para o fonte */
/* #includes, variáveis globais e constantes vão aqui... */

#include "parser.tab.h"

%}

/* Definições */
NUMBER      [0-9]+
VARIAVEL    \$(([a-zA-Z]+)|(\_[a-zA-Z]+))
LOGICAS     ">"|"<"|"<="|">="

/* Início das Regras */
%%
{NUMBER}    {strncpy(yylval.simbolo, yytext, 50); return NUM;}
"\*"        {return MUL;}
"/"         {return DIV;}
"\+"         {return ADD;}
"\-"         {return SUB;}
"\("         {return APAR;}
"\)"         {return FPAR;}
{VARIAVEL}    {strncpy(yylval.simbolo, yytext, 50); return VARIAVEL;}
{LOGICAS}    {strncpy(yylval.simbolo, yytext, 50); return LOGICAS;}
"\n"         {return EOL;}

%%
/* Fim das Regras */
/* Código C abaixo será incluído nos fontes. */

int yywrap() {}

