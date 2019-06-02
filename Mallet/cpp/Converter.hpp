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

typedef struct
{
    std::set<std::string> &symbol;
    std::set<std::string> &doubleSymbol;
    std::set<std::string> &reservedWord;

    std::unordered_map<std::string, int> &numberVariableAddress;
    int &numberVariableNum;
    std::unordered_map<std::string, int> &stringVariableAddress;
    int &stringVariableNum;

    std::unordered_map<std::string, int> &variableType;

    bool isDefinitionOfGlobalVariable;

    Converter &converter;
} ArgData;

typedef struct
{
    int id;
    int varAddress;
    int originalCodeSize;
    int convertedCodeSize;
    int tmpVarNum;
} TmpVarData;

typedef struct
{
    int id;
    int value;
} ValueData;

typedef struct
{
    int originalCodeSize;
    int convertedCodeSize;
} ConvertedCodeData;

int ConvertBlock(std::string code[], int codeMaxSize, int codeFirstIndex, int convertedCode[], int convertedCodeMaxSize, int convertedCodeFirstIndex,
                 ArgData argData);

ConvertedCodeData ConvertAction(std::string code[], int codeMaxSize, int codeFirstIndex, int convertedCode[], int convertedCodeMaxSize, int convertedCodeFirstIndex,
                                ArgData argData);

TmpVarData ConvertFormula(std::string code[], int codeMaxSize, int codeFirstIndex, int convertedCode[], int convertedCodeMaxSize, int convertedCodeFirstIndex,
                          ArgData argData, int tmpVarNum, int operatorNumber);

ValueData ConvertValue(std::string code[], int codeMaxSize, int codeFirstIndex,
                       ArgData argData, int tmpVarNum);

std::string ConvertString(std::string code[], int codeMaxSize, int codeFirstIndex, int convertedCode[], int convertedCodeMaxSize, int convertedCodeFirstIndex,
                          ArgData argData);

int convertOperator(std::string operatorString);

void AddCode(int convertedCode[], int convertedCodeMaxSize, int &convertedCodeIndex, int code);

#endif /* Converter_hpp */
