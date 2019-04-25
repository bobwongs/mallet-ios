//
//  Converter.hpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/17.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#ifndef Converter_hpp
#define Converter_hpp

#include "cpp.hpp"
#include <stdio.h>
#include <set>
#include <string>
#include <unordered_map>

int ConvertBlock(std::string code[], int codeMaxSize, int convertedCode[], int convertedCodeMaxSize, int firstIndex,
        std::set<char> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord,
        std::unordered_map<std::string, int> &numberVariableAddress, int &numberVariableNum, std::unordered_map<std::string, int> &stringVariableAddress, int &stringVariableNum, std::unordered_map<std::string, int> &variableType);

int ConvertAction(std::string code[], int codeMaxSize, int convertedCode[], int convertedCodeMaxSize, int firstIndex,
        std::set<char> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord,
        std::unordered_map<std::string, int> &numberVariableAddress, int &numberVariableNum, std::unordered_map<std::string, int> &stringVariableAddress, int &stringVariableNum, std::unordered_map<std::string, int> &variableType);

int ConvertFormula(std::string code[], int codeMaxSize, int convertedCode[], int convertedCodeMaxSize, int firstIndex,
        std::set<char> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord,
        std::unordered_map<std::string, int> &numberVariableAddress, int &numberVariableNum, std::unordered_map<std::string, int> &stringVariableAddress, int &stringVariableNum, std::unordered_map<std::string, int> &variableType);

int ConvertValue(std::string code[], int codeMaxSize, int convertedCode[], int convertedCodeMaxSize, int firstIndex,
        std::set<char> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord,
        std::unordered_map<std::string, int> &numberVariableAddress, int &numberVariableNum, std::unordered_map<std::string, int> &stringVariableAddress, int &stringVariableNum, std::unordered_map<std::string, int> &variableType);

std::string ConvertString(std::string code[], int codeMaxSize, int convertedCode[], int convertedCodeMaxSize, int firstIndex,
        std::set<char> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord,
        std::unordered_map<std::string, int> &numberVariableAddress, int &numberVariableNum, std::unordered_map<std::string, int> &stringVariableAddress, int &stringVariableNum, std::unordered_map<std::string, int> &variableType);

int convertOperator(std::string operatorString);

#endif /* Converter_hpp */
