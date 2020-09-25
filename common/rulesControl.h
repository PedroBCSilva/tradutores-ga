#ifndef RULESCONTROL_H
#define RULESCONTROL_H

#include <string>
#include <stdio.h>
#include <string.h>
#include <string>
#include <map>
#include <sstream>
#include <vector>

#include "stringControl.h"
#include "scope.h"

using namespace std;

class RulesControl
{
    private:
        map<string, string> specialCharacters = {{"[", "l_bracket"},{"]", "r_bracket"},{"(", "l_paren"}, {")", "r_paren"}, {"{", "l_curly_bracket"}, {"}", "r_curly_bracket"}, {",", "comma"}, {";", "semicolon"}, {"&", "ampersand"}, {"#", "hashtag"}};
        int variableIds = 0;
        int methodIds = 0;
        Scope* globalScope = new Scope("global");
        Scope* currentScope = globalScope;
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

    void addMethod(string name){
        stringcontrol::removeSpecialChars(&name);
        currentScope = new Scope(name);
        globalScope->addMethod(currentScope);
        stringcontrol::printKeyword("id",to_string(globalScope->getLastId()).c_str());
        stringcontrol::printKeyword("l_paren","(");
    }

    void methodDeclarationRule() {
        string word(yytext);
        vector<string> splitted = stringcontrol::stringSplit(word.c_str(),' ');
        string type = splitted.at(0);
        stringcontrol::printKeyword("reserved_word", type.c_str());
        stringcontrol::removeSubstr(&type, &word);
        stringcontrol::removeSpecialChars(&word);
        addMethod(word);
    }

    void variableDeclarationRule() {
        string word(yytext);
        vector<string> splitted = stringcontrol::stringSplit(word.c_str(),' ');
        string type = splitted.at(0);
        stringcontrol::printKeyword("reserved_word", type.c_str());
        stringcontrol::removeSubstr(&type, &word);
        splitted = stringcontrol::stringSplit(word.c_str(),',');
        for(string& part : splitted) {
            currentScope->addVariable(part);
        }
    }

    void variableLookupRule(){
        string word(yytext);
        int id = globalScope->find(word);
        if (id >= 0) {
            stringcontrol::printKeyword("id", ( to_string(globalScope-> id) + "." +  to_string(id)).c_str());
        } else {
            id = currentScope -> find(word);
            if (id >= 0) {
                stringcontrol::printKeyword("id", ( to_string(currentScope-> id) + "." +  to_string(id)).c_str());
            }else{
            printf("%s",yytext);
            }
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
            currentScope->addVariable(part);
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
        string includeText = text.substr (startText + 1, endText-startText-1);
        stringcontrol::printKeyword("Relational_Op", "<");
        stringcontrol::printKeyword("string_literal", includeText.c_str());
        stringcontrol::printKeyword("Relational_Op", ">");
    }
};
#endif
