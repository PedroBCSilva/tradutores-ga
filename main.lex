%option noyywrap

%{

#include <stdio.h>
#include <time.h>
#include <sstream>
#include <vector>
#include "common/stringControls.h"
#include <string.h>
#include <string>
#include <map>

using namespace std;

map<string, string> specialCharacters = {{"(", "l_paren"}, {")", "r_paren"}, {"{", "l_bracket"}, {"}", "​r_bracket"}, {",", "comma"}, {";", "semicolon"}};

int operations = 0;
int variableIds = 0;
map<int, string> variables;

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
RESERVED_KEYWORD_WITH_OPENING_CHARACTER (print|printf|catch|do|else|for|finally|if|switch|try|while)

VARIABLE ({TYPE}{SINGLE_SPACE}{LETTERS_AND_DIGITS}(,(\ )*{LETTERS_AND_DIGITS})*)

ARITHMETIC_OPERATOR {SUM_OP}|{SUB_OP}|{MULT_OP}|{DIV_OP}
OPERATION {DIGIT}{ARITHMETIC_OPERATOR}{DIGIT}[{ARITHMETIC_OPERATOR}{DIGIT}]*

SPACES_AND_TABS [ \t\n\r]
COMMENT ["//"].*

COMMENT_BLOCK "/*"[^*/]*"*/"

%%

{SPECIAL_CHARACTERS} {
	string text(yytext);
	string identifiedSpecialCharacter = specialCharacters[text];
	printf("[%s, %s]", &identifiedSpecialCharacter[0], yytext);
}

{VARIABLE}{EQUAL_OP}{OPERATION} operations++;

{RESERVED_KEYWORD} {
	stringcontrol::printKeyword("reserved_word", yytext);
}

{RESERVED_KEYWORD_WITH_OPENING_CHARACTER}/(\ )?{SPECIAL_CHARACTERS} {
	stringcontrol::printKeyword("reserved_word", yytext);
}

{COMMENT}
{COMMENT_BLOCK}
{SPACES_AND_TABS}

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

