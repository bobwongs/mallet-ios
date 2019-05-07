//
//  Converter.cpp
//  LangRunner2-iOS
//
//  Created by Katsu Matsuda on 2019/04/12.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "Converter.hpp"
#include <string>
#include <set>
#include <vector>
#include <unordered_map>

int ConvertValue(std::string code[], int codeMaxSize, int convertedCode[], int convertedCodeMaxSize, int firstIndex, ArgData argData)
{
    int i = firstIndex;

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

    convertedCode[0] = type;
    convertedCode[1] = codeSize;
    convertedCode[2] = valueOrAddress;

    int originalCodeSize = i - firstIndex;
    return originalCodeSize;
}

int convertOperator(std::string operatorString)
{
    int convertedCode = 0;

    if (operatorString == "+")
        convertedCode = CmdID::Sum;
    if (operatorString == "-")
        convertedCode = CmdID::Sub;
    if (operatorString == "*")
        convertedCode = CmdID::Mul;
    if (operatorString == "/")
        convertedCode = CmdID::Div;
    if (operatorString == "%")
        convertedCode = CmdID::Mod;
    if (operatorString == "==")
        convertedCode = CmdID::Equal;
    if (operatorString == ">" || operatorString == "<")
        convertedCode = CmdID::Bigger;
    if (operatorString == "!=")
        convertedCode = CmdID::Inequal;

    return convertedCode;
}

//2項演算OR単一の数値
//TODO:エラー処理
int ConvertFormula(std::string code[], int codeMaxSize, int convertedCode[], int convertedCodeMaxSize, int firstIndex, ArgData argData)
{
    int converterCodeIndex = 0;
    int i = firstIndex;

    int size = 0;

    int value1[5];
    int value2[5];
    int operatorCode;

    int value1MaxSize = 5;
    int value2MaxSize = 5;

    //* 1番目の値取得
    ConvertValue(code, codeMaxSize, value1, value1MaxSize, i, argData);

    i++;
    if (code[i] == ")" || code[i] == "}" || (code[i].size() == 1 && !argData.symbol.count(code[i][0])) || (code[i].size() == 2 && !argData.doubleSymbol.count(code[i])) || code[i].size() > 2)
    {
        //* 値が一つのみ(式ではない)

        for (int j = 0; j < value1[1]; j++)
        {
            convertedCode[converterCodeIndex] = value1[j];
            converterCodeIndex++;
        }

        size = value1[1];
    }
    else
    {
        //* 値が2つ(式が成立する)

        operatorCode = convertOperator(code[i]);
        i++;
        i += ConvertValue(code, codeMaxSize, value2, value2MaxSize, i, argData);

        if (code[i] == "<")
        {
            for (int j = 0; j < std::min(value1MaxSize, value2MaxSize); j++)
            {
                int tmp = value1[j];
                value1[j] = value2[j];
                value2[j] = tmp;
            }
            int tmp = value1MaxSize;
            value1MaxSize = value2MaxSize;
            value2MaxSize = tmp;
        }

        convertedCode[converterCodeIndex] = operatorCode;
        converterCodeIndex += 2;

        for (int j = 0; j < 3; j++)
        {
            convertedCode[converterCodeIndex] = value1[j];
            converterCodeIndex++;
        }
        for (int j = 0; j < 3; j++)
        {
            convertedCode[converterCodeIndex] = value2[j];
            converterCodeIndex++;
        }

        size = 8;
    }

    convertedCode[1] = size;

    int originalCodeSize = i - firstIndex;
    return originalCodeSize;
}

