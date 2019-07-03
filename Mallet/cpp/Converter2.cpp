//
//  Converter2.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/06/28.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "cpp.hpp"

std::string RemoveComments(std::string codeStr)
{
    std::string returnCode = "";

    int i = 0;
    while (i < codeStr.size())
    {
        if (codeStr[i] == '"')
        {
            returnCode += '"';
            i++;

            while (i < codeStr.size() && codeStr[i] != '"')
            {
                if (i + 1 < codeStr.size() && codeStr[i] == '\\' && codeStr[i + 1] == '"')
                {
                    returnCode += codeStr[i];
                    i++;
                }

                returnCode += codeStr[i];
                i++;
            }

            returnCode += '"';
            i++;
        }
        else if (codeStr[i] == '/' &&
                 (codeStr[i + 1] == '*' || codeStr[i + 1] == '/'))
        {
            if (codeStr[i + 1] == '*')
            {
                i += 2;
                while (i + 1 < codeStr.size() && codeStr[i] != '*' && codeStr[i + 1] != '/')
                    i++;
                i += 2;
            }
            else
            {
                i += 2;
                while (i < codeStr.size() && codeStr[i] != '\n')
                    i++;
            }
        }
        else
        {
            if (codeStr[i] == '\n')
                returnCode += ' ';
            else
                returnCode += codeStr[i];

            i++;
        }
    }

    return returnCode;
}

std::vector<std::string> SplitCode(std::string codeStr,
                                   std::set<std::string> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord)
{
    std::vector<std::string> splitCode;

    codeStr = RemoveComments(codeStr);

    codeStr = "{" + codeStr + "}";

    for (int i = 0; i < codeStr.size(); i++)
    {
        if (codeStr[i] == '\n' || codeStr[i] == '\t')
            codeStr[i] = ' ';
    }

    int i = 0;
    while (i < codeStr.size())
    {
        if (codeStr[i] == ' ')
        {
            while (i < codeStr.size() && codeStr[i] == ' ')
                i++;

            continue;
        }

        if (codeStr[i] == '"')
        {
            codeStr += '"';
            i++;

            std::string str = "\"";

            while (i < codeStr.size() && codeStr[i] != '"')
            {
                if (i + 1 < codeStr.size() && codeStr[i] == '\\' && codeStr[i + 1] == '"')
                {
                    str += codeStr[i];
                    i++;
                }

                str += codeStr[i];

                i++;
            }

            str += '"';

            splitCode.push_back(str);

            i++;

            continue;
        }

        std::string str = "";

        while (i < codeStr.size())
        {
            str += codeStr[i];

            bool isSymbol = (bool)symbol.count({codeStr[i]});

            bool isNextSymbol = false;

            bool isDoubleSymbol = false;

            bool isNextBlank = false;

            if (i + 1 < codeStr.size())
            {
                isNextSymbol = (bool)symbol.count({codeStr[i + 1]});
                isDoubleSymbol = (bool)doubleSymbol.count(std::string() + codeStr[i] + codeStr[i + 1]);
                isNextBlank = codeStr[i + 1] == ' ';
            }

            if (((isSymbol || isNextSymbol) && !isDoubleSymbol) || isNextBlank)
            {
                splitCode.push_back(str);
                break;
            }

            i++;
        }

        i++;
    }

    return splitCode;
}

int convertOperator(std::string operatorString)
{
    int operatorCode = 0;

    if (operatorString == "+")
        operatorCode = CmdID::Add;
    else if (operatorString == "-")
        operatorCode = CmdID::Sub;
    else if (operatorString == "*")
        operatorCode = CmdID::Mul;
    else if (operatorString == "/")
        operatorCode = CmdID::Div;
    else if (operatorString == "%")
        operatorCode = CmdID::Mod;
    else if (operatorString == "==")
        operatorCode = CmdID::Equal;
    else if (operatorString == "!=")
        operatorCode = CmdID::NotEqual;
    else if (operatorString == ">")
        operatorCode = CmdID::GreaterThan;
    else if (operatorString == "<")
        operatorCode = CmdID::LessThan;
    else if (operatorString == ">=")
        operatorCode = CmdID::GreaterThanOrEqual;
    else if (operatorString == "<=")
        operatorCode = CmdID::LessThanOrEqual;
    else if (operatorString == "&&")
        operatorCode = CmdID::And;
    else if (operatorString == "||")
        operatorCode = CmdID::Or;
    else if (operatorString == "!")
        operatorCode = CmdID::Not;
    else
        printf("\"%s\" is not an operator!\n", operatorString.c_str());

    return operatorCode;
}

