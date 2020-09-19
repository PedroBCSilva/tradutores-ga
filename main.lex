%option noyywrap

%{

#include <stdio.h>
#include <time.h>
#include <string.h>
#include <string>
#include <map>

int operations = 0;
int variable = 0;

std::map<std::string, std::string> specialCharacters = {{"(", "l_paren"}, {")", "r_paren"}, {"{", "l_bracket"}, {"}", "​r_bracket"}, {",", "comma"}, {";", "semicolon"}};

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

SPECIAL_CHARACTERS (\(|\)|\{|\}|,|;)

TYPE (int|byte|boolean|char|long|float|double|short)
RETURN_TYPE 			(void|{TYPE})(\ )+

RESERVED_KEYWORD ({TYPE}|abstract|assert|break|case|class|const|continue|default|enum|extends|false|final|goto|implements|import|instanceof|interface|native|new|null|package|private|protected|public|return|static|strictfp|super|synchronized|this|throw|throws|transient|true|volatile)
RESERVED_KEYWORD_WITH_OPENING_CHARACTER (print|printf|catch|do|else|for|finally|if|switch|try|while)(\ )?

VARIABLE ({TYPE}{SINGLE_SPACE}{LETTERS_AND_DIGITS}(,(\ )?{LETTERS_AND_DIGITS})*)
ARITHMETIC_OPERATOR {SUM_OP}|{SUB_OP}|{MULT_OP}|{DIV_OP}
OPERATION {DIGIT}{ARITHMETIC_OPERATOR}{DIGIT}[{ARITHMETIC_OPERATOR}{DIGIT}]*

SPACES_AND_TABS [ \t\n\r]
COMMENT ["//"].*

COMMENT_BLOCK "/*"[^*/]*"*/"

%%

{SPECIAL_CHARACTERS} {
	std::string text(yytext);
	std::string identifiedSpecialCharacter = specialCharacters[text];
	printf("[%s, %s]", &identifiedSpecialCharacter[0], yytext);
}

{VARIABLE}{EQUAL_OP}{OPERATION} operations++;

{RESERVED_KEYWORD} {
	printKeyword("reserved_word", yytext);
}

{COMMENT}
{COMMENT_BLOCK}
{SPACES_AND_TABS}

{RELATIONAL_OP} {
	if(!strcmp("=",yytext)){
		printKeyword("Equal_Op", yytext);
	}else{
		printKeyword("Relational_Op", yytext);
	}
}

{RESERVED_KEYWORD_WITH_OPENING_CHARACTER}[{SPECIAL_CHARACTERS}]? {
	if (yytext[strlen(yytext) - 1] == ' ')
		yytext[strlen(yytext) - 1] = '\0';
	printKeyword("reserved_word", yytext);
}

{VARIABLE} {
	char typeWord[100];
	memset(typeWord, '\0', sizeof(typeWord));
	strcpy(typeWord, yytext);
	strtok(typeWord, " ");
	printKeyword("reserved_word", typeWord);
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

