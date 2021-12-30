all:
		bison -d -o mini.tab.c mini.y
		gcc -c -g -I.. mini.tab.c 
		flex -o lex.yy.c mini.l
		gcc -c -g -I.. lex.yy.c
		gcc -o miniLisp mini.tab.o lex.yy.o -ll
clean:
		rm -rf *o miniLisp