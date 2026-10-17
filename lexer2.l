%{
#include <stdio.h>

int num_linea = 1;   /* contador de líneas para mensajes de error */
%}
%option noyywrap

%%
    /* ============================================================
     *  COMENTARIOS
     * ============================================================ */
"//"[^\n]*                 { fprintf(yyout, "COMENTARIO "); }
"/*"([^*]|\*+[^*/])*\*+"/" { fprintf(yyout, "COMENTARIO "); }

    /* ============================================================
     *  PALABRAS RESERVADAS
     *  (Van antes que los identificadores)
     * ============================================================ */
"int"        { fprintf(yyout, "KW_INT "); }
"float"      { fprintf(yyout, "KW_FLOAT "); }
"double"     { fprintf(yyout, "KW_DOUBLE "); }
"char"       { fprintf(yyout, "KW_CHAR "); }
"void"       { fprintf(yyout, "KW_VOID "); }
"long"       { fprintf(yyout, "KW_LONG "); }
"short"      { fprintf(yyout, "KW_SHORT "); }
"unsigned"   { fprintf(yyout, "KW_UNSIGNED "); }
"signed"     { fprintf(yyout, "KW_SIGNED "); }

"if"         { fprintf(yyout, "KW_IF "); }
"else"       { fprintf(yyout, "KW_ELSE "); }
"switch"     { fprintf(yyout, "KW_SWITCH "); }
"case"       { fprintf(yyout, "KW_CASE "); }
"default"    { fprintf(yyout, "KW_DEFAULT "); }
"break"      { fprintf(yyout, "KW_BREAK "); }
"continue"   { fprintf(yyout, "KW_CONTINUE "); }
"return"     { fprintf(yyout, "KW_RETURN "); }
"goto"       { fprintf(yyout, "KW_GOTO "); }

"for"        { fprintf(yyout, "KW_FOR "); }
"while"      { fprintf(yyout, "KW_WHILE "); }
"do"         { fprintf(yyout, "KW_DO "); }

"struct"     { fprintf(yyout, "KW_STRUCT "); }
"union"      { fprintf(yyout, "KW_UNION "); }
"enum"       { fprintf(yyout, "KW_ENUM "); }
"typedef"    { fprintf(yyout, "KW_TYPEDEF "); }
"sizeof"     { fprintf(yyout, "KW_SIZEOF "); }

"const"      { fprintf(yyout, "KW_CONST "); }
"static"     { fprintf(yyout, "KW_STATIC "); }
"extern"     { fprintf(yyout, "KW_EXTERN "); }
"register"   { fprintf(yyout, "KW_REGISTER "); }
"volatile"   { fprintf(yyout, "KW_VOLATILE "); }
"auto"       { fprintf(yyout, "KW_AUTO "); }

"include"    { fprintf(yyout, "KW_INCLUDE "); }
"define"     { fprintf(yyout, "KW_DEFINE "); }
"print"      { fprintf(yyout, "KW_PRINT "); }
"scanf"      { fprintf(yyout, "KW_SCANF "); }
"printf"     { fprintf(yyout, "KW_PRINTF "); }

"true"       { fprintf(yyout, "KW_TRUE "); }
"false"      { fprintf(yyout, "KW_FALSE "); }
"NULL"       { fprintf(yyout, "KW_NULL "); }

    /* ============================================================
     *  LITERALES
     * ============================================================ */

    /* Cadena con posibles escapes: "hola \"mundo\"\n" */
\"([^\\\n"]|\\.)*\"          { fprintf(yyout, "CADENA "); }

    /* Carácter con escapes: 'a', '\n', '\\' */
'([^\\'\n]|\\.)'             { fprintf(yyout, "CARACTER "); }

    /* Número hexadecimal: 0xFF, 0x1A2B */
0[xX][0-9a-fA-F]+            { fprintf(yyout, "NUM_HEX "); }

    /* Número binario: 0b1010 */
0[bB][01]+                   { fprintf(yyout, "NUM_BIN "); }

    /* Número octal: 0755 */
0[0-7]+                      { fprintf(yyout, "NUM_OCT "); }

    /* Número flotante con exponente: 1.5e-10, 3E+8 */
[0-9]+[.][0-9]+([eE][+-]?[0-9]+)?  { fprintf(yyout, "NUM_FLOAT "); }
[0-9]+[eE][+-]?[0-9]+              { fprintf(yyout, "NUM_FLOAT "); }

    /* Número entero: 42 */
[0-9]+                       { fprintf(yyout, "NUM_ENTERO "); }

    /* ============================================================
     *  IDENTIFICADORES
     * ============================================================ */
[a-zA-Z_][a-zA-Z0-9_]*       { fprintf(yyout, "ID "); }

    /* ============================================================
     *  OPERADORES  (los más largos primero)
     * ============================================================ */

    /* --- Asignación compuesta --- */
