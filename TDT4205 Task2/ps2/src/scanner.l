%{
#include "parser.h"
#include "tree.h"

#ifdef DUMP_TOKENS
    #define RETURN(t) do {                                          \
        fprintf ( stderr, "TOKEN ( %d,\t'%s' )\n", t, yytext );     \
        return t;                                                   \
    } while ( 0 )
#else
    #define RETURN(t) return t
#endif

%}


WS_TOK [\s\n\t ]
WHITESPACE {WS_TOK}+
DIGIT [0-9]
NUMBER {DIGIT}+
COMMENT \/\/.*$
RESERVED FUNC|PRINT|RETURN|CONTINUE|IF|THEN|ELSE|FI|WHILE|DO|DONE|VAR
OPERATOR :=|\+|-|\/|\*|\*\*
STRING \"([^"]|\\\")*\"
ID [A-Za-z_][A-Za-z0-9_]*


%option array
%option noyywrap
%option yylineno

%%

{NUMBER}       { RETURN(NUMBER); }
{COMMENT}       { ; }
{WHITESPACE} { ; }
FUNC {RETURN(FUNC);}
PRINT {RETURN(PRINT);}
RETURN {RETURN(RETURN);}
CONTINUE {RETURN(CONTINUE);}
IF {RETURN(IF);}
THEN {RETURN(THEN);}
ELSE {RETURN(ELSE);}
FI {RETURN(FI);}
WHILE {RETURN(WHILE);}
DO {RETURN(DO);}
DONE {RETURN(DONE);}
VAR {RETURN(VAR);}
{STRING}       { RETURN( STRING ); }
{ID}       { RETURN( IDENTIFIER ); }
:=        { RETURN( ASSIGN ); }
\+       { RETURN( '+' ); }
-       { RETURN( '-' ); }
\/       { RETURN( '/'  ); }
\*       { RETURN( '*' ); }
\*\*       { RETURN( POWER  ); }
.           { RETURN( yytext[0] ); }
%%
