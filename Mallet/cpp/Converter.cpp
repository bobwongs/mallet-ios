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

int ConvertValue(std::string code[], int codeMaxSize, int convertedCode[], int convertedCodeMaxSize, int firstIndex,
        std::set<char> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord,
        std::unordered_map<std::string, int> &numberVariableAddress, int &numberVariableNum, std::unordered_map<std::string, int> &stringVariableAddress, int &stringVariableNum, std::unordered_map<std::string, int> &variableType) {
    int i = firstIndex;

    int type = 0;
    int codeSize = 0;
    int valueOrAddress = 0;

    if (code[i][0] == '"') {
        //* 文字列

        std::string str = code[i]; //.substr(1, code[i].size() - 2);

        if (stringVariableAddress[str] == 0) {
            stringVariableNum++;
            stringVariableAddress[str] = stringVariableNum;
        }

        type = 3004;
        codeSize = 3;
        valueOrAddress = stringVariableAddress[str];

        i++;
    } else if ((0 <= (code[i][0] - '0') && (code[i][0] - '0') <= 9) || code[i][0] == '-') {
        //* 数値

        int value = 0;
        int coe = 1;

        for (int j = code[i].size() - 1; j >= 0; j--) {
            if (j > 0 && ((code[i][j] - '0') < 0 || 9 < (code[i][j] - '0'))) {
                //! 数値ではない
            }

            if (j == 0 && code[i][j] == '-') {
                value *= -1;
            } else {
                value += (code[i][j] - '0') * coe;
                coe *= 10;
            }
        }

        type = 3003;
        codeSize = 3;
        valueOrAddress = value;

        i++;
    } else {
        //* 変数

        switch (variableType[code[i]]) {
            case 1:
                //* 数値型
                type = 3002;
                codeSize = 3;

                if (numberVariableAddress[code[i]] == 0) {
                    printf("The variable %s (Type:Int) is not declared!\n", code[i].c_str());
                } else {
                    valueOrAddress = numberVariableAddress[code[i]];
                }

                break;

            case 2:
                //* 文字列型
                type = 3004;
                codeSize = 3;

                if (stringVariableAddress[code[i]] == 0) {
                    printf("The variable %s (Type:String) is not declared!\n", code[i].c_str());
                } else {
                    valueOrAddress = stringVariableAddress[code[i]];
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

int convertOperator(std::string operatorString) {
    int convertedCode = 0;

    if (operatorString == "+")
        convertedCode = 4000;
    if (operatorString == "-")
        convertedCode = 4001;
    if (operatorString == "*")
        convertedCode = 4002;
    if (operatorString == "/")
        convertedCode = 4003;
    if (operatorString == "%")
        convertedCode = 4004;
    if (operatorString == "==")
        convertedCode = 4005;
    if (operatorString == ">" || operatorString == "<")
        convertedCode = 4006;

    return convertedCode;
}

//2項演算OR単一の数値
//TODO:エラー処理
int ConvertFormula(std::string code[], int codeMaxSize, int convertedCode[], int convertedCodeMaxSize, int firstIndex,
        std::set<char> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord,
        std::unordered_map<std::string, int> &numberVariableAddress, int &numberVariableNum, std::unordered_map<std::string, int> &stringVariableAddress, int &stringVariableNum, std::unordered_map<std::string, int> &variableType) {
    int converterCodeIndex = 0;
    int i = firstIndex;

    int size = 0;

    int value1[5];
    int value2[5];
    int operatorCode;

    int value1MaxSize = 5;
    int value2MaxSize = 5;

    //* それぞれの値取得
    ConvertValue(code, codeMaxSize, value1, value1MaxSize, i, symbol, doubleSymbol, reservedWord, numberVariableAddress, numberVariableNum, stringVariableAddress, stringVariableNum, variableType);

    i++;
    if ((code[i].size() != 1 && !doubleSymbol.count(code[i])) || code[i] == ")") {
        //* 値が一つのみ(式ではない)

        for (int j = 0; j < value1[1]; j++) {
            convertedCode[converterCodeIndex] = value1[j];
            converterCodeIndex++;
        }

        size = value1[1];
    } else {
        //* 値が2つ(式が成立する)

        operatorCode = convertOperator(code[i]);
        i++;
        i += ConvertValue(code, codeMaxSize, value2, value2MaxSize, i, symbol, doubleSymbol, reservedWord, numberVariableAddress, numberVariableNum, stringVariableAddress, stringVariableNum, variableType);

        if (code[i] == "<") {
            for (int j = 0; j < std::min(value1MaxSize, value2MaxSize); j++) {
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

        for (int j = 0; j < 3; j++) {
            convertedCode[converterCodeIndex] = value1[j];
            converterCodeIndex++;
        }
        for (int j = 0; j < 3; j++) {
            convertedCode[converterCodeIndex] = value2[j];
            converterCodeIndex++;
        }

        size = 8;
    }

    convertedCode[1] = size;

    int originalCodeSize = i - firstIndex;
    return originalCodeSize;
}

int ConvertAction(std::string code[], int codeMaxSize, int convertedCode[], int convertedCodeMaxSize, int firstIndex,
        std::set<char> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord,
        std::unordered_map<std::string, int> &numberVariableAddress, int &numberVariableNum, std::unordered_map<std::string, int> &stringVariableAddress, int &stringVariableNum, std::unordered_map<std::string, int> &variableType) {
    int i = firstIndex;
    int convertedCodeIndex = 0;

    int convertedCodeSize = 0;

    std::string token = code[i];

    if (token == "var") {
        std::string variableName = code[firstIndex + 1];
        std::string type = code[firstIndex + 3];

        if (variableType[variableName] == 0) {
            if (type == "Int") {
                numberVariableNum++;
                numberVariableAddress[variableName] = numberVariableNum;

                convertedCode[convertedCodeIndex] = 3000;
                convertedCode[convertedCodeIndex + 2] = numberVariableAddress[variableName];

                variableType[variableName] = 1;
            } else if (type == "String") {
                stringVariableNum++;
                stringVariableAddress[variableName] = stringVariableNum;

                convertedCode[convertedCodeIndex] = 3006;
                convertedCode[convertedCodeIndex + 2] = stringVariableAddress[variableName];

                variableType[variableName] = 2;
            } else {
                //! 存在しない型
            }
        } else {
            //! 宣言済み
            printf("The variable %s has already declared!\n", variableName.c_str());
        }

        convertedCodeSize = 3;

        i += 4;

    } else if (token == "print") {
        convertedCode[convertedCodeIndex] = 1000;
        convertedCodeIndex += 2;

        convertedCodeSize = 5;

        i++;

        if (code[i] != "(") {
            //TODO: エラー処理 構文エラー
            return -1;
        }

        i++;

        int value[100];
        int valueSize = 100;

        i += ConvertValue(code, codeMaxSize, value, valueSize, i, symbol, doubleSymbol, reservedWord, numberVariableAddress, numberVariableNum, stringVariableAddress, stringVariableNum, variableType);

        for (int j = 0; j < value[1]; j++) {
            convertedCode[convertedCodeIndex] = value[j];
            convertedCodeIndex++;
        }

        i++;
    } else if (token == "if") {
        convertedCode[convertedCodeIndex] = 2001;
        convertedCodeIndex += 2;

        convertedCodeSize = 2;

        i++;

        if (code[i] != "(") {
            return -1;
        }

        i++;

        int value[100];
        int valueSize = 100;

        i += ConvertFormula(code, codeMaxSize, value, valueSize, i, symbol, doubleSymbol, reservedWord, numberVariableAddress, numberVariableNum, stringVariableAddress, stringVariableNum, variableType);

        convertedCodeSize += value[1];

        for (int j = 0; j < value[1]; j++) {
            convertedCode[convertedCodeIndex] = value[j];
            convertedCodeIndex++;
        }

        i++;

        int action[100000];
        int actionSize = 100000;
        i += ConvertBlock(code, codeMaxSize, action, actionSize, i, symbol, doubleSymbol, reservedWord, numberVariableAddress, numberVariableNum, stringVariableAddress, stringVariableNum, variableType);

        for (int j = 0; j < action[1]; j++) {
            convertedCode[convertedCodeIndex] = action[j];
            convertedCodeIndex++;
        }

        convertedCodeSize += action[1];
    } else if (token == "repeat") {
        convertedCode[convertedCodeIndex] = 2002;
        convertedCodeIndex += 2;

        convertedCodeSize = 2;

        i++;

        if (code[i] != "(") {
            return -1;
        }

        i++;

        int value[100];
        int valueSize = 100;

        i += ConvertFormula(code, codeMaxSize, value, valueSize, i, symbol, doubleSymbol, reservedWord, numberVariableAddress, numberVariableNum, stringVariableAddress, stringVariableNum, variableType);

        convertedCodeSize += value[1];

        for (int j = 0; j < value[1]; j++) {
            convertedCode[convertedCodeIndex] = value[j];
            convertedCodeIndex++;
        }

        i++;

        int action[100000];
        int actionSize = 100000;
        i += ConvertBlock(code, codeMaxSize, action, actionSize, i, symbol, doubleSymbol, reservedWord, numberVariableAddress, numberVariableNum, stringVariableAddress, stringVariableNum, variableType);

        for (int j = 0; j < action[1]; j++) {
            convertedCode[convertedCodeIndex] = action[j];
            convertedCodeIndex++;
        }

        convertedCodeSize += action[1];
    } else {
        //* 変数代入


        convertedCodeSize = 5;

        switch (variableType[code[i]]) {
            case 1:
                convertedCode[convertedCodeIndex] = 3001;
                convertedCodeIndex += 2;

                convertedCode[convertedCodeIndex] = 3003;
                convertedCode[convertedCodeIndex + 1] = 3;
                convertedCode[convertedCodeIndex + 2] = numberVariableAddress[code[i]];
                convertedCodeIndex += 3;

                break;

            case 2:
                convertedCode[convertedCodeIndex] = 3007;
                convertedCodeIndex += 2;

                convertedCode[convertedCodeIndex] = 3003;
                convertedCode[convertedCodeIndex + 1] = 3;
                convertedCode[convertedCodeIndex + 2] = stringVariableAddress[code[i]];
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

        i += ConvertFormula(code, codeMaxSize, value, valueSize, i, symbol, doubleSymbol, reservedWord, numberVariableAddress, numberVariableNum, stringVariableAddress, stringVariableNum, variableType);

        for (int j = 0; j < value[1]; j++) {
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
int ConvertBlock(std::string code[], int codeMaxSize, int convertedCode[], int convertedCodeMaxSize, int firstIndex,
        std::set<char> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord,
        std::unordered_map<std::string, int> &numberVariableAddress, int &numberVariableNum, std::unordered_map<std::string, int> &stringVariableAddress, int &stringVariableNum, std::unordered_map<std::string, int> &variableType) {

    int i = firstIndex;
    int convertedCodeIndex = 0;

    int size = 2;

    convertedCode[convertedCodeIndex] = 2000;
    convertedCodeIndex += 2;

    i++;
    while (code[i] != "}") {
        int convertedCodePart[1000];
        int convertedCodePartMaxSize = 1000;
        i += ConvertAction(code, codeMaxSize, convertedCodePart, convertedCodePartMaxSize, i, symbol, doubleSymbol, reservedWord, numberVariableAddress, numberVariableNum, stringVariableAddress, stringVariableNum, variableType);

        for (int j = 0; j < convertedCodePart[1]; j++) {
            convertedCode[convertedCodeIndex] = convertedCodePart[j];
            convertedCodeIndex++;
        }

        size += convertedCodePart[1];
    }

    convertedCode[1] = size;

    int originalCodeSize = i - firstIndex + 1;
    return originalCodeSize;
}

std::string CodeToJson(int convertedCode[], int codeMaxSize, std::unordered_map<std::string, int> &stringVariableAddress) {
    std::string json = "{";

    //* ###############

    std::string strings[1000];
    int stringMaxNum = 1000;
    int maxIndex = 0;

    json += "\"string\":";
    json += "[";

    for (auto i : stringVariableAddress) {
        if (i.second >= stringMaxNum)
            continue;

        if (i.first[0] != '"')
            continue;

        strings[i.second] = i.first;

        maxIndex = std::max(i.second, maxIndex);
    }

    for (int i = 0; i <= maxIndex; i++) {
        if (strings[i] == "")
            strings[i] = "\"\"";

        json += strings[i] + (i < maxIndex ? "," : "");
    }

    json += "]";
    json += ",";

    //* ###############

    json += "\"code\":";
    json += "[";

    for (int i = 0; i < convertedCode[1]; i++) {
        json += std::to_string(convertedCode[i]) + (i < convertedCode[1] - 1 ? "," : "");
    }

    json += "]";

    //* ###############

    json += "}";

    return json;
}

std::string Cpp::ConvertCodeToJson(std::string code) {
//}(std::string code[], int codeSize, int convertedCode[], int convertedCodeMaxSize) {
    std::set<char> symbol{'(', ')', '{', '}', '>', '<', '=', '+', '-', '*', '/', '%', '&', '|', '!', ':'};
    std::set<std::string> doubleSymbol{"==", "!=", "&&", "||"};
    std::set<std::string> reservedWord{"print", "var", "repeat", "if", "else"};

    //* 1:数値 2:文字列
    std::unordered_map<std::string, int> variableType;

    std::unordered_map<std::string, int> numberVariableAddress;
    int numberVariableNum = 0;

    std::unordered_map<std::string, int> stringVariableAddress;
    int stringVariableNum = 0;

    std::string strictCode[10000];
    int strictCodeSize = 0;

    std::string codeStr = "";

    codeStr += "{$";

    //$:改行コード

    int i = 0;

    while (i < code.size()) {

        if (code[i] == ' ') {
            if (codeStr[codeStr.size() - 1] != '$')
                codeStr += '$';
            while (code[i] == ' ')
                i++;

            continue;
        }

        if (code[i] == '"') {
            codeStr += "\"";
            i++;
            while (code[i] != '"') {
                if (code[i] == '\\' && code[i + 1] == '"') {
                    codeStr += "\"";
                    i += 2;
                } else {
                    codeStr += code[i];
                    i += 1;
                }
            }
            codeStr += "\"";
            codeStr += "$";

            i++;

            continue;
        }

        codeStr += code[i];

        std::string thisPlusNext = std::string() + code[i] + code[i + 1];

        bool isDoubleSymbol = (bool) doubleSymbol.count(thisPlusNext);
        bool isSymbol = (bool) symbol.count(code[i]);
        bool isSymbolNext = (bool) symbol.count(code[i + 1]);

        if ((isSymbol && !isDoubleSymbol) ||
                (!isSymbol && isSymbolNext))
            codeStr += '$';

        i++;
    }


    codeStr += "$}";

    printf("%s\n", codeStr.c_str());

    i = 0;
    while (i < codeStr.size()) {
        if (codeStr[i] == '$') {
            i++;
            continue;
        }

        std::string token = "";
        while (i < codeStr.size() && codeStr[i] != '$') {
            token += codeStr[i];
            i++;
        }

        strictCode[strictCodeSize] = token;
        strictCodeSize++;
    }

    for (int i = 0; i < strictCodeSize; i++) {
        printf("%s\n", strictCode[i].c_str());
    }

    int convertedCode[1000000];
    int convertedCodeMaxSize = 1000000;

    ConvertBlock(strictCode, strictCodeSize, convertedCode, convertedCodeMaxSize, 0, symbol, doubleSymbol, reservedWord, numberVariableAddress, numberVariableNum, stringVariableAddress, stringVariableNum, variableType);

    for (int j = 0; j < convertedCode[1]; j++) {
        printf("%d\n", convertedCode[j]);
    }

    std::string json = CodeToJson(convertedCode, convertedCodeMaxSize, stringVariableAddress);

    printf("%s\n", json.c_str());

    return json;
}
