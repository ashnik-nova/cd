%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int line_num;  // Declare line_num as an external variable
extern char* yytext;

void yyerror(const char* s);
%}

%union {
    int ival;
    float fval;
    char* sval;
    int bval;
}

%token LET CONST VAR IF ELSE WHILE FOR DO FUNCTION RETURN CONSOLE_LOG
%token TYPE_NUMBER TYPE_STRING TYPE_BOOLEAN
%token <ival> INTEGER
%token <fval> FLOAT
%token <sval> STRING IDENTIFIER
%token <bval> BOOLEAN

%token EQ NE GT LT GE LE AND OR

%left OR
%left AND
%left EQ NE
%left GT LT GE LE
%left '+' '-'
%left '*' '/'
%right '!' UMINUS

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

// Starting point of the grammar
program:
    statement_list
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement:
    declaration ';'
    | assignment ';'
    | if_statement
    | while_statement
    | for_statement
    | do_while_statement ';'
    | function_declaration
    | expression_statement
    | '{' statement_list '}'
    ;

expression_statement:
    expression ';'
    ;

declaration:
    LET IDENTIFIER optional_type_annotation optional_initializer
    | CONST IDENTIFIER optional_type_annotation '=' expression
    | VAR IDENTIFIER optional_type_annotation optional_initializer
    ;

optional_type_annotation:
    /* empty */
    | ':' type
    ;

optional_initializer:
    /* empty */
    | '=' expression
    ;

type:
    TYPE_NUMBER
    | TYPE_STRING
    | TYPE_BOOLEAN
    | array_type
    ;

array_type:
    type '[' ']'
    ;

assignment:
    left_hand_side '=' expression
    ;

left_hand_side:
    IDENTIFIER
    | array_access
    ;

array_access:
    IDENTIFIER '[' expression ']'
    ;

if_statement:
    IF '(' expression ')' statement %prec LOWER_THAN_ELSE
    | IF '(' expression ')' statement ELSE statement
    ;

while_statement:
    WHILE '(' expression ')' statement
    ;

for_statement:
    FOR '(' for_init ';' expression ';' expression ')' statement
    ;

for_init:
    /* empty */
    | declaration
    | assignment
    ;

do_while_statement:
    DO statement WHILE '(' expression ')'
    ;

function_declaration:
    FUNCTION IDENTIFIER '(' parameter_list ')' optional_return_type '{' statement_list '}'
    ;

optional_return_type:
    /* empty */
    | ':' type
    ;

parameter_list:
    /* empty */
    | non_empty_parameter_list
    ;

non_empty_parameter_list:
    parameter
    | non_empty_parameter_list ',' parameter
    ;

parameter:
    IDENTIFIER optional_type_annotation
    ;

expression:
    literal
    | IDENTIFIER
    | array_access
    | function_call
    | binary_expression
    | unary_expression
    | '(' expression ')'
    | array_literal
    | console_log_statement // Handle console.log as an expression
    ;

literal:
    INTEGER
    | FLOAT
    | STRING
    | BOOLEAN
    ;

binary_expression:
    expression '+' expression
    | expression '-' expression
    | expression '*' expression
    | expression '/' expression
    | expression EQ expression
    | expression NE expression
    | expression GT expression
    | expression LT expression
    | expression GE expression
    | expression LE expression
    | expression AND expression
    | expression OR expression
    ;

unary_expression:
    '!' expression
    | '-' expression %prec UMINUS
    ;

function_call:
    IDENTIFIER '(' argument_list ')'
    ;

argument_list:
    /* empty */
    | non_empty_argument_list
    ;

non_empty_argument_list:
    expression
    | non_empty_argument_list ',' expression
    ;

array_literal:
    '[' ']'
    | '[' non_empty_array_elements ']'
    ;

non_empty_array_elements:
    expression
    | non_empty_array_elements ',' expression
    ;

console_log_statement:
    CONSOLE_LOG '(' argument_list ')' // Handle console.log
    ;

%%

// Error handling function
void yyerror(const char* s) {
    fprintf(stderr, "Error on line %d: %s\n", line_num, s);
}

// Main function to start parsing
int main() {
    yyparse();
    return 0;
}
