#include <string>
#include <stdio.h>

using namespace std;

namespace stringcontrol
{
    void castIntToString(int number, char* string){
        sprintf(string, "%d", number);
    }

    void ltrim(string &s) {
        s.erase(s.begin(), std::find_if(s.begin(), s.end(), [](unsigned char ch) {
            return !std::isspace(ch);
        }));
    }

    void rtrim(string &s) {
        s.erase(std::find_if(s.rbegin(), s.rend(), [](unsigned char ch) {
            return !std::isspace(ch);
        }).base(), s.end());
    }

    void printKeyword(const char* keyword, const char* word){
        printf("[%s, %s]", keyword, word);
    }

    void removeSubstr (string *subString, string *originalString) {
        size_t subStringPostion = originalString->find(subString->c_str());
        if (subStringPostion != string::npos)
        {
            originalString->erase(subStringPostion, subString->length());
        }
    }

    vector<string> stringSplit(const char* base, char delim){
        vector<string> splitted;
        stringstream stream(base);
        string token;
        while (getline(stream, token, delim)) {
            splitted.push_back(token);
        }
        return splitted;
    }

    bool isSpecialChar(unsigned char c) {
        return (c == ' '  || c == '\n' || c == '\r' ||
                c == '\t' || c == '\v' || c == '\f' ||
                c == '*'  || c == ';'  || c == '['  ||
                c == ']'  || c == '('  || c == ')'  ||
                c == ',');
    }

    void removeSpecialChars(string *word){
        word->erase(remove_if(word->begin(), word->end(), isSpecialChar), word->end());
    }

};
