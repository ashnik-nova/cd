%{
#include <stdio.h>
#include <string.h>
#include "ts.tab.h"

#ifndef YYSTYPE
extern YYSTYPE yylval;
#endif

int line_num = 1;  
%}

%%


"let"           { return LET; }
"const"         { return CONST; }
"var"           { return VAR; }
"if"            { return IF; }
"else"          { return ELSE; }
"while"         { return WHILE; }
"for"           { return FOR; }
"do"            { return DO; }
"function"      { return FUNCTION; }
"return"        { return RETURN; }
"console.log"   { return CONSOLE_LOG; }


"true"          { yylval.bval = 1; return BOOLEAN; }
"false"         { yylval.bval = 0; return BOOLEAN; }


"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"="             { return '='; }
"=="            { return EQ; }
"!="            { return NE; }
">"             { return GT; }
"<"             { return LT; }
">="            { return GE; }
"<="            { return LE; }
"&&"            { return AND; }
"||"            { return OR; }
"!"             { return '!'; }


[0-9]+          { yylval.ival = atoi(yytext); return INTEGER; }
[0-9]+"."[0-9]+ { yylval.fval = atof(yytext); return FLOAT; }


\"[^\"]*\"      { yylval.sval = strdup(yytext); return STRING; }


[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return IDENTIFIER; }

"["             { return '['; }
"]"             { return ']'; }
";"             { return ';'; }
","             { return ','; }
"("             { return '('; }
")"             { return ')'; }
"{"             { return '{'; }
"}"             { return '}'; }

[ \t]+          ; /* Ignore whitespace */
\n              { line_num++; }  

.               { printf("Unknown character on line %d: %s\n", line_num, yytext); }

%%

int yywrap() {
    return 1;
}
