%option noyywrap

%{

#include <stdio.h>
#include <time.h>

int operations = 0;
%}

DIGIT [0-9]+
VARIABLE [a-zA-Z][a-z0-9]*

EQUAL_OP [=]
SUM_OP [+]
SUB_OP [-]
MULT_OP [*]
DIV_OP [/]

OPERATOR {SUM_OP}*|{SUB_OP}*|{MULT_OP}*|{DIV_OP}*

EXPRESSION {DIGIT}{OPERATOR}{DIGIT}[{OPERATOR}{DIGIT}]*

RESERVED_KEYWORD abstract|assert|boolean|break|byte|case|catch|char|class|const|continue|default|double|do|else|enum|extends|false|final|finally|float|for|goto|if|implements|import|instanceof|int|interface|long|native|new|null|package|private|protected|public|return|short|static|strictfp|super|switch|synchronized|this|throw|throws|transient|true|try|void|volatile|while

%%

{VARIABLE}{EQUAL_OP}{EXPRESSION} operations++;

{RESERVED_KEYWORD} {
	printf("[reserved_word, %s]", yytext);
}

%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	printf("Amount of operations: %d\n", operations);
	return 0;
}
