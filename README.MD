# Lexical Analyser 
### Setting up your environment
This project uses the tool [Flex](https://github.com/westes/flex) which is a tool for generating scanners: programs which recognize lexical patterns in text. 
* For Mac user
    * `brew install flex`
    * Install `Command Line Tools` from Xcode since we will use `g++` as an `C++` compiler 

Also we've found this Visual Code Extension that can be pretty helpful [Lex Flex Yacc Bison](https://marketplace.visualstudio.com/items?itemName=faustinoaq.lex-flex-yacc-bison). 

------

### How to run
For those who are not familiar with Flex we created a script to build the `main.lex` and run it on `sampleCode.txt` found on the project.