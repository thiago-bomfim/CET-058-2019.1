%{
#include <stdio.h>

#define STACK_SIZE 2048

enum TokenType {
    NUM     = 999,
    ADD     = 998,
    SUB     = 997,
    MUL     = 996,
    DIV     = 995,
    AND     = 994,
    OR      = 993,
    NOT     = 992,
    EQU     = 991,
    LEQ     = 990,
    GEQ     = 989,
    NEQ     = 988,
    ASG     = 987,
    VAR     = 986,
    FUN     = 985,
    TRM     = 984,
    DMB     = 983,
    DME     = 982,
    PMB     = 981,
    PME     = 980,
    SPR     = 979,
    UKW     = 978
};

typedef struct {
    int type;
    char symbol[32];
} Token;

Token stack[STACK_SIZE];
int top = 0;

void put(int, char *);
%}

WHITESPACE [ \n\r\t]+
VAR \$"_"*[a-zA-Z0-9]+[a-zA-Z0-9_]*
FUN "func ""_"*[a-zA-Z]+[a-zA-Z0-9_]*
NUM [0-9]+

%%

{FUN}   {return FUN;}
{WHITESPACE}    /* Ignore */
{VAR}   {return VAR;}
"="     {return ASG;}
"+"     {return ADD;}
"-"     {return SUB;}
"*"     {return MUL;}
"/"     {return DIV;}
"&"     {return AND;}
"|"     {return OR;}
"!"     {return NOT;}
"=="    {return EQU;}
"<="    {return LEQ;}
">="    {return GEQ;}
"!="    {return NEQ;}
";"     {return TRM;}
"{"     {return DMB;}
"}"     {return DME;}
"("     {return PMB;}
")"     {return PME;}
","     {return SPR;}
{NUM}   {return NUM;}

.       {return UKW;}

%%

int yywrap() {}

int main(int argc, char **argv)
{
    int tok;

    while (tok = yylex())
    {
        put(tok, yytext);
    }
}

void put(int type, char *symbol) {
    printf("Type: %d\tSymbol: %s\n", type, symbol);
}