int ConvertAction(std::string code[], int codeMaxSize, int convertedCode[], int convertedCodeMaxSize, int firstIndex, ArgData argData)
{
    int i = firstIndex;
    int convertedCodeIndex = 0;

    int convertedCodeSize = 0;

    std::string token = code[i];

    if (token == "var")
    {
        std::string variableName = code[firstIndex + 1];
        std::string type = code[firstIndex + 3];

        if (argData.variableType[variableName] == 0)
        {
            if (type == "Int")
            {
                if (argData.isDefinitionOfGlobalVariable)
                {
                    argData.converter.numberGlobalVariableNum++;
                    argData.converter.numberGlobalVariableAddress[variableName] = argData.converter.numberGlobalVariableNum;

                    convertedCode[convertedCodeIndex] = CmdID::DeclareIntGlobalVariable;
                    convertedCode[convertedCodeIndex + 2] = argData.converter.numberGlobalVariableAddress[variableName];

                    argData.variableType[variableName] = 3;
                }
                else
                {
                    argData.numberVariableNum++;
                    argData.numberVariableAddress[variableName] = argData.numberVariableNum;

                    convertedCode[convertedCodeIndex] = CmdID::DeclareIntVariable;
                    convertedCode[convertedCodeIndex + 2] = argData.numberVariableAddress[variableName];

                    argData.variableType[variableName] = 1;
                }
            }
            else if (type == "String")
            {
                if (argData.isDefinitionOfGlobalVariable)
                {
                    argData.converter.stringGlobalVariableNum++;
                    argData.converter.stringGlobalVariableAddress[variableName] = argData.converter.stringGlobalVariableNum;

                    convertedCode[convertedCodeIndex] = CmdID::DeclareStringGlobalVariable;
                    convertedCode[convertedCodeIndex + 2] = argData.converter.stringGlobalVariableAddress[variableName];

                    argData.variableType[variableName] = 4;
                }
                else
                {
                    argData.stringVariableNum++;
                    argData.stringVariableAddress[variableName] = argData.stringVariableNum;

                    convertedCode[convertedCodeIndex] = CmdID::DeclareStringVariable;
                    convertedCode[convertedCodeIndex + 2] = argData.stringVariableAddress[variableName];

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

        convertedCodeSize = 3;

        i += 4;
    }
    else if (token == "print")
    {
        convertedCode[convertedCodeIndex] = CmdID::Print;
        convertedCodeIndex += 2;

        convertedCodeSize = 5;

        i++;

        if (code[i] != "(")
        {
            //TODO: エラー処理 構文エラー
            return -1;
        }

        i++;

        int value[100];
        int valueSize = 100;

        i += ConvertValue(code, codeMaxSize, value, valueSize, i, argData);

        for (int j = 0; j < value[1]; j++)
        {
            convertedCode[convertedCodeIndex] = value[j];
            convertedCodeIndex++;
        }

        i++;
    }
    else if (token == "if")
    {
        convertedCode[convertedCodeIndex] = CmdID::If;
        convertedCodeIndex += 2;

        convertedCodeSize = 2;

        i++;

        if (code[i] != "(")
        {
            return -1;
        }

        i++;

        int value[100];
        int valueSize = 100;

        i += ConvertFormula(code, codeMaxSize, value, valueSize, i, argData);

        convertedCodeSize += value[1];

        for (int j = 0; j < value[1]; j++)
        {
            convertedCode[convertedCodeIndex] = value[j];
            convertedCodeIndex++;
        }

        i++;

        int action[100000];
        int actionSize = 100000;
        i += ConvertBlock(code, codeMaxSize, action, actionSize, i, argData);

        for (int j = 0; j < action[1]; j++)
        {
            convertedCode[convertedCodeIndex] = action[j];
            convertedCodeIndex++;
        }

        convertedCodeSize += action[1];
    }
    else if (token == "repeat")
    {
        convertedCode[convertedCodeIndex] = CmdID::Repeat;
        convertedCodeIndex += 2;

        convertedCodeSize = 2;

        i++;

        if (code[i] != "(")
        {
            return -1;
        }

        i++;

        int value[100];
        int valueSize = 100;

        i += ConvertFormula(code, codeMaxSize, value, valueSize, i, argData);

        convertedCodeSize += value[1];

        for (int j = 0; j < value[1]; j++)
        {
            convertedCode[convertedCodeIndex] = value[j];
            convertedCodeIndex++;
        }

        i++;

        int action[100000];
        int actionSize = 100000;
        i += ConvertBlock(code, codeMaxSize, action, actionSize, i, argData);

        for (int j = 0; j < action[1]; j++)
        {
            convertedCode[convertedCodeIndex] = action[j];
            convertedCodeIndex++;
        }

        convertedCodeSize += action[1];
    }
    else if (token == "SetUIText")
    {
        convertedCodeSize = 8;

        convertedCode[convertedCodeIndex] = CmdID::SetUIText;
        convertedCodeIndex += 2;

        int uiName[5]; // = code[firstIndex + 2];
        int uiText[5]; // = code[firstIndex + 4];
        int uiNameMaxSize = 5;
        int uiTextMaxSize = 5;
        int uiNameIndex = firstIndex + 2;
        int uiTextIndex = firstIndex + 4;

        ConvertValue(code, codeMaxSize, uiName, uiNameMaxSize, uiNameIndex, argData);
        ConvertValue(code, codeMaxSize, uiText, uiTextMaxSize, uiTextIndex, argData);

        for (int i = 0; i < 3; i++)
        {
            convertedCode[convertedCodeIndex] = uiName[i];
            convertedCodeIndex++;
        }

        for (int i = 0; i < 3; i++)
        {
            convertedCode[convertedCodeIndex] = uiText[i];
            convertedCodeIndex++;
        }

        i += 6;
    }
    else
    {
        //* 変数代入

        convertedCodeSize = 5;

        switch (argData.variableType[code[i]])
        {
        case 1:
            convertedCode[convertedCodeIndex] = CmdID::AssignIntVariable;
            convertedCodeIndex += 2;

            convertedCode[convertedCodeIndex] = CmdID::IntValue;
            convertedCode[convertedCodeIndex + 1] = 3;
            convertedCode[convertedCodeIndex + 2] = argData.numberVariableAddress[code[i]];
            convertedCodeIndex += 3;

            break;

        case 2:
            convertedCode[convertedCodeIndex] = CmdID::AssignStringVariable;
            convertedCodeIndex += 2;

            convertedCode[convertedCodeIndex] = CmdID::IntValue;
            convertedCode[convertedCodeIndex + 1] = 3;
            convertedCode[convertedCodeIndex + 2] = argData.stringVariableAddress[code[i]];
            convertedCodeIndex += 3;

            break;

        case 3:
            convertedCode[convertedCodeIndex] = CmdID::AssignIntGlobalVariable;
            convertedCodeIndex += 2;

            convertedCode[convertedCodeIndex] = CmdID::IntValue;
            convertedCode[convertedCodeIndex + 1] = 3;
            convertedCode[convertedCodeIndex + 2] = argData.converter.numberGlobalVariableAddress[code[i]];
            convertedCodeIndex += 3;

            break;

        case 4:
            convertedCode[convertedCodeIndex] = CmdID::AssignStringGlobalVariable;
            convertedCodeIndex += 2;

            convertedCode[convertedCodeIndex] = CmdID::IntValue;
            convertedCode[convertedCodeIndex + 1] = 3;
            convertedCode[convertedCodeIndex + 2] = argData.converter.stringGlobalVariableAddress[code[i]];
            convertedCodeIndex += 3;

            break;

        default:
            printf("The variable %s does not exist!\n", code[i].c_str());
            break;
        }

        i += 2;
        if (code[i] == "(")
            i++;

        int value[100];
        int valueSize = 100;

        i += ConvertFormula(code, codeMaxSize, value, valueSize, i, argData);

        for (int j = 0; j < value[1]; j++)
        {
            convertedCode[convertedCodeIndex] = value[j];
            convertedCodeIndex++;
        }

        convertedCodeSize += value[1];

        if (code[i] == ")")
            i++;
    }

    convertedCode[1] = convertedCodeSize;

    int originalCodeSize = i - firstIndex;
    return originalCodeSize;
}

//TODO:エラー処理
//* firstIndex: {のindex
int ConvertBlock(std::string code[], int codeMaxSize, int convertedCode[], int convertedCodeMaxSize, int firstIndex, ArgData argData)
{

    int i = firstIndex;
    int convertedCodeIndex = 0;

    int size = 2;

    convertedCode[convertedCodeIndex] = CmdID::Do;
    convertedCodeIndex += 2;

    i++;
    while (code[i] != "}")
    {
        int convertedCodePart[1000];
        int convertedCodePartMaxSize = 1000;
        i += ConvertAction(code, codeMaxSize, convertedCodePart, convertedCodePartMaxSize, i, argData);

        for (int j = 0; j < convertedCodePart[1]; j++)
        {
            convertedCode[convertedCodeIndex] = convertedCodePart[j];
            convertedCodeIndex++;
        }

        size += convertedCodePart[1];
    }

    convertedCode[1] = size;

    int originalCodeSize = i - firstIndex + 1;
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

    std::set<char> symbol{'(', ')', '{', '}', '>', '<', '=', '+', '-', '*', '/', '%', '&', '|', '!', ':', ',', '"'};
    std::set<std::string> doubleSymbol{"==", "!=", "&&", "||"};
    std::set<std::string> reservedWord{"print", "var", "repeat", "if", "else"};

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

    ConvertBlock(splitCode, splitCodeSize, convertedCode, convertedCodeMaxSize, 0, argData);

    std::string json = CodeToJson(convertedCode, convertedCodeMaxSize, stringVariableAddress);

    /*
    for (int j = 0; j < splitCodeSize; j++)
    {
        printf("%s\n", splitCode[j].c_str());
    }

    for (int j = 0; j < convertedCode[1]; j++)
    {
        printf("%d\n", convertedCode[j]);
    }

    printf("%s\n", json.c_str());
    */

    return json;
}