int Converter2::ConvertValue(const int firstCodeIndex)
{
    if (code[firstCodeIndex][0] == '"')
    {
        //* String

        std::string varName = "@" + code[firstCodeIndex];

        if (stringVariableAddress[varName] == 0)
        {
            stringVariableNum++;
            stringVariableAddress[varName] = stringVariableNum;

            stringVariableInitialValue[stringVariableNum] = code[firstCodeIndex].substr(1, code[firstCodeIndex].size() - 1);
        }

        int type = CmdID::StringType;
        int address = stringVariableAddress[varName];

        AddPushCode(type, address);
    }
    else if (code[firstCodeIndex][0] == '-' || code[firstCodeIndex][0] == '.' || (0 <= (code[firstCodeIndex][0] - '0') && (code[firstCodeIndex][0] - '0') <= 9))
    {
        //* Number

        bool isNumber = true;
        int commaNum = 0;

        int i = 0;
        if (code[firstCodeIndex][i] == '-')
            i++;

        while (i < code[firstCodeIndex].size())
        {
            commaNum += code[firstCodeIndex][0] == '.';

            if (commaNum > 1)
                isNumber = false;

            if (!(code[firstCodeIndex][0] == '.' || (0 <= (code[firstCodeIndex][0] - '0') && (code[firstCodeIndex][0] - '0') <= 9)))
                isNumber = false;

            if (!isNumber)
                break;

            i++;
        }

        if (!isNumber)
        {
            //TODO:
        }

        std::string varName = "@" + code[firstCodeIndex];

        if (numberVariableAddress[varName] == 0)
        {
            numberVariableNum++;
            numberVariableAddress[varName] = numberVariableNum;

            numberVariableInitialValue[numberVariableNum] = std::stod(code[firstCodeIndex]);
        }

        int type = CmdID::NumberType;
        int address = numberVariableAddress[varName];

        AddPushCode(type, address);
    }
    else if (code[firstCodeIndex] == "true" || code[firstCodeIndex] == "false")
    {
        //* Bool

        if (code[firstCodeIndex] == "true")
            AddPushTrueCode();
        if (code[firstCodeIndex] == "false")
            AddPushFalseCode();
    }
    else
    {
        //* Variable

        int type;
        int address;

        switch (variableType[code[firstCodeIndex]])
        {
        case CmdID::NumberType:
            type = CmdID::NumberType;

            if (numberVariableAddress[code[firstCodeIndex]] == 0)
                printf("The variable %s (Type:Number) is not declared!\n", code[firstCodeIndex].c_str());
            else
                address = numberVariableAddress[code[firstCodeIndex]];

            break;

        case CmdID::NumberGlobalType:
            type = CmdID::NumberGlobalType;

            if (numberGlobalVariableAddress[code[firstCodeIndex]] == 0)
                printf("The variable %s (Type:Number,Global) is not declared!\n", code[firstCodeIndex].c_str());
            else
                address = numberGlobalVariableAddress[code[firstCodeIndex]];

            break;

        case CmdID::StringType:
            type = CmdID::StringType;

            if (stringVariableAddress[code[firstCodeIndex]] == 0)
                printf("The variable %s (Type:String) is not declared!\n", code[firstCodeIndex].c_str());
            else
                address = stringVariableAddress[code[firstCodeIndex]];

            break;

        case CmdID::StringGlobalType:
            type = CmdID::StringGlobalType;

            if (stringGlobalVariableAddress[code[firstCodeIndex]] == 0)
                printf("The variable %s (Type:String,Global) is not declared!\n", code[firstCodeIndex].c_str());
            else
                address = stringGlobalVariableAddress[code[firstCodeIndex]];

            break;

        default:
            printf("The variable %s is not declared!\n", code[firstCodeIndex].c_str());
            break;
        }

        AddPushCode(type, address);
    }

    return 1;
}

