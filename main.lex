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

map<string, string> specialCharacters = {{"(", "l_paren"}, {")", "r_paren"}, {"{", "l_bracket"}, {"}", "​r_bracket"}, {",", "comma"}, {";", "semicolon"}, {"&", "ampersand"}};

int operations = 0;
int variableIds = 0;
map<string, int> variables;

void addVariable(string name){
	variableIds++;
	stringcontrol::removeSpecialChars(&name);
	variables[name] = variableIds;
	stringcontrol::printKeyword("id", to_string(variableIds).c_str());
}

%}

STRING_LITERAL (\"[^\n"]+\")
DIGIT [0-9]+
LETTERS_AND_DIGITS [a-zA-Z0-9]*

RELATIONAL_OP (\ )*(==|>=|<=|=|<|>|!==)(\ )*
LOGICAL_OP (\ )*(&&|\|\|)(\ )*
SINGLE_SPACE (\ )+
FLOAT_NUM [0-9]+[.][0-9]+

SUM_OP [+]
SUB_OP [-]
MULT_OP [*]
DIV_OP [/]

SPECIAL_CHARACTERS (\(|\)|\{|\}|,|;)

TYPE (int|byte|boolean|char|long|float|double|short|string|void)

RESERVED_KEYWORD ({TYPE}|abstract|assert|break|case|class|const|continue|default|enum|extends|false|final|goto|implements|import|instanceof|interface|native|new|null|package|private|protected|public|return|static|strictfp|super|synchronized|this|throw|throws|transient|true|volatile)
RESERVED_KEYWORD_WITH_OPENING_CHARACTER (clrscr|scanf|print|printf|catch|do|else|for|finally|if|switch|try|while|getch)

VARIABLE ({TYPE}(\*)?{SINGLE_SPACE}(\*)?(\ )*{LETTERS_AND_DIGITS}(,(\ )*(\*)?(\ )*{LETTERS_AND_DIGITS})*(\ )*;)
ARGUMENT (\({TYPE}(\*)?{SINGLE_SPACE}(\*)?(\ )*{LETTERS_AND_DIGITS}(\ )*(,(\ )*{TYPE}(\*)?(\ )*(\*)?(\ )*{LETTERS_AND_DIGITS})*\))

ARITHMETIC_OPERATOR {SUM_OP}|{SUB_OP}|{MULT_OP}|{DIV_OP}

SPACES_AND_TABS [ \t\n\r]
COMMENT "//".*
COMMENT_BLOCK ("/*"[^*/]*"*/")

%%
{COMMENT_BLOCK}
{COMMENT}

{STRING_LITERAL} {
	char literalString[100];
	int i=0;
    int j=0;
    strcpy(literalString, yytext);
    char temp[100] = {};
      for(i=1;i<strlen(literalString)-1;i++){
        temp[j++]=literalString[i];
      }
      strcpy(literalString,temp);
	stringcontrol::printKeyword("string_literal", literalString);
}

{DIGIT} {
	stringcontrol::printKeyword("num", yytext);
}

{FLOAT_NUM} {
	stringcontrol::printKeyword("float_num", yytext);
}

{RESERVED_KEYWORD} {
	stringcontrol::printKeyword("reserved_word", yytext);
}

{RESERVED_KEYWORD_WITH_OPENING_CHARACTER}/(\ )?{SPECIAL_CHARACTERS} {
	stringcontrol::printKeyword("reserved_word", yytext);
}

{VARIABLE} {
	string word(yytext);
	vector<string> splitted = stringcontrol::stringSplit(word.c_str(),' ');
	string type = splitted.at(0);
	stringcontrol::printKeyword("reserved_word", type.c_str());
	stringcontrol::removeSubstr(&type, &word);
	splitted = stringcontrol::stringSplit(word.c_str(),',');
	for(string& part : splitted) {
		addVariable(part);
	}
}

{ARGUMENT} {
	string word(yytext);
	vector<string> splitted = stringcontrol::stringSplit(word.c_str(),',');
	for(string& part : splitted) {
		stringcontrol::rtrim(part);
		stringcontrol::ltrim(part);
		vector<string> splitted = stringcontrol::stringSplit(part.c_str(),' ');
		string type = splitted.at(0);
		stringcontrol::removeSpecialChars(&type);
		stringcontrol::printKeyword("reserved_word", type.c_str());
		stringcontrol::removeSubstr(&type, &part);
		addVariable(part);
	}
}

{SPECIAL_CHARACTERS} {
	string text(yytext);
	string identifiedSpecialCharacter = specialCharacters[text];
	printf("[%s, %s]", &identifiedSpecialCharacter[0], yytext);
}

{RELATIONAL_OP} {
	string word(yytext);
	if(!word.compare("=")){
		stringcontrol::printKeyword("Equal_Op", yytext);
	}else{
		stringcontrol::printKeyword("Relational_Op", yytext);
	}
}

{LOGICAL_OP} {
	stringcontrol::printKeyword("logic_op", yytext);
}

{ARITHMETIC_OPERATOR} {
	stringcontrol::printKeyword("arithmetic_operator", yytext);
}

{LETTERS_AND_DIGITS} {
	string word(yytext);
  	map<string, int>::iterator it;
	it = variables.find(word);
	if (it != variables.end()) {
		stringcontrol::printKeyword("id", to_string(it->second).c_str());
	} else {
		printf("%s",yytext);
	}
}

{SPACES_AND_TABS}
%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	return 0;
}
