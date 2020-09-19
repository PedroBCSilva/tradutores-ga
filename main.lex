%option noyywrap

%{

#include <stdio.h>
#include <time.h>
#include <string>
#include <sstream>
#include <vector>
#include <map>
#include "common/stringControls.h"

using namespace std;

int operations = 0;
int variableIds = 0;
map<int, string> variables;

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
	stringcontrol::printKeyword("reserved_word", yytext);
}

{COMMENT} {
   commentLine();
}
{COMMENT_BLOCK} {
   commentLine();
}

{RELATIONAL_OP} {
	string word(yytext);
	if(!word.compare("=")){
		stringcontrol::printKeyword("Equal_Op", yytext);
	}else{
		stringcontrol::printKeyword("Relational_Op", yytext);
	}
}

{VARIABLE} {
	string word(yytext);
	vector<string> splitted = stringcontrol::stringSplit(word.c_str(),' ');
	string type = splitted.at(0);
	stringcontrol::printKeyword("reserved_word", type.c_str());
	stringcontrol::removeSubstr(&type, &word);
	splitted = stringcontrol::stringSplit(word.c_str(),',');
	for(string& part : splitted) {
		variableIds++;
		stringcontrol::ltrim(part);
    	stringcontrol::rtrim(part);
		variables[variableIds] = part;
		stringcontrol::printKeyword("id", to_string(variableIds).c_str());
	}
}

{DIGIT} {
	stringcontrol::printKeyword("num", yytext);
}

{FLOAT_NUM} {
	stringcontrol::printKeyword("float_num", yytext);
}

{ARITHMETIC_OPERATOR} {
	stringcontrol::printKeyword("arithmetic_operator", yytext);
}

%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	printf("Amount of operations: %d\n", operations);
	for (std::map<int, string>::iterator it = variables.begin(); it != variables.end(); ++it)
	{
		stringcontrol::printKeyword(to_string(it->first).c_str(), it->second.c_str());
	}
	return 0;
}

