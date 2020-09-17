flex -o TextLexicalAnalyzer.cpp main.lex 
g++ -std=c++11 -o TextLexicalAnalyzer TextLexicalAnalyzer.cpp -w
./TextLexicalAnalyzer sampleCode.txt