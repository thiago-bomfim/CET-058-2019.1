%option

%{
#define TOKEN_SIZE 1024

enum TokenType {
    NUMBER  = 1000,
    ADD     = 999,
    SUB     = 998,
    MUL     = 997,
    DIV     = 996,
    AND     = 995,
    OR      = 994,
    NOT     = 993,
    EQ      = 992,
    LEQ     = 991,
    GEQ     = 990,
    NEQ     = 989
};

typedef struct {
    TokenType type;
    char[32] symbol;
}
%}

%%

"="   {return EQ;}

%%

void put(TokenType type, char *symbol) {
    
}

int yywrap() {}

int main(int argc, char **argv)
{
    yylex();
}
