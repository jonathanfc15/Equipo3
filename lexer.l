%{
#include <stdio.h>
#include "analizador.tab.h"

int yyparse(void);
%}

%option noyywrap

%%

DEFINE                          { fprintf(yyout, "TOKEN_DEFINE: %s\n", yytext); return DEFINE; }
PRINT                           { fprintf(yyout, "TOKEN_PRINT: %s\n", yytext); return PRINT; }
[0-9]{2}\/[0-9]{2}\/[0-9]{4}    { fprintf(yyout, "TOKEN_FECHA: %s\n", yytext); return FECHA; }
\"[^\"]*\"                      { fprintf(yyout, "TOKEN_CADENA: %s\n", yytext); return CADENA; }
[0-9]+(\.[0-9]+)?              { fprintf(yyout, "TOKEN_NUMERO: %s\n", yytext); return NUMERO; }
[a-zA-Z_][a-zA-Z0-9_]*        { fprintf(yyout, "TOKEN_VARIABLE: %s\n", yytext); return VARIABLE; }
"+"                             { fprintf(yyout, "TOKEN_SUMA: %s\n", yytext); return SUMA; }
"*"                             { fprintf(yyout, "TOKEN_MULT: %s\n", yytext); return MULT; }
[ \t\r\n]+                      ;
.                               { fprintf(yyout, "SIMBOLO: %s\n", yytext); }

%%

int main(void) {
    yyin = fopen("programa.txt", "r");
    yyout = fopen("out.txt", "w");

    if (!yyin) { perror("No se pudo abrir programa.txt"); return 1; }
    if (!yyout) { perror("No se pudo abrir out.txt"); return 1; }

    yyparse();

    fclose(yyin);
    fclose(yyout);
    return 0;
}