%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//warning: captial letter word represent token 
int yylex();
void yyerror(const char*message);

enum expType {
    plusType, minusType, mulType, divType, modType, 
    andType, orType, notType , equalType, greaterType, 
    smallerType, numberType, noneType,variableType, functionType
};

//node for different exp
typedef struct node{
    char *name;
    int value;
    struct node *left;
    struct node *right;
    enum expType type;
}Node;
typedef struct variable{
    char* var_name;
    int var_value;

}Var;

typedef struct function{
    char* fun_name;
    int paraCount;
    char** params;
    Node* funBody;
}Fun;

//store different variable value
Var varRecord[100];
int varCurrentPointer = -1;
//store different function value
Fun funRecord[100];
int funCurrentPointer = -1;

Node* CreateExpNode(int value, char* name, enum expType);
int CountExpValue(Node* exp);
int getVarRecordPointer(char *name);
int getFunRecordPointer(char *name);
void createVar(char* name, int exp_value);
Fun* createFun();


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
%type <exp_node> exps_a exps_mul exps_equal exps_or
%type <exp_node> and_op or_op not_op
%type <exp_node> variable 
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
plus : '(' ADD exp exps_a ')' {
        Node* newNode = CreateExpNode(0, "", plusType);
        newNode->left = $3;
        newNode->right = $4;
        $$ = newNode;
    }
    ;
exps_a : exp {$$ = $1;}
       | exps_a exp {
           Node* newNode = CreateExpNode(0, "", plusType);
           newNode->left = $1;
           newNode->right = $2;
           $$ = newNode;
       }
       ;
minus : '(' SUB exp exp ')' {
        Node* newNode = CreateExpNode(0, "", minusType);
        newNode->left = $3;
        newNode->right = $4;
        $$ = newNode;
      }
      ;
multiply : '(' MUL exp exps_mul ')' {
            Node* newNode = CreateExpNode(0, "", mulType);
            newNode->left = $3;
            newNode->right = $4;
            $$ = newNode;
         }
         ;
exps_mul : exp {$$ = $1;}
         | exps_mul exp {
            Node* newNode = CreateExpNode(0, "", mulType);
            newNode->left = $1;
            newNode->right = $2;
            $$ = newNode;

         }
         ;
divide : '(' DIV exp exp ')' {
            Node* newNode = CreateExpNode(0, "", divType);
            newNode->left = $3;
            newNode->right = $4;
            $$ = newNode;
        }
        ;
modulus : '(' MOD exp exp ')' {
            Node* newNode = CreateExpNode(0, "", modType);
            newNode->left = $3;
            newNode->right = $4;
            $$ = newNode;
        }
        ;
greater : '(' GREATER exp exp ')' {
            Node* newNode = CreateExpNode(0, "", greaterType);
            newNode->left = $3;
            newNode->right = $4;
            $$=newNode;
        }
        ;
smaller : '(' SMALLER exp exp ')' {
            Node* newNode = CreateExpNode(0, "", smallerType);
            newNode->left = $3;
            newNode->right = $4;
            $$=newNode;
        }
        ;
equal : '(' EQUAL exp exps_equal ')' {
            Node* newNode = CreateExpNode(0, "", equalType);
            newNode->left = $3;
            newNode->right = $4;
            $$=newNode;
        }
        ;
exps_equal : exp exps_equal {
            Node* newNode = CreateExpNode(0, "", equalType);
            newNode->left = $1;
            newNode->right = $2;
            $$=newNode;
          }
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
and_op : '(' AND exp exps_a ')' {
            Node* newNode = CreateExpNode(0,"",andType);
            newNode->left = $3;
            newNode->right = $4;
            $$ = newNode;
        }
        ;
exps_a : exp {$$ = $1;}
       | exp exps_a {
            Node* newNode = CreateExpNode(0,"",andType);
            newNode->left = $1;
            newNode->right = $2;
            $$ = newNode;
       }
       ;
