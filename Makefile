CC = gcc
LEX = lex
YACC = yacc

polyline: y.tab.c y.tab.h lex.yy.c
    $(CC) y.tab.c lex.yy.c -o polyline -lm

y.tab.c: polyline.y
    $(YACC) -d polyline.y

y.tab.h: polyline.y
    $(YACC) -d polyline.y

lex.yy.c: polyline.l
    $(LEX) polyline.l

clean:
    rm -rf polyline y.tab.c y.tab.h lex.yy.c
