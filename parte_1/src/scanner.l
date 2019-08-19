%{
#include <stdio.h>
#include <string.h>

#define STACK_SIZE 2048

#define TRUE 1
#define FALSE 0

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
    WHL     = 978,
    RET     = 977,
    UKW     = 976
};

typedef struct {
    int type;
    char symbol[32];
} Token;

Token stack[STACK_SIZE];
int top = 0;

int put(int, char *);
void printStack(Token *, int);
%}

WHITESPACE [ \n\r\t]+
VAR \$"_"*[a-zA-Z0-9]+[a-zA-Z0-9_]*
FUN "func ""_"*[a-zA-Z]+[a-zA-Z0-9_]*
WHL "while"
RET "return"
NUM [0-9]+

%%

{FUN}   {return FUN;}
{WHITESPACE}    /* Ignore */
{VAR}   {return VAR;}
{WHL}   {return WHL;}
{RET}   {return RET;}
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

    printStack(stack, top);
    return 0;
}

int put(int type, char *symbol) 
{
    //printf("Type: %d\tSymbol: %s\n", type, symbol);
    Token tok;
    tok.type = type;
    strcpy(tok.symbol, symbol);
    
    if (top < STACK_SIZE) {
        stack[top++] = tok;
        return TRUE;
    }

    return FALSE;
}

void printStack(Token tokens[], int size)
{
    int i;

    for (i = 0; i < size; i++) {
        printf("Type: %d\tSymbol: %s\n", tokens[i].type, tokens[i].symbol);
    }
}