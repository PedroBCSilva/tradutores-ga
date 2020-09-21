%option noyywrap

%{

#include <stdio.h>
#include <string.h>

#include "common/rulesControl.h"

RulesControl rules;

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
ARITHMETIC_OPERATOR {SUM_OP}|{SUB_OP}|{MULT_OP}|{DIV_OP}
SPECIAL_CHARACTERS (\(|\)|\{|\}|,|;|#)

TYPE (int|byte|boolean|char|long|float|double|short|string|void)
RESERVED_KEYWORD ({TYPE}|abstract|assert|break|case|class|const|continue|default|enum|extends|false|final|goto|implements|import|instanceof|interface|native|new|null|package|private|protected|public|return|static|strictfp|super|synchronized|this|throw|throws|transient|true|volatile|include)
RESERVED_KEYWORD_WITH_OPENING_CHARACTER (clrscr|scanf|print|printf|catch|do|else|for|finally|if|switch|try|while|getch)

VARIABLE ({TYPE}(\*)?{SINGLE_SPACE}(\*)?(\ )*{LETTERS_AND_DIGITS}(,(\ )*(\*)?(\ )*{LETTERS_AND_DIGITS})*(\ )*;)
ARGUMENT (\({TYPE}(\*)?{SINGLE_SPACE}(\*)?(\ )*{LETTERS_AND_DIGITS}(\ )*(,(\ )*{TYPE}(\*)?(\ )*(\*)?(\ )*{LETTERS_AND_DIGITS})*\))

SPACES_AND_TABS ([ \t\n\r])
COMMENT ("//".*)
COMMENT_BLOCK ("/*"[^*/]*"*/")

%%

{COMMENT_BLOCK}
{COMMENT}
{STRING_LITERAL} rules.stringLiteralRule();
{DIGIT} rules.digitRule();
{FLOAT_NUM} rules.floatNumRule();
{RESERVED_KEYWORD} rules.reservedWordRule();
{RESERVED_KEYWORD_WITH_OPENING_CHARACTER}/(\ )?{SPECIAL_CHARACTERS} rules.reservedWordRule();
{VARIABLE} rules.variableDeclarationRule();
{ARGUMENT} rules.argumentRule();
{SPECIAL_CHARACTERS} rules.specialCharsRule();
{RELATIONAL_OP} rules.relationalOpRule();
{LOGICAL_OP} rules.logicalOpRule();
{ARITHMETIC_OPERATOR} rules.arithmeticOpRule();
{LETTERS_AND_DIGITS} rules.variableLookupRule();
{SPACES_AND_TABS}

%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	return 0;
}
