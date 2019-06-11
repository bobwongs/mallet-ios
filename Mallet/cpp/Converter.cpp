//
//  Converter.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/12.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "Converter.hpp"
#include <string>
#include <set>
#include <vector>
#include <unordered_map>

void AddCode(int convertedCode[], int convertedCodeMaxSize, int &convertedCodeIndex, int code)
{
    if (convertedCodeIndex >= convertedCodeMaxSize)
    {
        return;
    }

    convertedCode[convertedCodeIndex] = code;
    convertedCodeIndex++;
}

ValueData ConvertValue(std::string code[], int codeMaxSize, int codeFirstIndex,
                       ArgData argData)
{
    int i = codeFirstIndex;

    int type = 0;
    int codeSize = 0;
    int valueOrAddress = 0;

    if (code[i][0] == '"')
    {
        //* 文字列

        std::string str = code[i]; //.substr(1, code[i].size() - 2);

        if (argData.stringVariableAddress[str] == 0)
        {
            argData.stringVariableNum++;
            argData.stringVariableAddress[str] = argData.stringVariableNum;
        }

        type = CmdID::StringVariableValue;
        codeSize = 3;
        valueOrAddress = argData.stringVariableAddress[str];

        i++;
    }
    else if (code[i] == std::to_string(atoi(code[i].c_str())))
    {
        //* 数値

        int value = 0;
        int coe = 1;

        for (int j = (int)code[i].size() - 1; j >= 0; j--)
        {
            if (j > 0 && ((code[i][j] - '0') < 0 || 9 < (code[i][j] - '0')))
            {
                //! 数値ではない
            }

            if (j == 0 && code[i][j] == '-')
            {
                value *= -1;
            }
            else
            {
                value += (code[i][j] - '0') * coe;
                coe *= 10;
            }
        }

        type = CmdID::IntValue;
        codeSize = 3;
        valueOrAddress = value;

        i++;
    }
    else
    {
        //* 変数

        switch (argData.variableType[code[i]])
        {
        case 1:
            //* 数値型
            type = CmdID::IntVariableValue;
            codeSize = 3;

            if (argData.numberVariableAddress[code[i]] == 0)
            {
                printf("The variable %s (Type:Int) is not declared!\n", code[i].c_str());
            }
            else
            {
                valueOrAddress = argData.numberVariableAddress[code[i]];
            }

            break;

        case 2:
            //* 文字列型
            type = CmdID::StringVariableValue;
            codeSize = 3;

            if (argData.stringVariableAddress[code[i]] == 0)
            {
                printf("The variable %s (Type:String) is not declared!\n", code[i].c_str());
            }
            else
            {
                valueOrAddress = argData.stringVariableAddress[code[i]];
            }

            break;

        case 3:
            //* 数値型(グローバル)
            type = CmdID::IntGlobalVariableValue;
            codeSize = 3;

            if (argData.converter.numberGlobalVariableAddress[code[i]] == 0)
            {
                printf("The global variable %s (Type:Int) is not declared!\n", code[i].c_str());
            }
            else
            {
                valueOrAddress = argData.converter.numberGlobalVariableAddress[code[i]];
            }

            break;

        case 4:
            //* 文字列型(グローバル)
            type = CmdID::StringGlobalVariableValue;
            codeSize = 3;

            if (argData.converter.stringGlobalVariableAddress[code[i]] == 0)
            {
                printf("The global variable %s (Type:String) is not declared!\n", code[i].c_str());
            }
            else
            {
                valueOrAddress = argData.converter.stringGlobalVariableAddress[code[i]];
            }

            break;

        default:
            printf("The variable %s is not declared!\n", code[i].c_str());
            break;
        }

        i++;
    }

    ValueData valueData;
    valueData.id = type;
    valueData.value = valueOrAddress;

    return valueData;
}

