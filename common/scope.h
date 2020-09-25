#ifndef METHOD_H
#define METHOD_H

#include <string>
#include <vector>
#include "stringControl.h"

using namespace std;

class Scope
{
    public:
        Scope(int id, string name){
            this -> id = id;
            this -> name = name;
        }
        Scope(string name){
            this-> name = name;
        }

        int id;
        string name;
        vector<Scope*> variables;

        void addVariable(string name){
            this -> variableIds++;
            stringcontrol::removeSpecialChars(&name);
            variables.push_back(new Scope(this -> variableIds, name));
            stringcontrol::printKeyword("id", ( to_string(this-> id )+ "." +  to_string( this -> variableIds)).c_str());
        }

        void addMethod(Scope* method){
            this -> variableIds++;
            method->id = variableIds;
            variables.push_back(method);
        }

        int find(string name){
            for(Scope* variable : variables){
                if(!variable -> name.compare(name)){
                    return variable -> id;
                }
            }
            return -1;
        }

        int getLastId(){
            return this -> variableIds;
        }
    
    private:
        int variableIds = 0;
};
#endif
