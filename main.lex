%option noyywrap

%{

#include <stdio.h>
#include <time.h>
#include <string.h>
#include <string>

using namespace std;

int operations = 0;
int variable = 0;

void castIntToString(int number, char* string){
	sprintf(string, "%d", number);
}

void printKeyword(char* keyword, char* word){
	printf("[%s, %s]", keyword, word);
}

void removeSubstr (char *string, char *sub) {
	char *match;
	int len = strlen(sub);
	while ((match = strstr(string, sub))) {
		*match = '\0';
		strcat(string, match+len);
	}
}

void stringSplit(char* string, char* token){
	char *part = strtok(string, token);
	while(part != NULL)
	{
		variable++;
		char stringId[50];
		castIntToString(variable, stringId);
		printKeyword("id", stringId);
		part = strtok(NULL, token);
	}
}

void commentLine(){
}

void spaces(){
}

%}

DIGIT [0-9]+
LETTERS_AND_DIGITS [a-zA-Z0-9]*

EQUAL_OP [=]
RELATIONAL_OP (\ )*{EQUAL_OP}|==|>=|<=|=(\ )*
SINGLE_SPACE (\ )+
FLOAT_NUM [0-9]+[.][0-9]+

SUM_OP [+]
SUB_OP [-]
MULT_OP [*]
DIV_OP [/]

TYPE (int|byte|boolean|char|long|float|double|short)
RETURN_TYPE 			(void|{TYPE})(\ )+
RESERVED_KEYWORD ({TYPE}|print|printf|abstract|assert|break|case|catch|class|const|continue|default|do|else|enum|extends|false|final|finally|for|goto|if|implements|import|instanceof|interface|native|new|null|package|private|protected|public|return|static|strictfp|super|switch|synchronized|this|throw|throws|transient|true|try|volatile|while)

VARIABLE ({TYPE}{SINGLE_SPACE}{LETTERS_AND_DIGITS}(,(\ )*{LETTERS_AND_DIGITS})*)

ARITHMETIC_OPERATOR {SUM_OP}|{SUB_OP}|{MULT_OP}|{DIV_OP}
OPERATION {DIGIT}{ARITHMETIC_OPERATOR}{DIGIT}[{ARITHMETIC_OPERATOR}{DIGIT}]*

SPACES_AND_TABS [ \t\n\r]
COMMENT ["//"].*

COMMENT_BLOCK "/*"[^*/]*"*/"

%%
{VARIABLE}{EQUAL_OP}{OPERATION} operations++;

{RESERVED_KEYWORD} {
	printKeyword("reserved_word", yytext);
}

{COMMENT} {
   commentLine();
}
{COMMENT_BLOCK} {
   commentLine();
}

{SPACES_AND_TABS} {
    spaces();
}

{RELATIONAL_OP} {
	string word(yytext);
	if(!word.compare("=")){
		printKeyword("Equal_Op", yytext);
	}else{
		printKeyword("Relational_Op", yytext);
	}
}

{VARIABLE} {
	string typeWord(yytext);
	char* c_typeWord = typeWord.c_str();
	strtok(c_typeWord, " ");
	printKeyword("reserved_word", c_typeWord);
	stringSplit(yytext,",");
}

{DIGIT} {
	printKeyword("num", yytext);
}

{FLOAT_NUM} {
	printKeyword("float_num", yytext);
}

{ARITHMETIC_OPERATOR} {
	printKeyword("arithmetic_operator", yytext);
}

%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	printf("Amount of operations: %d\n", operations);
	return 0;
}