int convertOperator(std::string operatorString)
{
    int convertedCode = 0;

    if (operatorString == "+")
        convertedCode = CmdID::Sum;
    else if (operatorString == "-")
        convertedCode = CmdID::Sub;
    else if (operatorString == "*")
        convertedCode = CmdID::Mul;
    else if (operatorString == "/")
        convertedCode = CmdID::Div;
    else if (operatorString == "%")
        convertedCode = CmdID::Mod;
    else if (operatorString == "==")
        convertedCode = CmdID::Equal;
    else if (operatorString == "!=")
        convertedCode = CmdID::Inequal;
    else if (operatorString == ">")
        convertedCode = CmdID::Bigger;
    else if (operatorString == "<")
        convertedCode = CmdID::Lower;
    else if (operatorString == ">=")
        convertedCode = CmdID::BiggerAndEqual;
    else if (operatorString == "<=")
        convertedCode = CmdID::LowerAndEqual;
    else if (operatorString == "&&")
        convertedCode = CmdID::And;
    else if (operatorString == "||")
        convertedCode = CmdID::Or;
    else if (operatorString == "!")
        convertedCode = CmdID::Not;
    else
        printf("\"%s\" is not an operator!\n", operatorString.c_str());

    return convertedCode;
}

//2項演算OR単一の数値
//TODO:エラー処理
TmpVarData ConvertFormula(std::string code[], int codeMaxSize, int codeFirstIndex, int convertedCode[], int convertedCodeMaxSize, int convertedCodeFirstIndex,
                          ArgData argData, int tmpVarNum, int operatorNumber)
{
    TmpVarData tmpVarData;

    const std::vector<std::set<std::string>> operatorsPriorities = {
        {"||"},
        {"&&"},
        {"==", "!="},
        {"<", "<=", ">", ">="},
        {"+", "-"},
        {"*", "/", "%"},
        {"OPERATOR_END"},
    };

    std::vector<std::set<std::string>> operatorsPrioritiesAccum;

    for (int j = 0; j < operatorsPriorities.size(); j++)
    {
        operatorsPrioritiesAccum.push_back({});

        for (int k = 0; k < j; k++)
        {
            for (std::string l : operatorsPriorities[k])
                operatorsPrioritiesAccum[j].insert(l);
        }
    }

    int convertedCodeIndex = convertedCodeFirstIndex;
    int i = codeFirstIndex;

    int size = 0;

    int tmpVarAddress;

    std::vector<std::pair<int, int>> parts; //[start,end)

    std::vector<std::string> operators;

    for (int operatorIndex = operatorNumber; operatorIndex < operatorsPriorities.size(); operatorIndex++)
    {
        parts.clear();
        operators.clear();

        std::set<std::string> operatorsPriority = operatorsPriorities[operatorIndex];

        int bracketStack = 0;
        i = codeFirstIndex;

        i = codeFirstIndex;

        bool allBracket = true;

        while (i < codeMaxSize)
        {
            int start = i;
            int end = i;

            while (i < codeMaxSize)
            {
                //TODO:判定が不正確
                if (bracketStack == 0 && (operatorsPrioritiesAccum[operatorIndex].count(code[i]) > 0 || (operatorsPriority.count(code[i]) > 0 || code[i] == "," || code[i] == ")" || code[i] == "}") || (start < i && ((argData.symbol.count(code[i - 1]) == 0 && argData.doubleSymbol.count(code[i - 1]) == 0) || code[i - 1] == ")") && (argData.symbol.count(code[i]) == 0 && argData.doubleSymbol.count(code[i]) == 0))))
                {
                    break;
                }

                if (codeFirstIndex < i && bracketStack == 0)
                    allBracket = false;

                if (code[i] == "(")
                    bracketStack++;
                if (code[i] == ")")
                    bracketStack--;

                if (codeFirstIndex == i && bracketStack == 0)
                    allBracket = false;

                i++;
            }

            end = i;

            parts.push_back({start, end});

            if (operatorsPriority.count(code[i]))
            {
                operators.push_back(code[i]);
                allBracket = false;
            }
            else
                break;

            i++;
        }

        if (parts.size() == 1)
        {
            continue;
        }

        tmpVarAddress = tmpVarNum;
        tmpVarNum++;

        //* 初期化
        int nextOperatorIndex = operatorIndex + 1;

        TmpVarData nextTmpVarData = ConvertFormula(code, codeMaxSize, parts[0].first, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData, tmpVarNum, nextOperatorIndex);

        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::AssignIntTmpVariable);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 8);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::IntValue);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, tmpVarAddress);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, nextTmpVarData.id);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, nextTmpVarData.varAddress);

        for (int j = 1; j < parts.size(); j++)
        {
            int nextOperatorIndex = operatorIndex + 1;

            TmpVarData nextTmpVarData = ConvertFormula(code, codeMaxSize, parts[j].first, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData, tmpVarNum, nextOperatorIndex);

            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::AssignIntTmpVariable);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 13);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::IntValue);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, tmpVarAddress);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, convertOperator(operators[j - 1]));
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 8);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::IntTmpVariableValue);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, tmpVarAddress);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, nextTmpVarData.id);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, nextTmpVarData.varAddress);
        }

        i = parts[parts.size() - 1].second;

        int originalCodeSize = i - codeFirstIndex;

        tmpVarData.id = CmdID::IntTmpVariableValue;
        tmpVarData.varAddress = tmpVarAddress;
        tmpVarData.originalCodeSize = originalCodeSize;
        tmpVarData.convertedCodeSize = convertedCodeIndex - convertedCodeFirstIndex;
        tmpVarData.tmpVarNum = tmpVarNum;

        return tmpVarData;
    }

    if (parts.size() < 1)
    {
        return tmpVarData;
    }

    if ((parts[0].second - parts[0].first == 1))
    {
        //* Ex: 1
        ValueData valueData = ConvertValue(code, codeMaxSize, codeFirstIndex, argData);

        tmpVarData.id = valueData.id;
        tmpVarData.varAddress = valueData.value;
        tmpVarData.originalCodeSize = 1;
        tmpVarData.convertedCodeSize = 0;
        tmpVarData.tmpVarNum = tmpVarNum;
    }
    else
    {
        if (code[parts[0].first] == "!")
        {
            tmpVarAddress = tmpVarNum;
            tmpVarNum++;

            TmpVarData nextTmpVarData = ConvertFormula(code, codeMaxSize, parts[0].first + 1, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData, tmpVarNum, 0);

            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::AssignIntTmpVariable);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 10);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::IntValue);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, tmpVarAddress);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, convertOperator("!"));
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 5);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, nextTmpVarData.id);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, nextTmpVarData.varAddress);

            tmpVarData.id = nextTmpVarData.id;
            tmpVarData.varAddress = tmpVarAddress;
            tmpVarData.originalCodeSize = nextTmpVarData.originalCodeSize + 1;
            tmpVarData.convertedCodeSize = nextTmpVarData.convertedCodeSize + 10;
            tmpVarData.tmpVarNum = tmpVarNum;
        }
        else
        {
            TmpVarData nextTmpVarData = ConvertFormula(code, codeMaxSize, parts[0].first + 1, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData, tmpVarNum, 0);

            tmpVarData.id = nextTmpVarData.id;
            tmpVarData.varAddress = nextTmpVarData.varAddress;
            tmpVarData.originalCodeSize = nextTmpVarData.originalCodeSize + 2;
            tmpVarData.convertedCodeSize = nextTmpVarData.convertedCodeSize;
            tmpVarData.tmpVarNum = tmpVarNum;
        }
    }

    return tmpVarData;
}

