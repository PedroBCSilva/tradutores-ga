#include <string>
#include <stdio.h>
#include <string.h>
#include <string>
#include <map>
#include <sstream>
#include <vector>

#include "stringControl.h"

using namespace std;

class RulesControl
{
    private:
        map<string, string> specialCharacters = {{"(", "l_paren"}, {")", "r_paren"}, {"{", "l_bracket"}, {"}", "r_bracket"}, {",", "comma"}, {";", "semicolon"}, {"&", "ampersand"}, {"#", "hashtag"}};
        int variableIds = 0;
        map<string, int> variables;
    public:
    void stringLiteralRule(){
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

    void addVariable(string name){
        variableIds++;
        stringcontrol::removeSpecialChars(&name);
        variables[name] = variableIds;
        stringcontrol::printKeyword("id", to_string(variableIds).c_str());
    }

    void variableDeclarationRule() {
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

    void variableLookupRule(){
        string word(yytext);
        map<string, int>::iterator it;
        it = variables.find(word);
        if (it != variables.end()) {
            stringcontrol::printKeyword("id", to_string(it->second).c_str());
        } else {
            printf("%s",yytext);
        }
    }

    void argumentRule(){ 
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

    void specialCharsRule(){
        string text(yytext);
        string identifiedSpecialCharacter = specialCharacters[text];
        printf("[%s, %s]", &identifiedSpecialCharacter[0], yytext);
    }

    void relationalOpRule(){
        string word(yytext);
        if(!word.compare("=")){
            stringcontrol::printKeyword("Equal_Op", yytext);
        }else{
            stringcontrol::printKeyword("Relational_Op", yytext);
        }
    }

    void logicalOpRule(){
        stringcontrol::printKeyword("logic_op", yytext);
    }

    void digitRule(){
        stringcontrol::printKeyword("num", yytext);
    }

    void floatNumRule(){
        stringcontrol::printKeyword("float_num", yytext);
    }

    void reservedWordRule(){
        stringcontrol::printKeyword("reserved_word", yytext);
    }

    void arithmeticOpRule(){
        stringcontrol::printKeyword("arithmetic_operator", yytext);
    }

    void includeRule(){
        string text(yytext);
        stringcontrol::printKeyword("hashtag","#");
        stringcontrol::printKeyword("reserved_word", "include");
        unsigned startText = text.find("<");
        unsigned endText = text.find(">");
        string includeText = text.substr (startText + 1, endText-startText);
        stringcontrol::printKeyword("Relational_Op", "<");
        stringcontrol::printKeyword("string_literal", includeText.c_str());
        stringcontrol::printKeyword("Relational_Op", ">");
    }
};
