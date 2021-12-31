%option noyywrap
%{
#include "mini.tab.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
%}
/* perliminary definitions */
letter [a-z]+
digit [0-9] 
/*tab newline enter space*/
separator [\t|\n|\r| ]
/* token definitions */
NUMBER  0|[1-9]{digit}*|-[1-9]{digit}*
ID      {letter}({letter}|{digit}|\-)*
BOOL_VAL_TRUE  "#t"
BOOL_VAL_FALSE "#f"
PARA [\(\)]
%%
"+" {return ADD;}
"-" { return SUB;}
"*" { return MUL;}
"/" { return DIV;}
"mod" { return MOD;}
">" { return GREATER;}
"<" { return SMALLER;}
"=" { return EQUAL;}
"("|")" {return yytext[0];}
"and" { return AND;}
"or" { return OR;}
"not" { return NOT;}

"define" { return DEFINE;}
"fun" { return FUN;}
"if" { return IF;}

"print-num" {return PRINTNUM;}
"print-bool" {return PRINTBOOL;}
"("|")" {return yytext[0];}

{ID} {
    char *temp = (char*)malloc(strlen(yytext));
    for(int i=0; i<strlen(yytext); i++)
    {
        yylval.id = temp;
    }
    return ID;
}
{NUMBER} {
    yylval.intval = atoi(yytext);
    return(NUMBER);
}
{BOOL_VAL_TRUE} {
    yylval.intval = 1;
    return BOOL;
}
{BOOL_VAL_FALSE} {
    yylval.intval = 0;
    return BOOL;
}
{separator} {/*do nothing*/}
. {
    printf("Unexpected Character %s\n", yytext);
    exit(1);
}

%%
