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

int ConvertValue(std::string code[], int codeMaxSize, int codeFirstIndex, int convertedCode[], int convertedCodeMaxSize, int convertedCodeFirstIndex,
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

    convertedCode[convertedCodeFirstIndex + 0] = type;
    convertedCode[convertedCodeFirstIndex + 1] = codeSize;
    convertedCode[convertedCodeFirstIndex + 2] = valueOrAddress;

    int originalCodeSize = i - codeFirstIndex;
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
    if (operatorString == ">")
        convertedCode = CmdID::Bigger;
    if (operatorString == "<")
        convertedCode = CmdID::Lower;
    if (operatorString == "!=")
        convertedCode = CmdID::Inequal;

    return convertedCode;
}

//2項演算OR単一の数値
//TODO:エラー処理
int ConvertFormula(std::string code[], int codeMaxSize, int codeFirstIndex, int convertedCode[], int convertedCodeMaxSize, int convertedCodeFirstIndex,
                   ArgData argData)
{
    int convertedCodeIndex = convertedCodeFirstIndex;
    int i = codeFirstIndex;

    int size = 0;

    int operatorCode;

    //* 1番目の値取得
    /*
    ConvertValue(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);
    convertedCodeIndex += convertedCode[convertedCodeIndex + 1];

    size = convertedCode[convertedCodeFirstIndex + 1];
    */

    if (code[i + 1] == ")" || code[i + 1] == "}" || (code[i + 1].size() == 1 && !argData.symbol.count(code[i + 1][0])) || (code[i + 1].size() == 2 && !argData.doubleSymbol.count(code[i + 1])) || code[i + 1].size() > 2)
    {
        //* 値が一つのみ(式ではない)

        ConvertValue(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        size += convertedCode[convertedCodeFirstIndex + 1];
        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];

        i++;

        /*
        for (int j = 0; j < value1[1]; j++)
        {
            convertedCode[converterCodeIndex] = value1[j];
            converterCodeIndex++;
        }
        */
    }
    else
    {
        //* 値が2つ(式が成立する)

        convertedCodeIndex += 2;

        ConvertValue(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        size += convertedCode[convertedCodeIndex + 1];
        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];
        i++;

        operatorCode = convertOperator(code[i]);
        size += 2;
        i++;

        i += ConvertValue(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        size += convertedCode[convertedCodeIndex + 1];
        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];

        /*
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
        */

        convertedCode[convertedCodeFirstIndex] = operatorCode;
    }

    convertedCode[convertedCodeFirstIndex + 1] = size;

    int originalCodeSize = i - codeFirstIndex;
    return originalCodeSize;
}