ConvertedCodeData ConvertAction(std::string code[], int codeMaxSize, int codeFirstIndex, int convertedCode[], int convertedCodeMaxSize, int convertedCodeFirstIndex,
                                ArgData argData)
{
    ConvertedCodeData convertedCodeData;

    int i = codeFirstIndex;
    int convertedCodeIndex = convertedCodeFirstIndex;

    int convertedCodeSize = 0;

    const std::string token = code[i];

    if (token == "var")
    {
        std::string variableName = code[codeFirstIndex + 1];
        std::string type = code[codeFirstIndex + 3];

        if (argData.variableType[variableName] == 0)
        {
            if (type == "Int")
            {
                if (argData.isDefinitionOfGlobalVariable)
                {
                    argData.converter.numberGlobalVariableNum++;
                    argData.converter.numberGlobalVariableAddress[variableName] = argData.converter.numberGlobalVariableNum;

                    AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::DeclareIntGlobalVariable);
                    AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
                    AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData.converter.numberGlobalVariableAddress[variableName]);

                    argData.variableType[variableName] = 3;
                }
                else
                {
                    argData.numberVariableNum++;
                    argData.numberVariableAddress[variableName] = argData.numberVariableNum;

                    AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::DeclareIntVariable);
                    AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
                    AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData.numberVariableAddress[variableName]);

                    argData.variableType[variableName] = 1;
                }
            }
            else if (type == "String")
            {
                if (argData.isDefinitionOfGlobalVariable)
                {
                    argData.converter.stringGlobalVariableNum++;
                    argData.converter.stringGlobalVariableAddress[variableName] = argData.converter.stringGlobalVariableNum;

                    AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::DeclareStringGlobalVariable);
                    AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
                    AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData.converter.stringGlobalVariableAddress[variableName]);

                    argData.variableType[variableName] = 4;
                }
                else
                {
                    argData.stringVariableNum++;
                    argData.stringVariableAddress[variableName] = argData.stringVariableNum;

                    AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::DeclareStringVariable);
                    AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
                    AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData.stringVariableAddress[variableName]);

                    argData.variableType[variableName] = 2;
                }
            }
            else
            {
                //! 存在しない型
            }
        }
        else
        {
            //! 宣言済み
            printf("The variable %s has already declared!\n", variableName.c_str());
        }

        //convertedCodeIndex += 3;
        convertedCodeSize += 3;

        i += 4;
    }
    else if (token == "print")
    {
        i++;

        if (code[i] != "(")
        {
            //TODO: エラー処理 構文エラー
            //return -1;
        }

        i++;

        TmpVarData tmpVarData = ConvertFormula(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData, 0, 0);
        convertedCodeIndex += tmpVarData.convertedCodeSize;

        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::Print);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 5);

        convertedCodeSize = 5;

        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];

        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, tmpVarData.id);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, tmpVarData.varAddress);

        i++;
    }
    else if (token == "if")
    {
        TmpVarData tmpVarData = ConvertFormula(code, codeMaxSize, i + 2, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData, 0, 0);

        convertedCodeIndex += tmpVarData.convertedCodeSize;
        convertedCodeSize += tmpVarData.convertedCodeSize;

        int convertedCodeSizeIndex = convertedCodeIndex + 1;

        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::If);
        convertedCodeIndex++;

        convertedCodeSize += 2;

        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, tmpVarData.id);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, tmpVarData.varAddress);

        convertedCodeSize += 3;

        i += 3 + tmpVarData.originalCodeSize;

        i += ConvertBlock(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        convertedCode[convertedCodeSizeIndex] = 2 + 3 + convertedCode[convertedCodeIndex + 1];

        convertedCodeSize += convertedCode[convertedCodeIndex + 1];
        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];
    }
    else if (token == "repeat")
    {
        TmpVarData tmpVarData = ConvertFormula(code, codeMaxSize, i + 2, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData, 0, 0);

        convertedCodeIndex += tmpVarData.convertedCodeSize;
        convertedCodeSize += tmpVarData.convertedCodeSize;

        int convertedCodeSizeIndex = convertedCodeIndex + 1;

        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::Repeat);
        convertedCodeIndex++;

        convertedCodeSize += 2;

        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, tmpVarData.id);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, tmpVarData.varAddress);

        convertedCodeSize += 3;

        i += 3 + tmpVarData.originalCodeSize;

        i += ConvertBlock(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        convertedCode[convertedCodeSizeIndex] = 2 + 3 + convertedCode[convertedCodeIndex + 1];

        convertedCodeSize += convertedCode[convertedCodeIndex + 1];
        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];
    }
    else if (token == "while")
    {
        TmpVarData tmpVarData = ConvertFormula(code, codeMaxSize, i + 2, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData, 0, 0);

        convertedCodeIndex += tmpVarData.convertedCodeSize;
        convertedCodeSize += tmpVarData.convertedCodeSize;

        int convertedCodeSizeIndex = convertedCodeIndex + 1;

        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::While);
        convertedCodeIndex++;

        convertedCodeSize += 2;

        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, tmpVarData.id);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, tmpVarData.varAddress);

        convertedCodeSize += 3;

        i += 3 + tmpVarData.originalCodeSize;

        i += ConvertBlock(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        convertedCode[convertedCodeSizeIndex] = 2 + 3 + convertedCode[convertedCodeIndex + 1];

        convertedCodeSize += convertedCode[convertedCodeIndex + 1];
        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];
    }
    else if (token == "SetUIText")
    {
        int uiNameIndex = codeFirstIndex + 2;
        int uiTextIndex = codeFirstIndex + 4;

        TmpVarData uiNameVarData = ConvertFormula(code, codeMaxSize, uiNameIndex, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData, 0, 0);

        TmpVarData uiTextVarData = ConvertFormula(code, codeMaxSize, uiTextIndex, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData, 0, 0);

        convertedCodeIndex += uiNameVarData.convertedCodeSize + uiTextVarData.convertedCodeSize;
        convertedCodeSize += uiNameVarData.convertedCodeSize + uiTextVarData.convertedCodeSize;

        convertedCodeSize += 8;

        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::SetUIText);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 8);

        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, uiNameVarData.id);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, uiNameVarData.varAddress);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, uiTextVarData.id);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, uiTextVarData.varAddress);

        i += 4 + uiNameVarData.originalCodeSize + uiTextVarData.originalCodeSize;
    }
    else
    {
        //* 変数代入

        TmpVarData tmpVarData = ConvertFormula(code, codeMaxSize, i + 2, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData, 0, 0);

        convertedCodeSize += tmpVarData.convertedCodeSize;
        convertedCodeIndex += tmpVarData.convertedCodeSize;

        switch (argData.variableType[code[i]])
        {
        case 1:
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::AssignIntVariable);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 8);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::IntValue);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData.numberVariableAddress[code[i]]);

            break;

        case 2:
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::AssignStringVariable);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 8);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::IntValue);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData.stringVariableAddress[code[i]]);

            break;

        case 3:
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::AssignIntGlobalVariable);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 8);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::IntValue);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData.converter.numberGlobalVariableAddress[code[i]]);

            break;

        case 4:
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::AssignStringGlobalVariable);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 8);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, CmdID::IntValue);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
            AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData.converter.stringGlobalVariableAddress[code[i]]);

            break;

        default:
            printf("The variable %s does not exist!\n", code[i].c_str());
            break;
        }

        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, tmpVarData.id);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, 3);
        AddCode(convertedCode, convertedCodeMaxSize, convertedCodeIndex, tmpVarData.varAddress);

        i += 2 + tmpVarData.originalCodeSize;

        convertedCodeSize += 8;
    }

    int originalCodeSize = i - codeFirstIndex;
    convertedCodeData.originalCodeSize = originalCodeSize;
    convertedCodeData.convertedCodeSize = convertedCodeSize;
    return convertedCodeData;
}

