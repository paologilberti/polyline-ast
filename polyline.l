%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
%}

WHITESPACE  [ \n\r\t]+
TERMINATE   exit|e|quit|q
INTEGER     0|[+-]?[1-9][0-9]*
SYMMETRY    sim0|simx|simy
VARIABLE    [a-zA-Z][a-zA-Z0-9_]*

%%

{WHITESPACE}    { }
"("             { return LBRACK; }
")"             { return RBRACK; }
"+"             { return PLUS; }
"="             { return ASSIGN; }
";"             { return SEMICOLON; }
isOpen          { return ISOPEN; }
Close           { return CLOSE; }
{TERMINATE}     { return TERMINATE; }
{INTEGER}       { yylval.integer = atoi(yytext); return INTEGER; }
{SYMMETRY}      { yylval.string = strdup(yytext); return SYMMETRY; }
{VARIABLE}      { yylval.string = strdup(yytext); return VARIABLE; }
.               { printf("Illegal character: %s\n", yytext); return yytext[0]; }

%%

int yywrap() {
    return 1;
}
