//
//  Convert.cpp
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
        operatorCode = ADD;
    else if (operatorString == "-")
        operatorCode = SUB;
    else if (operatorString == "*")
        operatorCode = MUL;
    else if (operatorString == "/")
        operatorCode = DIV;
    else if (operatorString == "%")
        operatorCode = MOD;
    else if (operatorString == "==")
        operatorCode = EQUAL;
    else if (operatorString == "!=")
        operatorCode = NOT_EQUAL;
    else if (operatorString == ">")
        operatorCode = GREATER_THAN;
    else if (operatorString == "<")
        operatorCode = LESS_THAN;
    else if (operatorString == ">=")
        operatorCode = GREATER_THAN_OR_EQUAL;
    else if (operatorString == "<=")
        operatorCode = LESS_THAN_OR_EQUAL;
    else if (operatorString == "&&")
        operatorCode = AND;
    else if (operatorString == "||")
        operatorCode = OR;
    else if (operatorString == "!")
        operatorCode = NOT;
    else
        printf("\"%s\" is not an operator!\n", operatorString.c_str());

    return operatorCode;
}

void Convert::DeclareConstant(const int firstCodeIndex)
{
    if (code[firstCodeIndex][0] == '"')
    {
        //* String

        std::string varName = "@" + code[firstCodeIndex];

        if (stringGlobalVariableAddress[varName] == 0)
        {
            stringGlobalVariableNum++;
            stringGlobalVariableAddress[varName] = stringGlobalVariableNum;

            globalVariableType[varName] = STRING_TYPE;

            isGlobalVariable[varName] = true;

            stringVariableInitialValue[stringGlobalVariableNum] = code[firstCodeIndex].substr(1, code[firstCodeIndex].size() - 1);
        }

        code[firstCodeIndex] = varName;
    }
    else if (code[firstCodeIndex][0] == '-' || code[firstCodeIndex][0] == '.' || (0 <= (code[firstCodeIndex][0] - '0') && (code[firstCodeIndex][0] - '0') <= 9))
    {
        //* Number

        bool isNumber = true;
        int commaNum = 0;

        if (code[firstCodeIndex] == "-")
            isNumber = false;

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
            return;
        }

        std::string varName = "@" + code[firstCodeIndex];

        if (numberGlobalVariableAddress[varName] == 0)
        {
            numberGlobalVariableNum++;
            numberGlobalVariableAddress[varName] = numberGlobalVariableNum;

            globalVariableType[varName] = NUMBER_TYPE;

            isGlobalVariable[varName] = true;

            numberVariableInitialValue[numberGlobalVariableNum] = std::stod(code[firstCodeIndex]);
        }

        code[firstCodeIndex] = varName;
    }
}

int Convert::ConvertValue(const int firstCodeIndex, const bool convert)
{
    int type = -1;

    if (code[firstCodeIndex][0] == '"')
    {
        /*
        // String

        std::string varName = "@" + code[firstCodeIndex];

        if (stringVariableAddress[varName] == 0)
        {
            stringGlobalVariableNum++;
            stringGlobalVariableAddress[varName] = stringGlobalVariableNum;

            stringVariableInitialValue[stringGlobalVariableNum] = code[firstCodeIndex].substr(1, code[firstCodeIndex].size() - 1);
        }

        type = StringGlobalType;
        int address = stringVariableAddress[varName];

        if (convert)
            AddPushCode(type, address);
            */
    }
    else if (code[firstCodeIndex][0] == '-' || code[firstCodeIndex][0] == '.' || (0 <= (code[firstCodeIndex][0] - '0') && (code[firstCodeIndex][0] - '0') <= 9))
    {
        /*
        // Number

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

            numberVariableInitialValue[numberVariableNum] = std::
            stod(code[firstCodeIndex]);
        }

        type = NumberType;
        int address = numberVariableAddress[varName];

        if (convert)
            AddPushCode(type, address);
            */
    }
    else if (code[firstCodeIndex] == "true" || code[firstCodeIndex] == "false")
    {
        //* Bool

        type = BOOL_TYPE;

        if (code[firstCodeIndex] == "true" && convert)
            AddPushTrueCode();
        if (code[firstCodeIndex] == "false" && convert)
            AddPushFalseCode();
    }
    else
    {
        //* Variable

        int address;

        switch (variableType[code[firstCodeIndex]])
        {
        case NUMBER_TYPE:
            type = NUMBER_TYPE;

            if (numberVariableAddress[code[firstCodeIndex]] == 0)
                printf("The variable %s (Type:Number) is not declared!\n", code[firstCodeIndex].c_str());
            else
                address = numberVariableAddress[code[firstCodeIndex]];

            break;

        case NUMBER_GLOBAL_TYPE:
            type = NUMBER_GLOBAL_TYPE;

            if (numberGlobalVariableAddress[code[firstCodeIndex]] == 0)
                printf("The variable %s (Type:Number,Global) is not declared!\n", code[firstCodeIndex].c_str());
            else
                address = numberGlobalVariableAddress[code[firstCodeIndex]];

            break;

        case STRING_TYPE:
            type = STRING_TYPE;

            if (stringVariableAddress[code[firstCodeIndex]] == 0)
                printf("The variable %s (Type:String) is not declared!\n", code[firstCodeIndex].c_str());
            else
                address = stringVariableAddress[code[firstCodeIndex]];

            break;

        case STRING_GLOBAL_TYPE:
            type = STRING_GLOBAL_TYPE;

            if (stringGlobalVariableAddress[code[firstCodeIndex]] == 0)
                printf("The variable %s (Type:String,Global) is not declared!\n", code[firstCodeIndex].c_str());
            else
                address = stringGlobalVariableAddress[code[firstCodeIndex]];

            break;

        default:
            printf("The variable %s is not declared!\n", code[firstCodeIndex].c_str());
            break;
        }

        if (convert)
            AddPushCode(type, address, isGlobalVariable[code[firstCodeIndex]]);
    }

    return type;
}