//TODO:エラー処理
//* firstIndex: {のindex
int ConvertBlock(std::string code[], int codeMaxSize, int codeFirstIndex, int convertedCode[], int convertedCodeMaxSize, int convertedCodeFirstIndex,
                 ArgData argData)
{

    int i = codeFirstIndex;
    int convertedCodeIndex = convertedCodeFirstIndex;

    int size = 2;

    convertedCode[convertedCodeIndex] = CmdID::Do;
    convertedCodeIndex += 2;

    i++;
    while (code[i] != "}")
    {
        ConvertedCodeData convertedCodeData = ConvertAction(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        i += convertedCodeData.originalCodeSize;

        size += convertedCodeData.convertedCodeSize;
        convertedCodeIndex += convertedCodeData.convertedCodeSize;
    }

    convertedCode[convertedCodeFirstIndex + 1] = size;

    int originalCodeSize = i - codeFirstIndex + 1;
    return originalCodeSize;
}

std::string CodeToJson(int convertedCode[], int codeMaxSize, std::unordered_map<std::string, int> &stringVariableAddress)
{
    std::string json = "{";

    //* ###############

    std::string strings[1000];
    int stringMaxNum = 1000;
    int maxIndex = 0;

    json += "\"string\":";
    json += "[";

    for (auto i : stringVariableAddress)
    {
        if (i.second >= stringMaxNum)
            continue;

        if (i.first[0] != '"')
            continue;

        strings[i.second] = i.first;

        maxIndex = std::max(i.second, maxIndex);
    }

    for (int i = 0; i <= maxIndex; i++)
    {
        if (strings[i] == "")
            strings[i] = "\"\"";

        json += strings[i] + (i < maxIndex ? "," : "");
    }

    json += "]";
    json += ",";

    //* ###############

    json += "\"code\":";
    json += "[";

    for (int i = 0; i < convertedCode[1]; i++)
    {
        json += std::to_string(convertedCode[i]) + (i < convertedCode[1] - 1 ? "," : "");
    }

    json += "]";

    //* ###############

    json += "}";

    return json;
}

std::string Converter::ConvertCodeToJson(std::string codeStr, bool isDefinitionOfGlobalVariable, Converter &converter)
{
    //* ##################
    //* 変数等

    std::set<std::string> symbol{"(", ")", "{", "}", ">", "<", "=", "+", "-", "*", "/", "%", "&", "|", "!", ":", ",", "\""};
    std::set<std::string>
        doubleSymbol{"==", "!=", ">=", "<=", "&&", "||"};
    std::set<std::string> reservedWord{"print", "var", "repeat", "while", "if", "else", "SetUIText"};

    //* 1:数値 2:文字列 3:数値(グローバル) 4:文字列(グローバル)
    std::unordered_map<std::string, int> variableType;

    std::unordered_map<std::string, int> numberVariableAddress;
    int numberVariableNum = 0;

    std::unordered_map<std::string, int> stringVariableAddress;
    int stringVariableNum = 0;

    std::string splitCode[100000];
    int splitCodeMaxSize = 100000;

    int convertedCode[1000000];
    int convertedCodeMaxSize = 1000000;

    ArgData argData = {
        symbol,
        doubleSymbol,
        reservedWord,
        numberVariableAddress,
        numberVariableNum,
        stringVariableAddress,
        stringVariableNum,
        variableType,
        isDefinitionOfGlobalVariable,
        converter,
    };

    for (auto i : converter.numberGlobalVariableAddress)
    {
        variableType[i.first] = 3;
    }

    for (auto i : converter.stringGlobalVariableAddress)
    {
        variableType[i.first] = 4;
    }

    //* ##################

    int splitCodeSize = Converter::SplitCode(codeStr, splitCode, splitCodeMaxSize, symbol, doubleSymbol, reservedWord);

    for (int j = 0; j < splitCodeSize; j++)
    {
        printf("%s\n", splitCode[j].c_str());
    }

    ConvertBlock(splitCode, splitCodeSize, 0, convertedCode, convertedCodeMaxSize, 0, argData);

    std::string json = CodeToJson(convertedCode, convertedCodeMaxSize, stringVariableAddress);

    for (int j = 0; j < convertedCode[1]; j++)
    {
        printf("%d\n", convertedCode[j]);
    }

    printf("%s\n", json.c_str());

    return json;
}