or_op : '(' OR exp exps_or ')' {
            Node* newNode = CreateExpNode(0,"",orType);
            newNode->left = $3;
            newNode->right = $4;
            $$ = newNode;
      }
      ;
exps_or : exp exps_or {
            Node* newNode = CreateExpNode(0,"",orType);
            newNode->left = $1;
            newNode->right = $2;
            $$ = newNode;
        }
        | exp {$$ = $1;}
        ;
not_op : '(' NOT exp ')' {
            Node* newNode = CreateExpNode(0,"",notType);
            newNode->left = $3;
            $$ = newNode;
        }
        ;
define_stmt : '(' DEFINE ID exp ')' {
                //printf("define_stmt\n");
                /*if($4->type == functionType)
                {
                    //create function record here
                }
                else if($4->type == variableType)
                    createVar($3, CountExpValue($4));*/
                int varPos = getVarRecordPointer($3);
                if(varPos == -1)
                    createVar($3, CountExpValue($4));
                else
                    varRecord[varPos].var_value = CountExpValue($4);
            }
            ;
variable : ID {
            //printf("variable_ ID\n");
            int varPos = getVarRecordPointer($1);
            int varValue = varRecord[varPos].var_value;
            Node* newNode = CreateExpNode(varValue,$1,variableType);
            $$ = newNode;
        }
         ;
fun_exp : '(' FUN fun_ids fun_body ')' {
            //pass the params into the function
        }
        ;
fun_ids : '(' ids ')' {
            $$ = $2;
        }
        ;
ids : ids ID {

    }
    | ID {

    }
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
fun_name : variable {
            //$$ = getVarRecordPointer($1->name);
         }
         ;
if_exp : '(' IF test_exp then_exp else_exp ')' {
            int boolValue = CountExpValue($3);
            if(boolValue == 1)
                $$ = $4;
            else
                $$ = $5;
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
//create and init node value
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
//count the current exp value (pre-order traversal)
int CountExpValue(Node* exp)
{
    if(exp == NULL)
        return 0;
    int right=0, left=0, temp;
    right = CountExpValue(exp->right);
    left = CountExpValue(exp->left);
    switch(exp->type){
        case numberType:
            return exp->value;
        case plusType:
            return left+right;
        case minusType:
            return left-right;
        case mulType:
            return left*right;
        case divType:
            return left/right;
        case modType:
            return left%right;
        case greaterType:
            return left>right;
        case smallerType:
            return left<right;
        case equalType:
            return left==right;
        case andType:
            return left&&right;
        case orType:
            return left||right;
        case notType:
            return !left;
        case variableType:
            temp = getVarRecordPointer(exp->name);
            return varRecord[temp].var_value;
        case functionType:
            break;
        default:
            return 0;
    }

}
int getVarRecordPointer(char *name)
{
    for(int i=0;i<=varCurrentPointer;i++)
    {
        //find variable position
        if(strcmp(name, varRecord[i].var_name) == 0)
            return i;
    }
    //can't find this variable (name)
    return -1;
}
int getFunRecordPointer(char *name)
{
    for(int i=0;i<=funCurrentPointer;i++)
    {
        //find variable position
        if(strcmp(name, funRecord[i].fun_name) == 0)
            return i;
    }
    //can't find this function (name)
    return -1;
}
void createVar(char* name, int exp_value)
{
    Node* newNode = CreateExpNode(exp_value,name, variableType);
    int varPos = getVarRecordPointer(name);
    //variable name not find(not declare yet)
    if(varPos == -1)
    {
        varCurrentPointer++;
        varRecord[varCurrentPointer].var_name = name;
        varRecord[varCurrentPointer].var_value = exp_value;
    }
}
Fun* createFun()
{
    Fun* fun = malloc(sizeof(Fun));
    return fun;
}
void addFunctionPara(Fun* fun, char* para)
{
    fun->params[fun->paraCount] = malloc((strlen(para)+1) * sizeof(char));
    strcpy(fun->params[fun->paraCount], para);
    fun->paraCount += 1;
    return;
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