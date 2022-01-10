# Compiler final project- MiniLisp interpreter
## Implement Feature:
- Syntax Validation
- Print
- Numberical Operations
- Logical Operations
- if Expression
- Variable Definition
- Redefine Variable

## How to run
- 使用附件Makefile,在terminal中直接輸入 make 指令 
- 或手動輸入以下指令
    - 注意: 指令需與本地檔案同名
    ```
        all:
		    bison -d -o mini.tab.c mini.y
		    gcc -c -g -I.. mini.tab.c 
		    flex -o lex.yy.c mini.l
		    gcc -c -g -I.. lex.yy.c
		    gcc -o miniLisp mini.tab.o lex.yy.o -ll
        clean:
		    rm -rf *o miniLisp
    ```
- make 之後直接把文字資料餵給執行檔
    ```
    miniLisp < input.txt
    ```
## Example (lisp script --> interpreter result)
(print-num 10)  --> 10  
(print-bool #t) --> #t  
(print-num (+ 7 8)) --> 15  
(print-bool (and #t #t #f)) --> #f  
(print-num (if #t 1 2)) --> 1  
(print-num (if (> 5 2) 10 20)) --> 10  
(define x 100)  
(define y 500)  
(print-num (+ x y))  --> 600  
(define x 55)    
(print-num x)  --> 55  