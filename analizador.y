%{
    #include <stdio.h>
    #include <stdlib.h>

    extern int yylex();
    void yyerror(const char *s);
%}

%token DEFINE
%token PRINT

%token VARIABLE
%token NUMERO
%token CADENA
%token FECHA

%token SUMA
%token MULT

%left SUMA
%left MULT

%start programa

%%

programa
        : programa sentencia
        | sentencia
        ;

sentencia
        : definicion '\n'
        | impresion '\n'
        | '\n'
        ;

definicion
        : DEFINE VARIABLE valor
        ;

impresion
        : PRINT valor
        ;

valor
        : NUMERO
        | CADENA
        | FECHA
        | VARIABLE
        | expresion
        ;

expresion
        : expresion SUMA termino
        | termino
        ;

termino
        : termino MULT factor
        | factor
        ;

factor
        : NUMERO
        | VARIABLE
        ;

%%

void yyerror(const char *s)
{
    printf("Error sintactico: %s\n", s);
}