Convert::formulaData Convert::ConvertFormula(const int firstCodeIndex, int operatorNumber, const bool convert)
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

                if (funcNames.count(code[i]) > 0 || cppFuncNames.count(code[i]) > 0)
                {
                    i += ConvertFunc(i, false);
                }
                else
                {
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

        if (convert)
        {
            ConvertFormula(parts[0].first, nextOperatorIndex, true);

            for (int j = 1; j < parts.size(); j++)
            {
                ConvertFormula(parts[j].first, nextOperatorIndex, true);

                AddCmdCode(convertOperator(operators[j - 1]), 2);
            }
        }

        formulaData returnFormulaData;

        returnFormulaData.codeSize = parts[parts.size() - 1].second - parts[0].first;
        returnFormulaData.type = NUMBER_TYPE;

        return returnFormulaData;
    }

    if (parts.size() < 1)
    {
        return formulaData();
    }

    formulaData returnFormulaData;

    returnFormulaData.codeSize = parts[parts.size() - 1].second - parts[0].first;

    if ((parts[0].second - parts[0].first == 1))
    {
        returnFormulaData.type = ConvertValue(firstCodeIndex, convert);
    }
    else if (funcNames.count(code[parts[0].first]) > 0 || cppFuncNames.count(code[parts[0].first]) > 0)
    {
        ConvertFunc(firstCodeIndex, convert);

        //TODO: returnFormulaData.type
    }
    else
    {
        if (code[parts[0].first] == "!")
        {
            returnFormulaData.type = ConvertFormula(firstCodeIndex, 0, convert).type;

            if (convert)
                AddCmdCode(NOT, 1);
        }
        else
        {
            returnFormulaData.type = ConvertFormula(firstCodeIndex + 1, 0, convert).type;
        }
    }

    //TODO:
    returnFormulaData.type = NUMBER_TYPE;

    return returnFormulaData;
}

