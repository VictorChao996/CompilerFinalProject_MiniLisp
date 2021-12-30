%{
#include <stdio.h>
#include <string.h>
//warning: captial letter word represent token 
int yylex();
void yyerror(const char*message);
%}
%union{
    int intval,boolval;
}
%type <int> program stmts stmt print_stmt define_stmt exp num_op logical_op
%type <int> exps_a exps_mul
%type <int> and_op or_op not_op
%type <int> variable exp_equal
%type <int> param last_exp if_exp test_exp then_exp else_exp
%type <int> fun_exp fun_ids fun_body fun_call fun_name
%type <int> plus minus multiply divide modulus greater smaller equal
%token ADD SUB MUL DIV MOD GREATER SMALLER EQUAL AND OR NOT DEFINE FUN IF
%token PRINTBOOL PRINTNUM
%token <intval> ID
%token <intval> NUMBER
%token <boolval> BOOL
%%
program : stmts
    ;
stmts : stmt stmts
      | stmt {
         $$ = $1;    
      }
      ;
stmt : exp {
            $$ = $1;
        }
      | define_stmt {
            $$ = $1;
        }
      | print_stmt {
            $$ = $1;
        }
      ;  
print_stmt : '(' PRINTNUM exp ')'
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
num_op : plus {
            $$ = $1;
        }
        | minus{
            $$ = $1;
        } 
        | multiply{
            $$ = $1;
        }
        | divide{
            $$ = $1;
        }
        | modulus{
            $$ = $1;
        }
        | greater{
            $$ = $1;
        }
        | smaller{
            $$ = $1;
        }
        | equal{
            $$ = $1;
        }
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
exp_equal : exp exp_equal
          | exp{
            $$ = $1;
          }
           ;   
logical_op : and_op{
                $$ = $1;
            }
            | or_op{
                $$ = $1;
            }    
            | not_op{
                $$ = $1;
            }    
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
fun_ids : '(' ids ')' {
            $$ = $2;
        }
        ;
ids : ids ID
    | ID
    ;
fun_body : exp {
                $$ = $1;
         }
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
test_exp : exp {
            $$ = $1;
        }
         ;
then_exp : exp {
            $$ = $1;
        }
         ;
else_exp : exp {
            $$ = $1;
        }
         ;      
%%
void yyerror(const char *message)
{
    //fprintf(stderr, "%s\n", message);
    printf("syntax error\n");
}
int main(int argc, char *argv[]){
    yyparse();
    return(0);
}