%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//warning: captial letter word represent token 
int yylex();
void yyerror(const char*message);

enum expType {
    plusType, subType, nulType, divType, modType, 
    andType, orType, notType , equType, greaterType, 
    smallerType, numberType, noneType
};
//node for different exp
typedef struct node{
    char *name;
    int value;
    struct node *left;
    struct node *right;
    enum expType type;
}Node;

Node* CreateExpNode(int value, char* name, enum expType);
int CountExpValue(Node* exp);
%}
%union {
    int intval;
    char* id;
    struct node *exp_node;
}

%token ADD SUB MUL DIV MOD GREATER SMALLER EQUAL AND OR NOT DEFINE FUN IF
%token PRINTBOOL PRINTNUM
%token <id> ID
%token <intval> NUMBER
%token <intval> BOOL

%type <exp_node> program stmts stmt print_stmt define_stmt exp num_op logical_op
%type <exp_node> exps_a exps_mul
%type <exp_node> and_op or_op not_op
%type <exp_node> variable exp_equal
%type <exp_node> last_exp if_exp test_exp then_exp else_exp
%type <exp_node> fun_exp fun_ids fun_body fun_call  ids
%type <exp_node> plus minus multiply divide modulus greater smaller equal
%type <intval> param params fun_name
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
            {
                printf("%d\n", CountExpValue($3));
            }
            | '(' PRINTBOOL exp ')' 
            {
                int temp = CountExpValue($3);
                if(temp == 1)  printf("#t\n");
                else if(temp == 0) printf("#f\n");
            }
            ;
exp : BOOL {
        Node* newNode = CreateExpNode($1, "", numberType);
        $$ = newNode;
    }
    | NUMBER {
        Node* newNode = CreateExpNode($1, "", numberType);
        $$ = newNode;
    }
    | variable {$$ = $1;}
    | num_op {$$ = $1;}
    | logical_op {$$ = $1;}
    | fun_exp {$$ = $1;}
    | fun_call {$$ = $1;}
    | if_exp {$$ = $1;}
    ;
num_op : plus {$$ = $1;}
        | minus {$$ = $1;} 
        | multiply {$$ = $1;}
        | divide {$$ = $1;}
        | modulus {$$ = $1;}
        | greater {$$ = $1;}
        | smaller {$$ = $1;}
        | equal {$$ = $1;}
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
        ;
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
fun_name : variable
         ;
if_exp : '(' IF test_exp then_exp else_exp ')' {

        }
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
Node* CreateExpNode(int value, char* name, enum expType type)
{
    Node* newNode = (Node*) malloc(sizeof(Node));
    newNode->name = name;
    newNode->value = value;
    newNode->right = NULL;
    newNode->left = NULL;
    newNode->type = type;
    return newNode;
}
int CountExpValue(Node* exp)
{
    if(exp == NULL)
        return 0;
    int right=0, left=0;
    right = CountExpValue(exp->right);
    left = CountExpValue(exp->left);
    switch(exp->type){
        case numberType:
            return exp->value;
        
    }

}
void yyerror(const char *message)
{
    //fprintf(stderr, "%s\n", message);
    printf("syntax error\n");
}
int main(int argc, char *argv[]){
    yyparse();
    return(0);
}