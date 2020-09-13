# Lexical Analyser 
### Setting up your environment
This project uses the tool [Flex](https://github.com/westes/flex) which is a tool for generating scanners: programs which recognize lexical patterns in text. 
* For Mac user
    * `brew install flex`
    * Install `Command Line Tools` from Xcode since we will use `gcc` as an `C` compiler 

Also I've found this Visual Code Extension that can be pretty helpful [Lex Flex Yacc Bison](https://marketplace.visualstudio.com/items?itemName=faustinoaq.lex-flex-yacc-bison). 

------
### How to run
For those who are not familiar using flex please use the following steps to run the project, using mac environment as example:
* `flex file.lex`
* `gcc lex.yy.c -o compiledFlexCode.out`
* `./compiledFlexCode.out input.txt`