int ConvertAction(std::string code[], int codeMaxSize, int codeFirstIndex, int convertedCode[], int convertedCodeMaxSize, int convertedCodeFirstIndex,
                  ArgData argData)
{
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

        convertedCodeIndex += 3;
        convertedCodeSize += 3;

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

        i += ConvertValue(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];
        /*
        for (int j = 0; j < value[1]; j++)
        {
            convertedCode[convertedCodeIndex] = value[j];
            convertedCodeIndex++;
        }
        */

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

        i += ConvertFormula(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        convertedCodeSize += convertedCode[convertedCodeIndex + 1];
        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];

        /*
        for (int j = 0; j < value[1]; j++)
        {
            convertedCode[convertedCodeIndex] = value[j];
            convertedCodeIndex++;
        }
        */

        i++;

        /*
        int action[100000];
        int actionSize = 100000;
        */
        i += ConvertBlock(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        /*
        for (int j = 0; j < action[1]; j++)
        {
            convertedCode[convertedCodeIndex] = action[j];
            convertedCodeIndex++;
        }
        */

        convertedCodeSize += convertedCode[convertedCodeIndex + 1];
        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];
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

        i += ConvertFormula(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        convertedCodeSize += convertedCode[convertedCodeIndex + 1];
        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];

        /*
        for (int j = 0; j < value[1]; j++)
        {
            convertedCode[convertedCodeIndex] = value[j];
            convertedCodeIndex++;
        }
        */

        i++;

        /*
        int action[100000];
        int actionSize = 100000;
        */
        i += ConvertBlock(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        /*
        for (int j = 0; j < action[1]; j++)
        {
            convertedCode[convertedCodeIndex] = action[j];
            convertedCodeIndex++;
        }
        */

        convertedCodeSize += convertedCode[convertedCodeIndex + 1];
        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];
    }
    else if (token == "while")
    {
        convertedCode[convertedCodeIndex] = CmdID::While;
        convertedCodeIndex += 2;

        convertedCodeSize = 2;

        i++;

        if (code[i] != "(")
        {
            return -1;
        }

        i++;

        i += ConvertFormula(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        convertedCodeSize += convertedCode[convertedCodeIndex + 1];
        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];

        /*
        for (int j = 0; j < value[1]; j++)
        {
            convertedCode[convertedCodeIndex] = value[j];
            convertedCodeIndex++;
        }
        */

        i++;

        /*
        int action[100000];
        int actionSize = 100000;
        */
        i += ConvertBlock(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        /*
        for (int j = 0; j < action[1]; j++)
        {
            convertedCode[convertedCodeIndex] = action[j];
            convertedCodeIndex++;
        }
        */

        convertedCodeSize += convertedCode[convertedCodeIndex + 1];
        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];
    }
    else if (token == "SetUIText")
    {
        convertedCodeSize = 8;

        convertedCode[convertedCodeIndex] = CmdID::SetUIText;
        convertedCodeIndex += 2;

        /*
        int uiName[5]; // = code[firstIndex + 2];
        int uiText[5]; // = code[firstIndex + 4];
        */
        int uiNameIndex = codeFirstIndex + 2;
        int uiTextIndex = codeFirstIndex + 4;

        ConvertValue(code, codeMaxSize, uiNameIndex, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];

        ConvertValue(code, codeMaxSize, uiTextIndex, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];
        /*
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
        */

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

        /*
        int value[100];
        int valueSize = 100;
        */

        i += ConvertFormula(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        /*
        for (int j = 0; j < value[1]; j++)
        {
            convertedCode[convertedCodeIndex] = value[j];
            convertedCodeIndex++;
        }
        */

        convertedCodeSize += convertedCode[convertedCodeIndex + 1];
        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];

        if (code[i] == ")")
            i++;
    }

    convertedCode[convertedCodeFirstIndex + 1] = convertedCodeSize;

    int originalCodeSize = i - codeFirstIndex;
    return originalCodeSize;
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
        /*
        int convertedCodePart[1000];
        int convertedCodePartMaxSize = 1000;
        */
        i += ConvertAction(code, codeMaxSize, i, convertedCode, convertedCodeMaxSize, convertedCodeIndex, argData);

        size += convertedCode[convertedCodeIndex + 1]; //convertedCodePart[1];
        convertedCodeIndex += convertedCode[convertedCodeIndex + 1];

        /*
        for (int j = 0; j < convertedCodePart[1]; j++)
        {
            convertedCode[convertedCodeIndex] = convertedCodePart[j];
            convertedCodeIndex++;
        }
        */
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

    std::set<char> symbol{'(', ')', '{', '}', '>', '<', '=', '+', '-', '*', '/', '%', '&', '|', '!', ':', ',', '"'};
    std::set<std::string> doubleSymbol{"==", "!=", "&&", "||"};
    std::set<std::string> reservedWord{"print", "var", "repeat", "while", "if", "else"};

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

    ConvertBlock(splitCode, splitCodeSize, 0, convertedCode, convertedCodeMaxSize, 0, argData);

    std::string json = CodeToJson(convertedCode, convertedCodeMaxSize, stringVariableAddress);

    for (int j = 0; j < splitCodeSize; j++)
    {
        printf("%s\n", splitCode[j].c_str());
    }

    for (int j = 0; j < convertedCode[1]; j++)
    {
        printf("%d\n", convertedCode[j]);
    }

    printf("%s\n", json.c_str());

    return json;
}
