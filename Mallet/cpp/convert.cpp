//
//  convert.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/06/28.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "convert.hpp"

std::string Convert::RemoveComments(std::string codeStr)
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

std::vector<std::string> Convert::SplitCode(std::string codeStr)
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
    else if (operatorString == "~")
        operatorCode = CONNECT_STRING;
    else
        printf("\"%s\" is not an operator!\n", operatorString.c_str());

    return operatorCode;
}

int Convert::DeclareString(const std::string str)
{
    std::string varName = "@" + str;

    if (checkName(varName))
    {
        globalVariableNum++;

        globalVariableAddress[varName] = globalVariableNum;

        globalVariableTypes[varName] = {true, false, false, false, false, -1, -1};

        variableInitialValues[globalVariableNum] = str;

        return globalVariableNum;
    }

    return -1;
}

void Convert::DeclareConstant(const int firstCodeIndex)
{
    if (code[firstCodeIndex][0] == '"')
    {
        //* String

        std::string varName = "@" + code[firstCodeIndex];

        puts(varName.c_str());

        if (checkName(varName))
        {
            globalVariableNum++;

            globalVariableAddress[varName] = globalVariableNum;

            globalVariableTypes[varName] = {true, false, false, false, false, -1, -1};
            variableTypes[varName] = {true, false, false, false, false, -1, -1};

            variableInitialValues[globalVariableNum] = code[firstCodeIndex].substr(1, code[firstCodeIndex].size() - 2);
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

            if (!(code[firstCodeIndex][i] == '.' || (0 <= (code[firstCodeIndex][i] - '0') && (code[firstCodeIndex][i] - '0') <= 9)))
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

        if (checkName(varName))
        {
            globalVariableNum++;
            globalVariableAddress[varName] = globalVariableNum;

            globalVariableTypes[varName] = {true, false, false, false, false, -1, -1};
            variableTypes[varName] = {true, false, false, false, false, -1, -1};

            variableInitialValues[globalVariableNum] = std::stod(code[firstCodeIndex]);
        }

        code[firstCodeIndex] = varName;
    }
}

void Convert::ConvertValue(const int firstCodeIndex, const bool convert)
{
    if (code[firstCodeIndex][0] == '"')
    {
    }
    else if (code[firstCodeIndex][0] == '-' || code[firstCodeIndex][0] == '.' || (0 <= (code[firstCodeIndex][0] - '0') && (code[firstCodeIndex][0] - '0') <= 9))
    {
    }
    else if (code[firstCodeIndex] == "true" || code[firstCodeIndex] == "false")
    {
        if (code[firstCodeIndex] == "true" && convert)
            AddPushTrueCode();
        if (code[firstCodeIndex] == "false" && convert)
            AddPushFalseCode();
    }
    else
    {
        //* Variable

        int address = -1;

        auto typeInfo = variableTypes[code[firstCodeIndex]];

        if (typeInfo.isList)
        {
            if (typeInfo.isGlobalVariable)
            {
                address = globalListAddresses[code[firstCodeIndex]];

                if (convert)
                    AddPushAddressCode(address, true);
            }
            else
            {
                address = listAddresses[code[firstCodeIndex]];

                if (convert)
                    AddPushAddressCode(address, false);
            }
        }
        else
        {
            if (typeInfo.isGlobalVariable)
            {
                address = globalVariableAddress[code[firstCodeIndex]];

                if (convert)
                    AddPushGlobalCode(address);
            }
            else
            {
                address = variableAddresses[code[firstCodeIndex]];

                if (convert)
                    AddPushCode(address, false);
            }
        }
    }
}

int Convert::ConvertListElement(const int firstCodeIndex, const bool convert)
{
    if (convert)
    {
        std::string listName = code[firstCodeIndex];

        int address = listAddresses[listName];

        AddPushAddressCode(address, false);
    }

    int codeSize = 3 + ConvertFormula(firstCodeIndex + 2, 0, convert);

    if (convert)
    {
        AddCmdCode(GET_LIST, 2);
    }

    return codeSize;
}

int Convert::ConvertFormula(const int firstCodeIndex, int operatorNumber, const bool convert)
{
    const std::vector<std::set<std::string>> operatorsPriorities = {
        {"||"},
        {"&&"},
        {"==", "!="},
        {"<", "<=", ">", ">="},
        {"+", "-"},
        {"*", "/", "%"},
        {"~"},
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
                if (bracketStack == 0)
                {
                    if (operatorsPrioritiesAccum[operatorIndex].count(code[i]) > 0)
                    {
                        if (code[i] != "-" || !(0 < i && isSymbol(code[i - 1])))
                        {
                            break;
                        }
                    }

                    if (operatorsPriority.count(code[i]) > 0 || code[i] == "," || code[i] == ")" || code[i] == "}" || code[i] == "]")
                    {
                        break;
                    }

                    if (start < i && ((symbol.count(code[i - 1]) == 0 && doubleSymbol.count(code[i - 1]) == 0) || code[i - 1] == ")") && (symbol.count(code[i]) == 0 && doubleSymbol.count(code[i]) == 0))
                        break;
                }

                if (isFuncExists[code[i]] || isCppFuncExists[code[i]] || defaultFuncNames.count(code[i]) > 0)
                {
                    i += ConvertFunc(i, false);
                }
                else
                {
                    if (firstCodeIndex < i && bracketStack == 0)
                        allBracket = false;

                    if (code[i] == "(" || code[i] == "[")
                        bracketStack++;
                    if (code[i] == ")" || code[i] == "]")
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

        int codeSize = parts[parts.size() - 1].second - parts[0].first;

        return codeSize;
    }

    /*
    for (auto p : parts)
    {
        printf("%d %d\n", p.first, p.second);
    }
    */

    if (parts.size() < 1)
    {
        return -1;
    }

    int codeSize = parts[parts.size() - 1].second - parts[0].first;

    if ((parts[0].second - parts[0].first == 1))
    {
        ConvertValue(firstCodeIndex, convert);
        //returnFormulaData.type = 0;
    }
    else if (code[parts[0].first + 1] == "[" && code[parts[0].second - 1] == "]")
    {
        ConvertListElement(firstCodeIndex, convert);
    }
    else if (isFuncExists[code[parts[0].first]] || isCppFuncExists[code[parts[0].first]] || defaultFuncNames.count(code[parts[0].first]) > 0)
    {
        ConvertFunc(firstCodeIndex, convert);
    }
    else
    {
        if (code[parts[0].first] == "!")
        {
            if (code[parts[0].first] == "(")
                ConvertFormula(firstCodeIndex + 1, 0, convert);
            else
                ConvertFormula(firstCodeIndex + 1, 6, convert);

            if (convert)
                AddCmdCode(NOT, 1);
        }
        else if (code[parts[0].first] == "-")
        {
            if (convert)
                AddPush0Code();

            if (code[parts[0].first] == "(")
                ConvertFormula(firstCodeIndex + 1, 0, convert);
            else
                ConvertFormula(firstCodeIndex + 1, 6, convert);

            if (convert)
                AddCmdCode(SUB, 2);
        }
        else
        {
            ConvertFormula(firstCodeIndex + 1, 0, convert);
        }
    }

    return codeSize;
}

int Convert::ConvertFunc(const int firstCodeIndex, const bool convert)
{
    std::string funcName = code[firstCodeIndex];
    if (!isFuncExists[funcName] && !isCppFuncExists[funcName] && defaultFuncNames.count(funcName) == 0)
    {
        printf("Error : The function %s is not declared\n", funcName.c_str());

        return 0;
    }

    funcData thisFuncData;
    if (isFuncExists[funcName] || defaultFuncNames.count(funcName))
        thisFuncData = funcDataMap[funcName];
    if (isCppFuncExists[funcName])
        thisFuncData = cppFuncDataMap[funcName];

    int codeSize = 2; //* funcname(
    int codeIndex = firstCodeIndex + 2;

    if (code[codeIndex] == ")")
        codeSize += 1;

    while (code[codeIndex] != ")")
    {
        int formulaCodeSize = ConvertFormula(codeIndex, 0, false);

        codeSize += formulaCodeSize + 1;

        codeIndex += formulaCodeSize;

        if (code[codeIndex] == ",")
            codeIndex++;
    }

    bool isCppFunc = isCppFuncExists[thisFuncData.funcName];
    bool isMalletFunc = isFuncExists[thisFuncData.funcName] && (defaultFuncNames.count(thisFuncData.funcName) == 0);
    bool isDefaultFunc = defaultFuncNames.count(thisFuncData.funcName) > 0;

    int funcID;
    if (isCppFunc)
        funcID = cppFuncIDs[thisFuncData.funcName];
    if (isMalletFunc)
        funcID = funcIDs[thisFuncData.funcName];

    if (convert)
    {
        codeSize = 2;

        codeIndex = firstCodeIndex + 2;

        if (code[codeIndex] == ")")
            codeSize++;

        int argIndex = 0;

        bool setList = false;
        bool addToList = false;
        bool isCloudList = false;
        bool isPersistentList = false;
        int listAddress;
        int listUIid;
        int listNameAddress;

        while (code[codeIndex] != ")")
        {
            if (isMalletFunc)
                AddPushAddressCode(funcArgAddresses[funcID][argIndex], true);

            ArgType type = thisFuncData.argType[argIndex];

            switch (type)
            {
            case ArgType::VALUE:
            {
                int formulaCodeSize = ConvertFormula(codeIndex, 0, true);

                codeSize += formulaCodeSize + 1;

                codeIndex += formulaCodeSize;
            }
            break;

            case ArgType::VAR:
            {
                std::string varName = code[codeIndex];
                auto typeInfo = variableTypes[varName];

                if (!typeInfo.isList)
                {
                    int address = variableAddresses[varName];

                    if (typeInfo.isGlobalVariable)
                    {
                        AddPushAddressCode(address, true);
                    }
                    else
                    {
                        AddPushAddressCode(address, false);
                    }

                    codeSize += 2;
                    codeIndex += 1;
                }
            }
            break;

            case ArgType::LIST:
            {
                std::string varName = code[codeIndex];
                auto typeInfo = variableTypes[varName];
                if (typeInfo.isList)
                {
                    int address = listAddresses[varName];

                    if (typeInfo.isGlobalVariable)
                    {
                        AddPushAddressCode(address, true);
                    }
                    else
                    {
                        AddPushAddressCode(address, false);
                    }
                }

                codeSize += 2;
                codeIndex += 1;

                if (argIndex == 0)
                {
                    if (funcName == "add" ||
                        funcName == "insert" ||
                        funcName == "remove")
                    {
                        setList = true;
                        listAddress = globalListAddresses[varName];
                        listUIid = globalVariableTypes[varName].uiID;
                        listNameAddress = globalVariableTypes[varName].nameAddress;

                        isCloudList = globalVariableTypes[varName].isCloudVariable;
                        isPersistentList = globalVariableTypes[varName].isPersistentVariable;
                        addToList = funcName == "add";
                    }
                }
            }
            break;

            case ArgType::UI:
            {
                std::string varName = code[codeIndex];
                auto typeInfo = variableTypes[varName];
                if (typeInfo.isUI)
                {
                    AddPushAddressCode(typeInfo.uiID, true);
                }

                codeSize += 2;
                codeIndex += 1;
            }
            break;

            default:
                break;
            }

            if (isMalletFunc)
                AddCmdCode(SET_GLOBAL_VARIABLE, 2);

            if (code[codeIndex] == ",")
                codeIndex++;

            argIndex++;
        }

        int backIndex = bytecodeIndex + 3;
        if (isMalletFunc)
            AddPushAddressCode(-1, true);

        if (isMalletFunc || isCppFunc)
            AddPushAddressCode(funcID, true);

        if (isCppFunc)
            AddCmdCode(CALL_CPP_FUNC, 1 + thisFuncData.argType.size());
        if (isMalletFunc)
            AddCmdCode(CALL_MALLET_FUNC, 1);

        if (isMalletFunc)
            bytecode[backIndex] = bytecodeIndex;

        if (isDefaultFunc)
            AddCmdCode(defaultFuncData[thisFuncData.funcName].first, defaultFuncData[thisFuncData.funcName].second.size());

        if (setList)
        {
            AddPushAddressCode(listUIid, true);
            AddPushAddressCode(listAddress, true);
            AddCmdCode(SET_LIST_UI, 2);

            if (isPersistentList)
            {
                AddPushAddressCode(listNameAddress, true);
                AddPushAddressCode(listAddress, true);
                AddCmdCode(SET_PERSISTENT_LIST, 2);
            }

            if (isCloudList)
            {
                AddPushAddressCode(listNameAddress, true);
                AddPushAddressCode(listAddress, true);
                if (addToList)
                    AddCmdCode(ADD_TO_CLOUD_LIST, 2);
                else
                    AddCmdCode(SET_CLOUD_LIST, 2);
            }
        }
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
            /*
            TODO:

            ! if (1==1)
            !    return <=
            ! if (1==2)
            
            */
            if (code[codeIndex + 1] == "}")
            {
                codeSize = 1;
                AddPush0Code();
            }
            else
            {
                codeSize = 1 + ConvertFormula(codeIndex + 1, 0, true);
            }

            AddCmdCode(RETURN, 0);
        }
        else if (token == "print")
        {
            codeSize = 3 + ConvertFormula(codeIndex + 2, 0, true);

            AddCmdCode(PRINT_NUMBER, 1);
        }
        else if (token == "var")
        {
            std::string varName = code[codeIndex + 1];

            if (!checkName(varName))
            {
                printf("The variable %s is already declared\n", varName.c_str());
            }

            DeclareVariable(varName, false);

            codeSize = 1;
        }
        else if (token == "list")
        {
            std::string listName = code[codeIndex + 1];

            if (!checkName(listName))
            {
                printf("The variable %s is already declared\n", listName.c_str());
            }

            DeclareList(listName, false);

            codeSize += 1;
        }
        else if (token == "while")
        {
            int firstIndex = bytecodeIndex;

            codeSize = 3 + ConvertFormula(codeIndex + 2, 0, true);

            AddCmdCode(NOT, 1);

            int firstJumpIndex = bytecodeIndex;

            AddPushAddressCode(-1, true);

            AddCmdCode(JUMP, 2);

            codeSize += ConvertCodeBlock(codeIndex + codeSize, funcID);

            AddPushTrueCode();

            AddPushAddressCode(firstIndex, true);

            AddCmdCode(JUMP, 2);

            bytecode[firstJumpIndex + 3] = bytecodeIndex;
        }
        else if (token == "if")
        {
            codeSize = 3 + ConvertFormula(codeIndex + 2, 0, true);

            AddCmdCode(NOT, 1);

            int firstJumpIndex = bytecodeIndex;

            AddPushAddressCode(-1, true);
            AddCmdCode(JUMP, 2);

            codeSize += ConvertCodeBlock(codeIndex + codeSize, funcID);

            if (code[codeIndex + codeSize] == "else")
            {
                AddPushTrueCode();

                int secondJumpIndex = bytecodeIndex;

                AddPushAddressCode(-1, true);

                AddCmdCode(JUMP, 2);

                bytecode[firstJumpIndex + 3] = bytecodeIndex;

                codeSize++;

                codeSize += ConvertCodeBlock(codeIndex + codeSize, funcID);

                bytecode[secondJumpIndex + 3] = bytecodeIndex;
            }
            else
            {
                bytecode[firstJumpIndex + 3] = bytecodeIndex;
            }
        }
        else if (token == "repeat")
        {
            variableNum++;
            int countVarAddress = variableNum;

            variableNum++;
            int repeatTimeVarAddress = variableNum;

            AddPushAddressCode(repeatTimeVarAddress, false);
            codeSize = 3 + ConvertFormula(codeIndex + 2, 0, true);
            AddCmdCode(SET_VARIABLE, 2);

            AddPushAddressCode(countVarAddress, false);
            AddPush0Code();
            AddCmdCode(SET_VARIABLE, 2);

            int firstIndex = bytecodeIndex;

            AddPushCode(countVarAddress, false);
            AddPushCode(repeatTimeVarAddress, false);
            AddCmdCode(LESS_THAN, 2);
            AddCmdCode(NOT, 1);

            int firstJumpIndex = bytecodeIndex;

            AddPushAddressCode(-1, true);

            AddCmdCode(JUMP, 2);

            codeSize += ConvertCodeBlock(codeIndex + codeSize, funcID);

            AddPushAddressCode(countVarAddress, false);
            AddPushCode(countVarAddress, false);
            AddPush1Code();
            AddCmdCode(ADD, 2);
            AddCmdCode(SET_VARIABLE, 2);

            AddPushTrueCode();

            AddPushAddressCode(firstIndex, true);

            AddCmdCode(JUMP, 2);

            bytecode[firstJumpIndex + 3] = bytecodeIndex;
        }
        else if (isFuncExists[token] || isCppFuncExists[token] || defaultFuncNames.count(token) > 0)
        {
            codeSize = ConvertFunc(codeIndex, true);
        }
        else
        {
            std::string varName = code[codeIndex];

            if (checkName(varName))
            {
                DeclareVariable(varName, false);
            }

            auto typeInfo = variableTypes[varName];

            if (typeInfo.isList)
            {
                if (typeInfo.isGlobalVariable)
                {
                    int address = globalListAddresses[varName];

                    AddPushAddressCode(address, true);
                    AddCmdCode(INIT_LIST, 1);

                    int index = codeIndex + 3;

                    if (code[index] == "}")
                    {
                        index += 1;
                    }
                    else
                    {
                        while (code[index - 1] != "}")
                        {
                            AddPushAddressCode(address, true);
                            index += ConvertFormula(index, 0, true) + 1;
                            AddCmdCode(ADD_LIST, 2);
                        }
                    }

                    codeSize = index - codeIndex;

                    if (typeInfo.isPersistentVariable)
                    {
                        AddPushAddressCode(typeInfo.nameAddress, true);

                        AddPushAddressCode(address, true);

                        AddCmdCode(SET_PERSISTENT_LIST, 2);
                    }

                    if (typeInfo.isCloudVariable)
                    {
                        AddPushAddressCode(typeInfo.nameAddress, true);

                        AddPushAddressCode(address, true);

                        AddCmdCode(SET_CLOUD_LIST, 2);
                    }

                    if (typeInfo.isUI)
                    {
                        AddPushAddressCode(typeInfo.uiID, true);
                        AddPushAddressCode(address, true);
                        AddCmdCode(SET_LIST_UI, 2);
                    }
                }
                else
                {
                    int address = listAddresses[varName];

                    AddPushAddressCode(address, false);
                    AddCmdCode(INIT_LIST, 1);

                    //       v
                    // a = { 1 , 2 , 8 }
                    //       ^
                    int index = codeIndex + 3;

                    if (code[index] == "}")
                    {
                        index += 1;
                    }
                    else
                    {
                        while (code[index - 1] != "}")
                        {
                            AddPushAddressCode(address, false);
                            index += ConvertFormula(index, 0, true) + 1;
                            AddCmdCode(ADD_LIST, 2);
                        }
                    }

                    codeSize = index - codeIndex;
                }
            }
            else
            {
                if (typeInfo.isGlobalVariable)
                {
                    int address = globalVariableAddress[varName];

                    AddPushAddressCode(address, true);

                    codeSize = 2 + ConvertFormula(codeIndex + 2, 0, true);

                    AddCmdCode(SET_GLOBAL_VARIABLE, 2);

                    if (typeInfo.isPersistentVariable)
                    {
                        AddPushAddressCode(typeInfo.nameAddress, true);

                        AddPushGlobalCode(address);

                        AddCmdCode(SET_PERSISTENT_VARIABLE, 2);
                    }

                    if (typeInfo.isCloudVariable)
                    {
                        AddPushAddressCode(typeInfo.nameAddress, true);

                        AddPushGlobalCode(address);

                        AddCmdCode(SET_CLOUD_VARIABLE, 2);
                    }
                }
                else
                {
                    int address = variableAddresses[varName];

                    AddPushAddressCode(address, false);

                    codeSize = 2 + ConvertFormula(codeIndex + 2, 0, true);

                    AddCmdCode(SET_VARIABLE, 2);
                }
            }
        }

        codeIndex += codeSize;
        codeBlockSize += codeSize;

        if (!isBlock)
            break;
    }

    return codeBlockSize;
}

std::string getInitialValueStr(var value)
{
    std::string str = "";

    if (std::holds_alternative<ControlCode>(value))
    {
        str += "CONTROL_CODE\n";
        str += std::to_string((int)std::get<ControlCode>(value));
    }

    if (std::holds_alternative<int>(value))
    {
        str += "INT\n";
        str += std::to_string(std::get<int>(value));
    }

    if (std::holds_alternative<double>(value))
    {
        std::ostringstream strstream;
        strstream << std::fixed << std::setprecision(10) << std::get<double>(value);
        str += "NUMBER\n";
        str += strstream.str();
    }

    if (std::holds_alternative<bool>(value))
    {
        str += "BOOL\n";
        str += std::to_string(std::get<bool>(value));
    }

    if (std::holds_alternative<std::string>(value))
    {
        str += "STRING\n";
        str += std::get<std::string>(value);
    }

    str += "\n";

    return str;
}

std::string Convert::Code2Str()
{
    std::string str = "#START\n";

    str += "#CODE\n";
    for (int code : bytecode)
    {
        str += std::to_string(code) + "\n";
    }
    str += "#CODE_END\n";

    str += "#INITIAL_VALUE\n";
    for (auto value : variableInitialValues)
    {
        str += std::to_string(value.first) + "\n";
        str += getInitialValueStr(value.second);
    }
    str += "#INITIAL_VALUE_END\n";

    str += "#FUNC_START_INDEXES\n";
    for (int index : funcBytecodeStartIndexes)
    {
        str += std::to_string(index) + "\n";
    }
    str += "#FUNC_START_INDEXES_END\n";

    str += "#ARG_ADDRESSES\n";
    for (int funcID = 0; funcID < funcArgAddresses.size(); funcID++)
    {
        str += std::to_string(funcArgAddresses[funcID].size()) + "\n";

        for (int address : funcArgAddresses[funcID])
        {
            str += std::to_string(address) + "\n";
        }
    }
    str += "#ARG_ADDRESSES_END\n";

    str += "#MEMORY_SIZE\n";
    for (int size : memorySize)
    {
        str += std::to_string(size) + "\n";
    }
    str += "#MEMORY_SIZE_END\n";

    str += "#GLOBAL_VARIABLE_NUM\n";
    str += std::to_string(globalVariableNum) + "\n";
    str += "#GLOBAL_VARIABLE_NUM_END\n";

    str += "#LIST_MEMORY_SIZE\n";
    for (int size : listMemorySize)
    {
        str += std::to_string(size) + "\n";
    }
    str += "#LIST_MEMORY_SIZE_END\n";

    str += "#GLOBAL_LIST_NUM\n";
    str += std::to_string(globalListNum) + "\n";
    str += "#GLOBAL_LIST_NUM_END\n";

    str += "#GLOBAL_VARIABLE_DATA\n";
    for (auto typeInfo : globalVariableTypes)
    {
        if (typeInfo.second.isList)
            str += "LIST\n";
        else
            str += "VAR\n";

        str += typeInfo.first + "\n";

        if (typeInfo.second.isList)
            str += std::to_string(globalListAddresses[typeInfo.first]) + "\n";
        else
            str += std::to_string(globalVariableAddress[typeInfo.first]) + "\n";

        str += (typeInfo.second.isUI ? "1" : "0");
        str += "\n";
        str += std::to_string(typeInfo.second.uiID) + "\n";
    }
    str += "#GLOBAL_VARIABLE_DATA_END\n";

    str += "#END\n";

    return str;
}

std::string Convert::ConvertCode(std::string codeStr)
{
    InitConverter();

    code = SplitCode(codeStr);

    for (int i = 0; i < code.size(); i++)
        printf("#%d: %s\n", i, code[i].c_str());

    for (int codeIndex = 0; codeIndex < code.size(); codeIndex++)
    {
        DeclareConstant(codeIndex);
    }

    ListCppFunction();
    ListFunction();

    for (int funcID = 0; funcID < funcStartIndexes.size(); funcID++)
    {
        ClearLocalVariable();

        if (funcID == 0)
            funcBytecodeStartIndexes.push_back(0);
        else
            funcBytecodeStartIndexes.push_back(bytecodeIndex);

        for (int argIndex = 0; argIndex < funcArgAddresses[funcID].size(); argIndex++)
        {
            AddPushAddressCode(DeclareVariable(funcArgOriginalVariableNames[funcID][argIndex], false), false);
            AddPushGlobalCode(funcArgAddresses[funcID][argIndex]);

            AddCmdCode(SET_VARIABLE, 2);
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
                codeIndex += 2;
        }

        ConvertCodeBlock(codeIndex, funcID);

        AddPush0Code();
        AddCmdCode(RETURN, 0);

        AddCmdCode(END_OF_FUNC, 0);

        memorySize.push_back(variableNum);
        listMemorySize.push_back(listNum);
    }

    bytecode.resize(bytecodeSize);

    Bytecode2String().ShowBytecodeString(bytecode);

    return Code2Str();
}

void Convert::ListFunction()
{
    int codeIndex = 0;

    int funcID = 0;

    funcArgAddresses = std::vector<std::vector<int>>();

    std::unordered_map<std::string, std::string> newVarName;

    defaultFuncNames.clear();
    for (auto func : defaultFuncData)
    {
        funcData newFuncData;
        newFuncData.funcName = func.first;
        newFuncData.argType = func.second.second;

        funcDataMap[func.first] = newFuncData;
        defaultFuncNames.insert(func.first);
    }

    while (codeIndex < code.size())
    {
        if (code[codeIndex] == "func")
        {
            newVarName.clear();

            funcArgAddresses.push_back(std::vector<int>());
            funcArgOriginalVariableNames.push_back(std::vector<std::string>());

            funcStartIndexes.push_back(codeIndex);

            funcData newFuncData;

            newFuncData.funcName = code[codeIndex + 1];

            codeIndex += 3;

            /*
                       v
            func yay ( a : UI , b )
                       ^
            */
            if (code[codeIndex] == ")")
            {
                codeIndex += 2;
            }
            else
            {
                int argNum = 0;

                while (code[codeIndex] != "{")
                {
                    argNum++;

                    std::string name = code[codeIndex];
                    std::string newName = "#" + std::to_string(funcID) + "_" + name;

                    funcArgAddresses[funcID].push_back(DeclareVariable(newName, true));
                    funcArgOriginalVariableNames[funcID].push_back(name);

                    code[codeIndex + 1] = newName;
                    newVarName[name] = newName;

                    if (code[codeIndex + 1] == ":")
                    {
                        std::string argType = code[codeIndex + 2];
                        if (argType == "ui")
                            newFuncData.argType.push_back(ArgType::UI);
                        if (argType == "var")
                            newFuncData.argType.push_back(ArgType::VAR);
                        if (argType == "list")
                            newFuncData.argType.push_back(ArgType::LIST);

                        codeIndex += 4;
                    }
                    else
                    {
                        newFuncData.argType.push_back(ArgType::VALUE);
                        codeIndex += 2;
                    }
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

                codeIndex++;
            }

            if (!checkName(newFuncData.funcName))
            {
                printf("The function %s is already declared\n", newFuncData.funcName.c_str());
                break;
            }

            funcDataMap[newFuncData.funcName] = newFuncData;
            funcIDs[newFuncData.funcName] = funcID;
            isFuncExists[newFuncData.funcName] = true;
            funcID++;
        }
        else if (code[codeIndex] == "var")
        {
            variableTypeInfo typeInfo = {true, false, false, false, false, -1, -1};

            codeIndex += 1;
            while (codeIndex < code.size() && code[codeIndex].size() > 0 && code[codeIndex][0] == '#')
            {
                std::string str = code[codeIndex];

                typeInfo.isCloudVariable |= str == "#cloud";
                typeInfo.isPersistentVariable |= str == "#persistent";
                typeInfo.isUI |= str == "#ui";

                codeIndex += 1;
            }

            std::string varName = code[codeIndex];

            if (!checkName(varName))
            {
                printf("The variable %s is already declared\n", varName.c_str());
            }

            globalVariableNum++;
            globalVariableAddress[varName] = globalVariableNum;

            if (typeInfo.isCloudVariable || typeInfo.isPersistentVariable)
            {
                typeInfo.nameAddress = DeclareString(varName);

                codeIndex += 1;
            }
            else
            {
                codeIndex += 2;

                if (typeInfo.isUI)
                    typeInfo.uiID = (int)strtol(code[codeIndex].c_str(), NULL, 10);

                AddPushAddressCode(globalVariableAddress[varName], true);

                //* Only value
                ConvertValue(codeIndex, true);

                codeIndex += 1;

                AddCmdCode(SET_GLOBAL_VARIABLE, 2);
            }

            globalVariableTypes[varName] = typeInfo;
        }
        else if (code[codeIndex] == "list")
        {
            variableTypeInfo typeInfo = {true, false, false, false, true, -1, -1};

            codeIndex += 1;
            while (codeIndex < code.size() && code[codeIndex].size() > 0 && code[codeIndex][0] == '#')
            {
                std::string str = code[codeIndex];

                typeInfo.isCloudVariable |= str == "#cloud";
                typeInfo.isPersistentVariable |= str == "#persistent";
                typeInfo.isUI |= str == "#ui";

                codeIndex += 1;
            }

            std::string varName = code[codeIndex];

            if (!checkName(varName))
            {
                printf("The variable %s is already declared\n", varName.c_str());
            }

            globalListNum++;
            globalListAddresses[varName] = globalListNum;

            if (typeInfo.isCloudVariable || typeInfo.isPersistentVariable)
            {
                typeInfo.nameAddress = DeclareString(varName);

                codeIndex += 1;
            }

            int address = globalListAddresses[varName];

            AddPushAddressCode(address, true);
            AddCmdCode(INIT_LIST, 1);

            codeIndex += 3;

            //       v
            // a = { 1 , 2 , 8 }
            //       ^

            if (code[codeIndex] == "}")
            {
                codeIndex += 1;
            }
            else
            {
                while (code[codeIndex - 1] != "}")
                {
                    AddPushAddressCode(address, true);

                    //* Only value
                    ConvertValue(codeIndex, true);
                    codeIndex += 2;

                    AddCmdCode(ADD_LIST, 2);
                }
            }

            if (typeInfo.isUI)
            {
                codeIndex += 1;
                std::string uiIDStr = code[codeIndex].substr(1, code[codeIndex].size() - 1);
                typeInfo.uiID = (int)strtol(uiIDStr.c_str(), NULL, 10);
                codeIndex += 1;

                AddPushAddressCode(typeInfo.uiID, true);
                AddPushAddressCode(address, true);
                AddCmdCode(SET_LIST_UI, 2);
            }

            globalVariableTypes[varName] = typeInfo;
        }
        else
        {
            printf("This code is broken #%d\n", codeIndex);
            puts(code[codeIndex].c_str());
            break;
        }
    }
}

void Convert::ListCppFunction()
{
    CppFuncManager cppFuncManager;

    for (int funcID = 0; funcID < cppFuncManager.cppFunc.size(); funcID++)
    {
        auto cppFuncData = cppFuncManager.cppFunc[funcID];

        funcData newFuncData;

        newFuncData.funcName = cppFuncData.funcName;
        newFuncData.argType = cppFuncData.argType;

        cppFuncIDs[newFuncData.funcName] = funcID;
        isCppFuncExists[newFuncData.funcName] = true;
        cppFuncDataMap[newFuncData.funcName] = newFuncData;
    }
}

int Convert::DeclareVariable(const std::string name, const bool isGlobal)
{
    if (!checkName(name))
    {
        printf("Error : The variable %s is already declared\n", name.c_str());
        return -1;
    }

    if (isGlobal)
    {
        variableTypes[name] = {true, false, false, false, false, -1, -1};
        globalVariableTypes[name] = {true, false, false, false, false, -1, -1};

        globalVariableNum++;
        globalVariableAddress[name] = globalVariableNum;

        return globalVariableNum;
    }
    else
    {
        variableTypes[name] = {false, false, false, false, false, -1, -1};

        variableNum++;
        variableAddresses[name] = variableNum;

        return variableNum;
    }
}

int Convert::DeclareList(const std::string name, const bool isGlobal)
{
    if (!checkName(name))
    {
        printf("Error : The variable %s is already declared\n", name.c_str());
        return -1;
    }

    if (isGlobal)
    {
        globalVariableTypes[name] = {true, false, false, false, true, -1, -1};
        variableTypes[name] = {true, false, false, false, true, -1, -1};

        globalListNum += 1;
        globalListAddresses[name] = globalListNum;

        return globalListNum;
    }
    else
    {
        variableTypes[name] = {false, false, false, false, true, -1, -1};

        listNum++;
        listAddresses[name] = listNum;

        return listNum;
    }

    return -1;
}

bool Convert::checkVariableOrFuncName(const std::string name)
{
    return variableAddresses[name] == 0 ||
           listAddresses[name] == 0 ||
           globalVariableAddress[name] == 0 ||
           !isFuncExists[name] ||
           !isCppFuncExists[name] ||
           defaultFuncNames.count(name) == 0;
}

bool Convert::isSymbol(const std::string code)
{
    return symbol.count(code) > 0 || doubleSymbol.count(code) > 0;
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

void Convert::AddPushCode(int address, bool absolute)
{
    AddCode(CODE_BEGIN);
    AddCode(PUSH);
    AddCode(0);
    AddCode(address);
    AddCode(absolute ? 1 : 0);
}

void Convert::AddPushGlobalCode(int address)
{
    AddCode(CODE_BEGIN);
    AddCode(PUSH_GLOBAL_VARIABLE);
    AddCode(0);
    AddCode(address);
    AddCode(1);
}

void Convert::AddPushPersistentCode(int address)
{
    AddCode(CODE_BEGIN);
    AddCode(PUSH_PERSISTENT_VARIABLE);
    AddCode(0);
    AddCode(address);
    AddCode(1);
}

void Convert::AddPushCloudCode(int address)
{
    AddCode(CODE_BEGIN);
    AddCode(PUSH_CLOUD_VARIABLE);
    AddCode(0);
    AddCode(address);
    AddCode(1);
}

void Convert::AddPushAddressCode(int address, bool absolute)
{
    AddCode(CODE_BEGIN);
    AddCode(PUSH_ADDRESS);
    AddCode(0);
    AddCode(address);
    AddCode(absolute ? 1 : 0);
}

void Convert::AddPushTrueCode()
{
    AddPushGlobalCode(1);
}

void Convert::AddPushFalseCode()
{
    AddPushGlobalCode(2);
}

void Convert::AddPush0Code()
{
    AddPushGlobalCode(3);
}

void Convert::AddPush1Code()
{
    AddPushGlobalCode(4);
}

void Convert::InitConverter()
{

    bytecode = std::vector<int>(1000000);
    bytecodeIndex = 0;

    variableInitialValues = std::unordered_map<int, var>();

    variableTypes.clear();
    globalVariableTypes.clear();

    variableAddresses.clear();

    globalVariableNum = 4;

    listNum = 0;
    globalListNum = 0;
    listAddresses.clear();
    globalListAddresses.clear();
}

void Convert::ClearLocalVariable()
{
    variableTypes = globalVariableTypes;
    variableAddresses = globalVariableAddress;
    variableNum = 0;

    listAddresses = globalListAddresses;
    listNum = globalListNum;
}

bool Convert::checkName(const std::string name)
{
    if (isCppFuncExists[name] ||
        isFuncExists[name] ||
        defaultFuncNames.count(name) > 0 ||
        variableAddresses[name] != 0 ||
        listAddresses[name] != 0)
        return false;

    return true;
}

std::vector<Convert::variableData> Convert::getGlobalVariables(const std::string codeStr)
{
    std::vector<std::string> code = SplitCode(codeStr);

    std::vector<variableData> variables = std::vector<variableData>();

    int codeIndex = 0;

    while (codeIndex < code.size())
    {
        if (code[codeIndex] == "func")
        {
            int bracketStack = 1;
            while (codeIndex < code.size() && bracketStack > 0)
            {
                if (code[codeIndex] == "{")
                    bracketStack++;
                if (code[codeIndex] == "}")
                    bracketStack--;

                codeIndex += 1;
            }
        }
        else if (code[codeIndex] == "var" || code[codeIndex] == "list")
        {
            std::string varTypeStr = code[codeIndex];

            codeIndex += 1;
            variableType varType = variableType::normal;
            bool isUI = false;
            while (codeIndex < code.size() && code[codeIndex].size() > 0 && code[codeIndex][0] == '#')
            {
                std::string str = code[codeIndex];

                if (str == "#cloud")
                    varType = variableType::cloud;

                if (str == "#persistent")
                    varType = variableType::persistent;

                if (str == "#ui")
                    isUI = true;

                codeIndex += 1;
            }

            std::string varName = code[codeIndex];

            if (varTypeStr == "var")
            {
                if (varType == variableType::cloud || varType == variableType::persistent)
                {
                    variables.push_back(
                        {varType,
                         varName,
                         ""});

                    codeIndex += 1;
                }
                else
                {
                    codeIndex += 2;

                    std::string value = code[codeIndex];
                    if (value[0] == '"')
                        value = value.substr(1, value.size() - 2);

                    if (!isUI)
                        variables.push_back(
                            {variableType::normal,
                             varName,
                             value});

                    codeIndex += 1;
                }
            }
            else
            {
                if (varType == variableType::cloud || varType == variableType::persistent)
                {
                    codeIndex += 1;
                }
                else
                {
                    codeIndex += 3;

                    //       v
                    // a = { 1 , 2 , 8 }
                    //       ^

                    if (code[codeIndex] == "}")
                    {
                        codeIndex += 1;
                    }
                    else
                    {
                        while (code[codeIndex - 1] != "}")
                        {
                            codeIndex += 2;
                        }
                    }

                    if (isUI)
                    {
                        codeIndex += 1;
                        codeIndex += 1;
                    }
                }
            }
        }
        else
        {
            printf("This code is broken #%d\n", codeIndex);
            return variables;
            break;
        }
    }

    return variables;
}

std::vector<Convert::listData> Convert::getGlobalLists(const std::string codeStr)
{
    std::vector<std::string> code = SplitCode(codeStr);

    std::vector<listData> lists = std::vector<listData>();

    int codeIndex = 0;

    while (codeIndex < code.size())
    {
        if (code[codeIndex] == "func")
        {
            int bracketStack = 1;
            while (codeIndex < code.size() && bracketStack > 0)
            {
                if (code[codeIndex] == "{")
                    bracketStack++;
                if (code[codeIndex] == "}")
                    bracketStack--;

                codeIndex += 1;
            }
        }
        else if (code[codeIndex] == "var" || code[codeIndex] == "list")
        {
            std::string varTypeStr = code[codeIndex];

            codeIndex += 1;
            variableType varType = variableType::normal;
            bool isUI = false;
            while (codeIndex < code.size() && code[codeIndex].size() > 0 && code[codeIndex][0] == '#')
            {
                std::string str = code[codeIndex];

                if (str == "#cloud")
                    varType = variableType::cloud;

                if (str == "#persistent")
                    varType = variableType::persistent;

                if (str == "#ui")
                    isUI = true;

                codeIndex += 1;
            }

            std::string varName = code[codeIndex];

            if (varTypeStr == "var")
            {
                if (varType == variableType::cloud || varType == variableType::persistent)
                {
                    codeIndex += 1;
                }
                else
                {
                    codeIndex += 2;
                    codeIndex += 1;
                }
            }
            else
            {
                if (varType == variableType::cloud || varType == variableType::persistent)
                {
                    lists.push_back(
                        {varType,
                         varName,
                         {},
                         -1});

                    codeIndex += 1;
                }
                else
                {
                    codeIndex += 3;

                    //       v
                    // a = { 1 , 2 , 8 }
                    //       ^

                    std::vector<std::string> value = std::vector<std::string>();
                    if (code[codeIndex] == "}")
                    {
                        codeIndex += 1;
                    }
                    else
                    {
                        while (code[codeIndex - 1] != "}")
                        {
                            std::string element = code[codeIndex];
                            if (element[0] == '"')
                                element = element.substr(1, element.size() - 2);
                            value.push_back(element);
                            codeIndex += 2;
                        }
                    }

                    int uiID = -1;
                    if (isUI)
                    {
                        codeIndex += 1;
                        uiID = (int)strtol(code[codeIndex].c_str(), NULL, 10);
                        codeIndex += 1;
                    }

                    lists.push_back(
                        {variableType::normal,
                         varName,
                         value,
                         uiID});
                }
            }
        }
        else
        {
            printf("This code is broken #%d\n", codeIndex);
            return lists;
        }
    }

    return lists;
}