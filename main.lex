%option noyywrap

%{

#include <stdio.h>
#include <time.h>

int numlines = 0;
int numchars = 0;

%}

%%

\n	numlines++; numchars++;
.	numchars++;

%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	printf("Character number: %d\n", numchars);
	printf("Amount of lines: %d\n", numlines);
	return 0;
}