int Convert::ConvertFunc(const int firstCodeIndex, const bool convert)
{
    funcData thisFuncData;
    thisFuncData.funcName = code[firstCodeIndex];

    int codeSize = 2; //* funcname(
    int codeIndex = firstCodeIndex + 2;

    if (code[codeIndex] == ")")
        codeSize++;

    while (code[codeIndex] != ")")
    {
        formulaData argData;
        argData = ConvertFormula(codeIndex, 0, false);

        thisFuncData.argTypes.push_back(argData.type);

        codeSize += argData.codeSize + 1;

        codeIndex += argData.codeSize;

        if (code[codeIndex] == ",")
            codeIndex++;
    }

    if (!isFuncExists[thisFuncData] && !isCppFuncExists[thisFuncData])
    {
        printf("Error : The function %s(", thisFuncData.funcName.c_str());
        for (int i = 0; i < thisFuncData.argTypes.size(); i++)
        {
            printf("%s", ID2TypeName(thisFuncData.argTypes[i]).c_str());
            if (i < thisFuncData.argTypes.size() - 1)
                printf(",");
        }
        printf(") is not declared\n");

        return codeSize;
    }

    bool isCppFunc = isCppFuncExists[thisFuncData];
    int funcID;
    if (isCppFunc)
        funcID = cppFuncIDs[thisFuncData];
    else
        funcID = funcIDs[thisFuncData];

    if (convert)
    {
        codeSize = 2;

        codeIndex = firstCodeIndex + 2;

        if (code[codeIndex] == ")")
            codeSize++;

        int argIndex = 0;
        while (code[codeIndex] != ")")
        {
            formulaData argData;
            argData = ConvertFormula(codeIndex, 0, false);

            if (!isCppFunc)
                AddPushCode(Type2AddressType(argData.type), funcArgAddresses[funcID][argIndex], true);

            ConvertFormula(codeIndex, 0, true);

            //TODO: Type
            if (!isCppFunc)
                AddCmdCode(SET_NUMBER_VARIABLE, 2);

            codeSize += argData.codeSize + 1;

            codeIndex += argData.codeSize;

            if (code[codeIndex] == ",")
                codeIndex++;

            argIndex++;
        }

        int backIndex = bytecodeIndex + 4;
        if (!isCppFunc)
            AddPushCode(INT_TYPE, -1, true);

        AddPushCode(INT_TYPE, funcID, true);

        if (isCppFunc)
            AddCmdCode(CALL_CPP_FUNC, 1 + thisFuncData.argTypes.size());
        else
            AddCmdCode(CALL_MALLET_FUNC, 1);

        if (!isCppFunc)
            bytecode[backIndex] = bytecodeIndex;
    }

    return codeSize;
}

