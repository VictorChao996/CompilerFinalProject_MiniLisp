all:
		bison -d -o y.tab.c ex1.y
		gcc -c -g -I.. y.tab.c 
		flex -o lex.yy.c ex1.l
		gcc -c -g -I.. lex.yy.c
		gcc -o ex1 y.tab.o lex.yy.o -ll