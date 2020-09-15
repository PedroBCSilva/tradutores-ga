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

%%

{VARIABLE}{EQUAL_OP}{EXPRESSION} operations++;

%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	printf("Amount of operations: %d\n", operations);
	return 0;
}