int Convert::ConvertCodeBlock(const int firstCodeIndex, const int funcID)
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
        std::string token = code[codeIndex];

        int codeSize = 0;

        if (token == "{")
        {
            codeSize = 2 + ConvertCodeBlock(codeIndex, funcID);
        }
        else if (token == "return")
        {
            //TODO: check type

            if (funcTypes[funcID] == VOID_TYPE)
                codeSize = 1;
            else
                codeSize = 1 + ConvertFormula(codeIndex + 1, 0, true).codeSize;

            AddCmdCode(RETURN, 0);
        }
        else if (token == "print")
        {
            codeSize = 3 + ConvertFormula(codeIndex + 2, 0, true).codeSize;

            AddCmdCode(PRINT_NUMBER, 1);
        }
        else if (token == "number")
        {
            std::string varName = code[codeIndex + 1];

            if (variableType[varName] != 0 || funcNames.count(varName) > 0)
            {
                printf("The variable %s is already declared\n", varName.c_str());
            }

            variableType[varName] = NUMBER_TYPE;
            numberVariableNum++;
            numberVariableAddress[varName] = numberVariableNum;

            codeSize = 1;
        }
        else if (token == "string")
        {
        }
        else if (token == "bool")
        {
        }
        else if (token == "while")
        {
            int firstIndex = bytecodeIndex;

            codeSize = 3 + ConvertFormula(codeIndex + 2, 0, true).codeSize;

            AddCmdCode(NOT, 1);

            int firstJumpIndex = bytecodeIndex;

            AddPushCode(INT_TYPE, -1, true);

            AddCmdCode(JUMP, 2);

            codeSize += ConvertCodeBlock(codeIndex + codeSize, funcID);

            AddPushTrueCode();

            AddPushCode(INT_TYPE, firstIndex, true);

            AddCmdCode(JUMP, 2);

            bytecode[firstJumpIndex + 4] = bytecodeIndex;
        }
        else if (token == "if")
        {
            codeSize = 3 + ConvertFormula(codeIndex + 2, 0, true).codeSize;

            AddCmdCode(NOT, 1);

            int firstJumpIndex = bytecodeIndex;

            AddPushCode(INT_TYPE, -1, true);
            AddCmdCode(JUMP, 2);

            codeSize += ConvertCodeBlock(codeIndex + codeSize, funcID);

            if (code[codeIndex + codeSize] == "else")
            {
                AddPushTrueCode();

                int secondJumpIndex = bytecodeIndex;

                AddPushCode(INT_TYPE, -1, true);

                AddCmdCode(JUMP, 2);

                bytecode[firstJumpIndex + 4] = bytecodeIndex;

                codeSize++;

                codeSize += ConvertCodeBlock(codeIndex + codeSize, funcID);

                bytecode[secondJumpIndex + 4] = bytecodeIndex;
            }
            else
            {
                bytecode[firstJumpIndex + 4] = bytecodeIndex;
            }
        }
        else if (token == "repeat")
        {
            numberVariableNum++;
            int countVarAddress = numberVariableNum;

            numberVariableNum++;
            int repeatTimeVarAddress = numberVariableNum;

            AddPushCode(NUMBER_ADDRESS_TYPE, repeatTimeVarAddress, false);
            codeSize = 3 + ConvertFormula(codeIndex + 2, 0, true).codeSize;
            AddCmdCode(SET_NUMBER_VARIABLE, 2);

            AddPushCode(NUMBER_ADDRESS_TYPE, countVarAddress, false);
            AddPush0Code();
            AddCmdCode(SET_NUMBER_VARIABLE, 2);

            int firstIndex = bytecodeIndex;

            AddPushCode(NUMBER_TYPE, countVarAddress, false);
            AddPushCode(NUMBER_TYPE, repeatTimeVarAddress, false);
            AddCmdCode(LESS_THAN, 2);
            AddCmdCode(NOT, 1);

            int firstJumpIndex = bytecodeIndex;

            AddPushCode(INT_TYPE, -1, true);

            AddCmdCode(JUMP, 2);

            codeSize += ConvertCodeBlock(codeIndex + codeSize, funcID);

            AddPushCode(NUMBER_ADDRESS_TYPE, countVarAddress, false);
            AddPushCode(NUMBER_TYPE, countVarAddress, false);
            AddPush1Code();
            AddCmdCode(ADD, 2);
            AddCmdCode(SET_NUMBER_VARIABLE, 2);

            AddPushTrueCode();

            AddPushCode(INT_TYPE, firstIndex, true);

            AddCmdCode(JUMP, 2);

            bytecode[firstJumpIndex + 4] = bytecodeIndex;
        }
        else if (variableType[code[codeIndex]] != 0)
        {
            int addressType = -1;
            int type = variableType[code[codeIndex]];
            int address;
            int codeID;

            switch (type)
            {
            case NUMBER_TYPE:
                addressType = NUMBER_ADDRESS_TYPE;
                address = numberVariableAddress[code[codeIndex]];
                codeID = SET_NUMBER_VARIABLE;
                break;

            case NUMBER_GLOBAL_TYPE:
                //TODO:
                break;

            case STRING_TYPE:
                addressType = STRING_ADDRESS_TYPE;
                address = stringVariableAddress[code[codeIndex]];
                codeID = SET_STRING_VARIABLE;
                break;

            case STRING_GLOBAL_TYPE:
                //TODO:
                break;

            case BOOL_TYPE:
                //TODO:
                break;

            case BOOL_GLOBAL_TYPE:
                //TODO:
                break;

            default:
                //TODO:
                break;
            }

            AddPushCode(addressType, address, isGlobalVariable[code[codeIndex]]);

            codeSize = 2 + ConvertFormula(codeIndex + 2, 0, true).codeSize;

            AddCmdCode(codeID, 2);
        }
        else if (funcNames.count(token) > 0 || cppFuncNames.count(token) > 0)
        {
            codeSize = ConvertFunc(codeIndex, true);
        }
        else
        {
            // printf("%s is undefined #%d\n", code[codeIndex].c_str(), codeIndex);
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

std::string Convert::ConvertCodeToJson(std::string codeStr)
{
    InitConverter();

    code = SplitCode(codeStr, symbol, doubleSymbol, reservedWord);

    ListFunction();
    ListCppFunction();

    for (int codeIndex = 0; codeIndex < code.size(); codeIndex++)
    {
        DeclareConstant(codeIndex);
    }

    for (auto i : code)
        printf("%s\n", i.c_str());

    for (int funcID = 0; funcID < funcStartIndexes.size(); funcID++)
    {
        ClearLocalVariable();

        funcBytecodeStartIndexes.push_back(bytecodeIndex);

        for (int argIndex = 0; argIndex < funcArgAddresses[funcID].size(); argIndex++)
        {
            int type = funcArgTypes[funcID][argIndex];
            AddPushCode(Type2AddressType(type), DeclareVariable(type, funcArgOriginalVariableNames[funcID][argIndex], false), false);
            AddPushCode(type, funcArgAddresses[funcID][argIndex], true);

            //TODO:
            AddCmdCode(SET_NUMBER_VARIABLE, 2);
        }

        int funcStartIndex = funcStartIndexes[funcID];
        std::string funcName = code[funcStartIndex + 1];

        int codeIndex = funcStartIndex + 3;

        if (code[codeIndex] == ")")
        {
            codeIndex += 1;
        }
        else
        {
            while (code[codeIndex] != "{")
                codeIndex += 3;
        }

        ConvertCodeBlock(codeIndex, funcID);

        AddCmdCode(RETURN, 0);

        AddCmdCode(END_OF_FUNC, 0);

        numberMemorySize.push_back(numberVariableNum);
        stringMemorySize.push_back(stringVariableNum);
        boolMemorySize.push_back(boolVariableNum);

        /*
        std::vector<int> tmp;

        for (int i = 0; i < bytecodeSize; i++)
        {
            tmp.push_back(bytecode[i]);
        }

        numberVariableNums.push_back(numberVariableNum);
        stringVariableNums.push_back(stringVariableNum);
        boolVariableNums.push_back(boolVariableNum);
        */
    }

    bytecode.resize(bytecodeSize);

    return "";
}

void Convert::ListFunction()
{
    int codeIndex = 0;

    int funcID = 0;

    funcArgAddresses = std::vector<std::vector<int>>();

    std::unordered_map<std::string, std::string> newVarName;

    while (codeIndex < code.size())
    {
        if (typeName.count(code[codeIndex]) > 0)
        {
            newVarName.clear();

            funcArgAddresses.push_back(std::vector<int>());
            funcArgTypes.push_back(std::vector<int>());
            funcArgOriginalVariableNames.push_back(std::vector<std::string>());

            funcStartIndexes.push_back(codeIndex);

            funcData newFuncData;

            int type = TypeName2ID(code[codeIndex]);
            newFuncData.funcName = code[codeIndex + 1];

            codeIndex += 3;

            if (code[codeIndex] == ")")
            {
                codeIndex += 2;
            }
            else
            {
                while (code[codeIndex] != "{")
                {
                    int type = TypeName2ID(code[codeIndex]);

                    std::string name = code[codeIndex + 1];
                    std::string newName = "#" + std::to_string(funcID) + "_" + name;

                    funcArgAddresses[funcID].push_back(DeclareVariable(type, newName, true));
                    funcArgTypes[funcID].push_back(type);
                    funcArgOriginalVariableNames[funcID].push_back(name);

                    isGlobalVariable[newName] = true;

                    code[codeIndex + 1] = newName;
                    newVarName[name] = newName;

                    if (type == BOOL_TYPE)
                        type = NUMBER_TYPE;

                    newFuncData.argTypes.push_back(type);

                    codeIndex += 3;
                }

                codeIndex++;
            }

            int bracketStack = 1;
            while (bracketStack > 0)
            {
                if (code[codeIndex] == "{")
                    bracketStack++;
                if (code[codeIndex] == "}")
                    bracketStack--;

                /*
                if (newVarName[code[codeIndex]] != "")
                    code[codeIndex] = newVarName[code[codeIndex]];
                */

                codeIndex++;
            }

            if (isFuncExists[newFuncData] || isCppFuncExists[newFuncData])
            {
                //TODO: show detail
                printf("The function %s is already declared\n", newFuncData.funcName.c_str());
                break;
            }

            funcNames.insert(newFuncData.funcName);
            funcIDs[newFuncData] = funcID;
            isFuncExists[newFuncData] = true;
            funcTypes.push_back(type);
            funcID++;
        }
        else
        {
            printf("This code is broken #%d\n", codeIndex);
            break;
        }
    }
}

int Convert::DeclareVariable(const int type, const std::string name, const bool isGlobal)
{
    if (variableType[name] > 0)
    {
        printf("Error : The variable %s is already declared\n", name.c_str());
        return -1;
    }

    if (isGlobal)
        globalVariableType[name] = type;
    else
        variableType[name] = type;

    int address;

    switch (type)
    {
    case NUMBER_TYPE:
        if (isGlobal)
        {
            numberGlobalVariableNum++;
            numberGlobalVariableAddress[name] = numberGlobalVariableNum;
            address = numberGlobalVariableNum;
        }
        else
        {
            numberVariableNum++;
            numberVariableAddress[name] = numberVariableNum;
            address = numberVariableNum;
        }

        break;

    case STRING_TYPE:
        if (isGlobal)
        {
            stringGlobalVariableNum++;
            stringGlobalVariableAddress[name] = stringGlobalVariableNum;
            address = stringGlobalVariableNum;
        }
        else
        {
            stringVariableNum++;
            stringVariableAddress[name] = stringVariableNum;
            address = stringVariableNum;
        }

        break;

    case BOOL_TYPE:
        if (isGlobal)
        {
            numberGlobalVariableNum++;
            numberGlobalVariableAddress[name] = numberGlobalVariableNum;
            address = numberGlobalVariableNum;
        }
        else
        {
            boolVariableNum++;
            boolVariableAddress[name] = boolVariableNum;
            address = boolVariableNum;
        }

        break;

    default:
        printf("Error : %d is undefined\n", type);
        address = -1;
        break;
    }

    return address;
}

int Convert::TypeName2ID(const std::string typeName)
{
    if (typeName == "void")
        return VOID_TYPE;
    if (typeName == "number")
        return NUMBER_TYPE;
    if (typeName == "string")
        return STRING_TYPE;
    if (typeName == "bool")
        return BOOL_TYPE;

    return -1;
}

std::string Convert::ID2TypeName(const int typeID)
{
    if (typeID == NUMBER_TYPE)
        return "number";
    if (typeID == STRING_TYPE)
        return "string";
    if (typeID == BOOL_TYPE)
        return "bool";
    if (typeID == VOID_TYPE)
        return "void";

    return "Unknown Type";
}

int Convert::LocalType2GlobalType(const int typeID)
{
    if (typeID == NUMBER_TYPE)
        return NUMBER_GLOBAL_TYPE;
    if (typeID == STRING_TYPE)
        return STRING_GLOBAL_TYPE;
    if (typeID == BOOL_TYPE)
        return BOOL_GLOBAL_TYPE;

    return typeID;
}

int Convert::Type2AddressType(const int typeID)
{
    if (typeID == NUMBER_TYPE)
        return NUMBER_ADDRESS_TYPE;
    if (typeID == STRING_TYPE)
        return STRING_ADDRESS_TYPE;
    if (typeID == BOOL_TYPE)
        return BOOL_ADDRESS_TYPE;

    return typeID;
}

void Convert::AddCode(int code)
{
    if (bytecodeIndex >= bytecode.size())
        return;

    bytecode[bytecodeIndex] = code;
    bytecodeIndex++;
    bytecodeSize++;
}

void Convert::AddCmdCode(int code, int argNum)
{
    AddCode(CODE_BEGIN);
    AddCode(code);
    AddCode(argNum);
}

void Convert::AddPushCode(int type, int address, bool absolute)
{
    AddCode(CODE_BEGIN);
    AddCode(PUSH);
    AddCode(0);
    AddCode(type);
    AddCode(address);
    AddCode(absolute ? 1 : 0);
}

void Convert::AddPushTrueCode()
{
    AddPushCode(BOOL_TYPE, 1, true);
}

void Convert::AddPushFalseCode()
{
    AddPushCode(BOOL_TYPE, 2, true);
}

void Convert::AddPush0Code()
{
    AddPushCode(NUMBER_TYPE, 1, true);
}

void Convert::AddPush1Code()
{
    AddPushCode(NUMBER_TYPE, 2, true);
}

void Convert::InitConverter()
{

    bytecode = std::vector<int>(1000000);
    bytecodeIndex = 0;
    bytecodeSize = 0;

    //numberVariableInitialValue.push_back(std::unordered_map<int, double>());
    //stringVariableInitialValue.push_back(std::unordered_map<int, std::string>());

    numberVariableInitialValue = std::unordered_map<int, double>();
    stringVariableInitialValue = std::unordered_map<int, std::string>();

    variableType.clear();
    globalVariableType.clear();

    numberGlobalVariableAddress.clear();
    stringGlobalVariableAddress.clear();
    boolGlobalVariableAddress.clear();

    numberGlobalVariableNum = 2;
    stringGlobalVariableNum = 0;
    boolGlobalVariableNum = 2;
}

void Convert::ClearLocalVariable()
{
    variableType = globalVariableType;
    numberVariableAddress = numberGlobalVariableAddress;
    stringVariableAddress = stringGlobalVariableAddress;
    boolVariableAddress = boolGlobalVariableAddress;

    numberVariableNum = 0;
    stringVariableNum = 0;
    boolVariableNum = 0;
}
