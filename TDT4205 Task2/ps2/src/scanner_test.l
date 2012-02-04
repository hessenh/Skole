/*** Definition section ***/
%{
/* C code to be copied verbatim */
#include <stdio.h>
%}

/* This tells flex to read only one input file */
%option noyywrap

WS_TOK [\t\n ]
WHITESPACE {WS_TOK}+
DIGIT [0-9]
NUMBER {DIGIT}+
COMMENT \/\/.*$
RESERVED FUNC|PRINT|RETURN|CONTINUE|IF|THEN|ELSE|FI|WHILE|DO|DONE|VAR
OPERATOR :=|\+|-|\/|\*|\*\*
STRING \".*?\"
ID [A-Za-z][A-Za-z0-9_]+

%%
    /*** Rules section ***/

    /* [0-9]+ matches a string of one or more digits */
{NUMBER} {
            /* yytext is a string containing the matched text. */
            printf("Saw an integer: %s\n", yytext);
        }
{WHITESPACE}  {
            /* yytext is a string containing the matched text. */
            printf("Saw whitespace of length %d\n", strlen(yytext));
       }
{COMMENT}  {
            /* yytext is a string containing the matched text. */
            printf("Saw a comment of length %d\n", strlen(yytext));
       }
{OPERATOR}  {
            /* yytext is a string containing the matched text. */
            printf("Saw a operator: %s\n", yytext);
       }
{RESERVED}  {
            /* yytext is a string containing the matched text. */
            printf("Saw a reserved: %s\n", yytext);
       }
{STRING}  {
            /* yytext is a string containing the matched text. */
            printf("Saw a string: %s\n", yytext);
       }
{ID}  {
            /* yytext is a string containing the matched text. */
            printf("Saw an identifier: %s\n", yytext);
       }
.|\n    {   /* Ignore all other characters. */   }

%%
/*** C Code section ***/

int main(void)
{
    /* Call the lexer, then quit. */
    yylex();
    return 0;
}