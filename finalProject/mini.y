%{
#include <stdio.h>
#include <string.h>
//warning: captial letter word represent token 
void yyerror(const char*message);
%}
%union{
    int intval,boolval;
}
%type program stmt stmts print_stmt define_stmt exp num_op logical_op
%type exps_a exps_mul
%type and_op or_op not_op
%type variable
%type param last_exp if_exp test_exp then_exp else_exp
%type fun_exp fun_ids fun_body fun_call fun_name
%type plus minus multiply divide modulus greater smaller equal
%token ADD SUB MUL DIV MOD GREATER SMALLER EQUAL AND OR NOT DEFINE FUN IF
%token PRINTBOOL PRINTNUM
%token <intval> ID
%token <intval> NUMBER
%token <boolval> BOOL
program : stmts
    ;
stmts : stmts stmt
      | stmt
      ;
print-stmt : '(' PRINTNUM exp ')'
            | '(' PRINTBOOL exp ')'
            ;
exp : BOOL
    | NUMBER
    | variable
    | num_op
    | logical_op
    | fun_exp
    | fun_call
    | if_exp
    ;
num_op : plus
        | minus 
        | multiply
        | divide
        | modulus
        | greater
        | smaller
        | equal
        ;
plus : '(' ADD exp exps_a ')'
    ;
exps_a : exp
       | exps_a exp
       ;
minus : '(' SUB exp exp ')'
      ;
multiply : '(' MUL exp exps_mul ')'
         ;
exps_mul : exp
         | exps_mul exp
         ;
divide : '(' DIV exp exp ')'
        ;
modulus : '(' MOD exp exp ')'
        ;
greater : '(' GREATER exp exp ')'
        ;
smaller : '(' SMALLER exp exp ')'
        ;
equal : '(' EQUAL exp exp_equal ')'
        ;
exp_equal : exp_equal exp
          | exp
           ;   
logical-op : and_op
            | or_op
            | not_op
            ;
and_op : '(' AND exp exps_a ')'
exp_a : exp
       | exps_a exp 
       ;
or_op : '(' OR exp exps_or ')'
      ;
exps_or : exps_or exp
        | exp
        ;
not_op : '(' NOT exp ')'
        ;
define_stmt : '(' DEFINE ID exp ')'
            ;
variable : ID
         ;
fun_exp : '(' FUN fun_ids fun_body ')'
        ;
fun_ids : '(' ids ')'
ids : ids ID
    | ID
    ;
fun_body : exp
         ;
fun_call : '(' fun_exp params ')'
         | '(' fun_name params ')'
         ;
params : params param
        | param
        ;
param : exp
      ;
last_exp : exp
         ;
fun_name : ID
         ;
if_exp : '(' IF test_exp then_exp else_exp ')'
        ;
test_exp : exp
         ;
then_exp : exp
         ;
else_exp : exp
         ;      
%%
void yyerror(const char *message)
{
    fprintf(stderr, "%s\n", message);
}
int main(int argc, char *argv[]){
    yyparse();
    return(0);
}