int Converter2::ConvertFormula(const int firstCodeIndex, int operatorNumber)
{
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

    std::vector<std::pair<int, int>> parts; //* [start,end)

    std::vector<std::string> operators;

    int codeSize = 0;

    for (int operatorIndex = operatorNumber; operatorIndex < operatorsPriorities.size(); operatorIndex++)
    {
        parts.clear();
        operators.clear();

        std::set<std::string> operatorsPriority = operatorsPriorities[operatorIndex];

        int i = firstCodeIndex;
        int bracketStack = 0;
        bool allBracket = true;

        while (i < code.size())
        {
            int start = i;
            int end = i;

            while (i < code.size())
            {
                if (bracketStack == 0 &&
                    (operatorsPrioritiesAccum[operatorIndex].count(code[i]) > 0 ||
                     (operatorsPriority.count(code[i]) > 0 || code[i] == "," || code[i] == ")" || code[i] == "}") ||
                     (start < i && ((symbol.count(code[i - 1]) == 0 && doubleSymbol.count(code[i - 1]) == 0) || code[i - 1] == ")") && (symbol.count(code[i]) == 0 && doubleSymbol.count(code[i]) == 0))))
                {
                    break;
                }

                if (firstCodeIndex < i && bracketStack == 0)
                    allBracket = false;

                if (code[i] == "(")
                    bracketStack++;
                if (code[i] == ")")
                    bracketStack--;

                if (firstCodeIndex == i && bracketStack == 0)
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
            {
                break;
            }

            i++;
        }

        if (parts.size() == 1)
        {
            continue;
        }

        const int nextOperatorIndex = operatorIndex + 1;

        ConvertFormula(parts[0].first, nextOperatorIndex);

        for (int j = 1; j < parts.size(); j++)
        {
            ConvertFormula(parts[j].first, nextOperatorIndex);

            AddCmdCode(convertOperator(operators[j - 1]), 2);
        }

        //FIXME:
        return parts[parts.size() - 1].second - parts[0].first;
    }

    if (parts.size() < 1)
    {
        return 0;
    }

    if ((parts[0].second - parts[0].first == 1))
    {
        ConvertValue(firstCodeIndex);
    }
    else
    {
        if (code[parts[0].first] == "!")
        {
            ConvertFormula(firstCodeIndex, 0);

            AddCmdCode(CmdID::Not, 1);
        }
        else
        {
            ConvertFormula(firstCodeIndex + 1, 0);
        }
    }

    return parts[parts.size() - 1].second - parts[0].first;
}

int Converter2::ConvertCodeBlock(const int firstCodeIndex)
{
    int codeBlockSize = 0;

    int codeIndex = firstCodeIndex;

    bool isBlock = false;

    if (code[codeIndex] == "{")
    {
        isBlock = true;

        codeIndex++;
        codeBlockSize += 2;
    }

    while (code[codeIndex] != "}")
    {
        std::string funcName = code[codeIndex];

        int codeSize = 0;

        if (funcName == "{")
        {
            codeSize = 2 + ConvertCodeBlock(codeIndex);
        }
        else if (funcName == "print")
        {
            codeSize = 3 + ConvertFormula(codeIndex + 2, 0);

            AddCmdCode(CmdID::PrintNumber, 1);
        }
        else if (funcName == "number")
        {
            std::string varName = code[codeIndex + 1];

            if (variableType[varName] != 0)
            {
                printf("The variable %s is already declared\n", varName.c_str());
            }

            variableType[varName] = CmdID::NumberType;
            numberVariableNum++;
            numberVariableAddress[varName] = numberVariableNum;

            codeSize = 1;
        }
        else if (funcName == "string")
        {
        }
        else if (funcName == "bool")
        {
        }
        else if (funcName == "while")
        {
            int firstIndex = bytecodeIndex;

            codeSize = 3 + ConvertFormula(codeIndex + 2, 0);

            AddCmdCode(CmdID::Not, 1);

            int firstJumpIndex = bytecodeIndex;

            AddPushCode(CmdID::AddressType, -1);

            AddCmdCode(CmdID::Jump, 2);

            codeSize += ConvertCodeBlock(codeIndex + codeSize);

            AddPushTrueCode();

            AddPushCode(CmdID::AddressType, firstIndex);

            AddCmdCode(CmdID::Jump, 2);

            bytecode[firstJumpIndex + 4] = bytecodeIndex;
        }
        else if (funcName == "if")
        {
            codeSize = 3 + ConvertFormula(codeIndex + 2, 0);

            AddCmdCode(CmdID::Not, 1);

            int firstJumpIndex = bytecodeIndex;

            AddPushCode(CmdID::AddressType, -1);
            AddCmdCode(CmdID::Jump, 2);

            codeSize += ConvertCodeBlock(codeIndex + codeSize);

            if (code[codeIndex + codeSize] == "else")
            {
                AddPushTrueCode();

                int secondJumpIndex = bytecodeIndex;

                AddPushCode(CmdID::AddressType, -1);

                AddCmdCode(CmdID::Jump, 2);

                bytecode[firstJumpIndex + 4] = bytecodeIndex;

                codeSize++;

                codeSize += ConvertCodeBlock(codeIndex + codeSize);

                bytecode[secondJumpIndex + 4] = bytecodeIndex;
            }
            else
            {
                bytecode[firstJumpIndex + 4] = bytecodeIndex;
            }
        }
        else if (funcName == "repeat")
        {
            numberVariableNum++;
            int tmpVarAddress = numberVariableNum;

            AddPushCode(CmdID::AddressType, tmpVarAddress);
            AddPush0Code();
            AddCmdCode(CmdID::SetNumberVariable, 2);

            int firstIndex = bytecodeIndex;

            AddPushCode(CmdID::NumberType, tmpVarAddress);

            codeSize = 3 + ConvertFormula(codeIndex + 2, 0);

            AddCmdCode(CmdID::LessThan, 2);

            AddCmdCode(CmdID::Not, 1);

            int firstJumpIndex = bytecodeIndex;

            AddPushCode(CmdID::AddressType, -1);

            AddCmdCode(CmdID::Jump, 2);

            codeSize += ConvertCodeBlock(codeIndex + codeSize);

            AddPushCode(CmdID::AddressType, tmpVarAddress);
            AddPushCode(CmdID::NumberType, tmpVarAddress);
            AddPush1Code();
            AddCmdCode(CmdID::Add, 2);
            AddCmdCode(CmdID::SetNumberVariable, 2);

            AddPushTrueCode();

            AddPushCode(CmdID::AddressType, firstIndex);

            AddCmdCode(CmdID::Jump, 2);

            bytecode[firstJumpIndex + 4] = bytecodeIndex;
        }
        else if (variableType[code[codeIndex]] != 0)
        {
            int type = variableType[code[codeIndex]];
            int address;
            int codeID;

            switch (type)
            {
            case CmdID::NumberType:
                address = numberVariableAddress[code[codeIndex]];
                codeID = CmdID::SetNumberVariable;
                break;

            case CmdID::NumberGlobalType:
                //TODO:
                break;

            case CmdID::StringType:
                address = stringVariableAddress[code[codeIndex]];
                codeID = CmdID::SetStringVariable;
                break;

            case CmdID::StringGlobalType:
                //TODO:
                break;

            case CmdID::BoolType:
                //TODO:
                break;

            case CmdID::BoolGlobalType:
                //TODO:
                break;

            default:
                //TODO:
                break;
            }

            AddPushCode(CmdID::AddressType, address);

            codeSize = 2 + ConvertFormula(codeIndex + 2, 0);

            AddCmdCode(codeID, 2);
        }
        else
        {
            //printf("%s is undefined\n", code[codeIndex].c_str());
        }

        codeIndex += codeSize;
        codeBlockSize += codeSize;

        if (!isBlock)
            break;
    }

    return codeBlockSize;
}

std::string CodeToJson(std::vector<int> operatorCode, std::unordered_map<std::string, int> &stringVariableAddress)
{
    std::string json = "{";

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

    json += "\"codeStr\":";
    json += "[";

    for (int i = 0; i < operatorCode[1]; i++)
    {
        json += std::to_string(operatorCode[i]) + (i < operatorCode[1] - 1 ? "," : "");
    }

    json += "]";

    json += "}";

    return json;
}

std::string Converter2::ConvertCodeToJson(std::string codeStr, bool isDefinitionOfGlobalVariable, Converter2 &converter)
{
    bytecode = std::vector<int>(1000000);
    bytecodeIndex = 0;
    bytecodeSize = 0;

    numberVariableInitialValue = std::unordered_map<int, double>();
    stringVariableInitialValue = std::unordered_map<int, std::string>();

    numberVariableAddress = std::unordered_map<std::string, int>();
    stringVariableAddress = std::unordered_map<std::string, int>();
    boolVariableAddress = std::unordered_map<std::string, int>();

    numberVariableNum = 2;
    stringVariableNum = 0;
    boolVariableNum = 2;

    code = SplitCode(codeStr, symbol, doubleSymbol, reservedWord);

    for (auto i : code)
        printf("%s\n", i.c_str());

    ConvertCodeBlock(0);

    std::vector<int> tmp;

    for (int i = 0; i < bytecodeSize; i++)
    {
        //printf("%d,\n", bytecode[i]);
        tmp.push_back(bytecode[i]);
    }

    bytecode = tmp;

    return "";
}

void Converter2::AddCode(int code)
{
    if (bytecodeIndex >= bytecode.size())
        return;

    bytecode[bytecodeIndex] = code;
    bytecodeIndex++;
    bytecodeSize++;
}

void Converter2::AddCmdCode(int code, int argNum)
{
    AddCode(CmdID::CodeBegin);
    AddCode(code);
    AddCode(argNum);
}

void Converter2::AddPushCode(int type, int address)
{
    AddCode(CmdID::CodeBegin);
    AddCode(CmdID::Push);
    AddCode(0);
    AddCode(type);
    AddCode(address);
}

void Converter2::AddPushTrueCode()
{
    AddPushCode(CmdID::BoolType, 1);
}

void Converter2::AddPushFalseCode()
{
    AddPushCode(CmdID::BoolType, 2);
}

void Converter2::AddPush0Code()
{
    AddPushCode(CmdID::NumberType, 1);
}

void Converter2::AddPush1Code()
{
    AddPushCode(CmdID::NumberType, 2);
}