"+="         { fprintf(yyout, "OP_SUMA_ASIG "); }
"-="         { fprintf(yyout, "OP_RESTA_ASIG "); }
"*="         { fprintf(yyout, "OP_MULT_ASIG "); }
"/="         { fprintf(yyout, "OP_DIV_ASIG "); }
"%="         { fprintf(yyout, "OP_MOD_ASIG "); }
"&="         { fprintf(yyout, "OP_AND_ASIG "); }
"|="         { fprintf(yyout, "OP_OR_ASIG "); }
"^="         { fprintf(yyout, "OP_XOR_ASIG "); }
"<<="        { fprintf(yyout, "OP_SHL_ASIG "); }
">>="        { fprintf(yyout, "OP_SHR_ASIG "); }

    /* --- Incremento / decremento --- */
"++"         { fprintf(yyout, "OP_INCREMENTO "); }
"--"         { fprintf(yyout, "OP_DECREMENTO "); }

    /* --- Operadores lógicos y de comparación --- */
"&&"         { fprintf(yyout, "OP_AND "); }
"||"         { fprintf(yyout, "OP_OR "); }
"=="         { fprintf(yyout, "OP_IGUAL "); }
"!="         { fprintf(yyout, "OP_DISTINTO "); }
"<="         { fprintf(yyout, "OP_MENOR_IGUAL "); }
">="         { fprintf(yyout, "OP_MAYOR_IGUAL "); }

    /* --- Desplazamiento de bits --- */
"<<"         { fprintf(yyout, "OP_SHL "); }
">>"         { fprintf(yyout, "OP_SHR "); }

    /* --- Punteros / flecha de struct --- */
"->"         { fprintf(yyout, "OP_FLECHA "); }

    /* --- Operadores aritméticos --- */
"+"          { fprintf(yyout, "OP_SUMA "); }
"-"          { fprintf(yyout, "OP_RESTA "); }
"*"          { fprintf(yyout, "OP_MULT "); }
"/"          { fprintf(yyout, "OP_DIV "); }
"%"          { fprintf(yyout, "OP_MOD "); }

    /* --- Asignación simple --- */
"="          { fprintf(yyout, "OP_ASIG "); }

    /* --- Comparación simple --- */
"<"          { fprintf(yyout, "OP_MENOR "); }
">"          { fprintf(yyout, "OP_MAYOR "); }

    /* --- Lógicos bit a bit / unarios --- */
"!"          { fprintf(yyout, "OP_NOT "); }
"~"          { fprintf(yyout, "OP_BNOT "); }

    /* --- Ampersand: una sola regla (antes estaba duplicada) --- */
"&"          { fprintf(yyout, "OP_AMP "); }

    /* --- OR y XOR bit a bit --- */
"|"          { fprintf(yyout, "OP_BOR "); }
"^"          { fprintf(yyout, "OP_XOR "); }

    /* ============================================================
     *  DELIMITADORES Y SÍMBOLOS
     * ============================================================ */
"("          { fprintf(yyout, "PAR_IZQ "); }
")"          { fprintf(yyout, "PAR_DER "); }
"{"          { fprintf(yyout, "LLAVE_IZQ "); }
"}"          { fprintf(yyout, "LLAVE_DER "); }
"["          { fprintf(yyout, "CORCH_IZQ "); }
"]"          { fprintf(yyout, "CORCH_DER "); }
";"          { fprintf(yyout, "PUNTO_COMA "); }
","          { fprintf(yyout, "COMA "); }
"."          { fprintf(yyout, "PUNTO "); }
":"          { fprintf(yyout, "DOS_PUNTOS "); }
"#"          { fprintf(yyout, "HASH "); }
"?"          { fprintf(yyout, "INTERROGACION "); }
"\\"         { fprintf(yyout, "BACKSLASH "); }

     /* ============================================================
      *  ESPACIOS Y SALTOS DE LÍNEA
      * ============================================================ */
 [ \t]+          { fprintf(yyout, " "); }
 \r?\n           { fprintf(yyout, "\n"); num_linea++; }
 \r              { /* ignora CR suelto */ }

    /* ============================================================
     *  CUALQUIER OTRO CARÁCTER (error léxico)
     * ============================================================ */
.            { fprintf(stderr, "Error léxico en línea %d: '%s'\n",
                        num_linea, yytext);
               fprintf(yyout, "ERROR "); }

%%

int main(void) {
    yyin  = fopen("programac.txt", "r+");
    yyout = fopen("out.txt", "w");

    if (!yyin)  { perror("No se pudo abrir programac.txt"); return 1; }
    if (!yyout) { perror("No se pudo abrir out.txt");       return 1; }

    yylex();

    fclose(yyin);
    fclose(yyout);
    return 0;
}