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

        if (variableAddresses[varName] == 0)
        {
            globalVariableNum++;
            globalVariableAddress[varName] = globalVariableNum;

            globalVariableType[varName] = STRING_TYPE;

            isGlobalVariable[varName] = true;

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

        if (globalVariableAddress[varName] == 0)
        {
            globalVariableNum++;
            globalVariableAddress[varName] = globalVariableNum;

            globalVariableType[varName] = NUMBER_TYPE;

            isGlobalVariable[varName] = true;

            variableInitialValues[globalVariableNum] = std::stod(code[firstCodeIndex]);
        }

        code[firstCodeIndex] = varName;
    }
}

int Convert::ConvertValue(const int firstCodeIndex, const bool convert)
{
    int type = -1;

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

        int address;

        if (isGlobalVariable[code[firstCodeIndex]])
        {
            address = globalVariableAddress[code[firstCodeIndex]];
        }
        else
        {
            if (variableAddresses[code[firstCodeIndex]] == 0)
                printf("The variable %s is not declared!\n", code[firstCodeIndex].c_str());
            else
                address = variableAddresses[code[firstCodeIndex]];
        }

        if (convert)
            AddPushCode(address, isGlobalVariable[code[firstCodeIndex]]);
    }

    //! Delete
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

    int argNum = 0;

    while (code[codeIndex] != ")")
    {
        argNum++;

        formulaData argData;
        argData = ConvertFormula(codeIndex, 0, false);

        codeSize += argData.codeSize + 1;

        codeIndex += argData.codeSize;

        if (code[codeIndex] == ",")
            codeIndex++;
    }

    thisFuncData.argNum = argNum;

    if (!isFuncExists[thisFuncData] && !isCppFuncExists[thisFuncData])
    {
        printf("Error : The function %s is not declared\n", thisFuncData.funcName.c_str());

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
                AddPushAddressCode(funcArgAddresses[funcID][argIndex], true);

            ConvertFormula(codeIndex, 0, true);

            //TODO: Type
            if (!isCppFunc)
                AddCmdCode(SET_VARIABLE, 2);

            codeSize += argData.codeSize + 1;

            codeIndex += argData.codeSize;

            if (code[codeIndex] == ",")
                codeIndex++;

            argIndex++;
        }

        int backIndex = bytecodeIndex + 3;
        if (!isCppFunc)
            AddPushAddressCode(-1, true);

        AddPushAddressCode(funcID, true);

        if (isCppFunc)
            AddCmdCode(CALL_CPP_FUNC, 1 + thisFuncData.argNum);
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

            codeSize = 1 + ConvertFormula(codeIndex + 1, 0, true).codeSize;

            AddCmdCode(RETURN, 0);
        }
        else if (token == "print")
        {
            codeSize = 3 + ConvertFormula(codeIndex + 2, 0, true).codeSize;

            AddCmdCode(PRINT_NUMBER, 1);
        }
        else if (token == "var")
        {
            std::string varName = code[codeIndex + 1];

            if (variableType[varName] != 0 || funcNames.count(varName) > 0)
            {
                //! printf("The variable %s is already declared\n", varName.c_str());
            }

            variableType[varName] = VARIABLE;
            variableNum++;
            variableAddresses[varName] = variableNum;

            codeSize = 1;
        }
        else if (token == "while")
        {
            int firstIndex = bytecodeIndex;

            codeSize = 3 + ConvertFormula(codeIndex + 2, 0, true).codeSize;

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
            codeSize = 3 + ConvertFormula(codeIndex + 2, 0, true).codeSize;

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
            codeSize = 3 + ConvertFormula(codeIndex + 2, 0, true).codeSize;
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
        else if (variableType[code[codeIndex]] != 0)
        {
            int addressType = -1;
            int type = variableType[code[codeIndex]];
            int address = variableAddresses[code[codeIndex]];

            AddPushAddressCode(address, isGlobalVariable[code[codeIndex]]);

            codeSize = 2 + ConvertFormula(codeIndex + 2, 0, true).codeSize;

            AddCmdCode(SET_VARIABLE, 2);
        }
        else if (funcNames.count(token) > 0 || cppFuncNames.count(token) > 0)
        {
            codeSize = ConvertFunc(codeIndex, true);
        }
        else
        {
            printf("%s is undefined #%d\n", code[codeIndex].c_str(), codeIndex);
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
        //TODO: acc
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
        str += "\"" + std::get<std::string>(value) + "\"";
    }

    str += "\n";

    return str;
}

std::string Convert::Code2Str()
{
    std::string str = "#START\n\n";

    str += "#CODE\n";
    for (int code : bytecode)
    {
        str += std::to_string(code) + "\n";
    }
    str += "#CODE_END\n";

    str += "\n#INITIAL_VALUE\n";
    for (auto value : variableInitialValues)
    {
        str += std::to_string(value.first) + "\n";
        str += getInitialValueStr(value.second);
    }
    str += "#INITIAL_VALUE_END\n";

    str += "\n#FUNC_START_INDEXES\n";
    for (int index : funcBytecodeStartIndexes)
    {
        str += std::to_string(index) + "\n";
    }
    str += "#FUNC_START_INDEXES_END\n";

    str += "\n#ARG_ADDRESSES\n";
    for (int funcID = 0; funcID < funcArgAddresses.size(); funcID++)
    {
        str += std::to_string(funcArgAddresses[funcID].size()) + "\n";

        for (int address : funcArgAddresses[funcID])
        {
            str += std::to_string(address) + "\n";
        }

        str += "\n";
    }
    str += "#ARG_ADDRESSES_END\n";

    str += "\n#MEMORY_SIZE\n";
    for (int size : memorySize)
    {
        str += std::to_string(size) + "\n";
    }
    str += "#MEMORY_SIZE_END\n";

    str += "\n#GLOBAL_VARIABLE_NUM\n";
    str += std::to_string(globalVariableNum) + "\n";
    str += "#GLOBAL_VARIABLE_NUM_END\n";

    str += "\n#END\n";

    return str;
}

std::string Convert::ConvertCode(std::string codeStr)
{
    InitConverter();

    code = SplitCode(codeStr);

    ListFunction();
    ListCppFunction();

    for (int codeIndex = 0; codeIndex < code.size(); codeIndex++)
    {
        DeclareConstant(codeIndex);
    }

    for (int funcID = 0; funcID < funcStartIndexes.size(); funcID++)
    {
        ClearLocalVariable();

        funcBytecodeStartIndexes.push_back(bytecodeIndex);

        for (int argIndex = 0; argIndex < funcArgAddresses[funcID].size(); argIndex++)
        {
            int type = funcArgTypes[funcID][argIndex];
            AddPushAddressCode(DeclareVariable(funcArgOriginalVariableNames[funcID][argIndex], false), false);
            AddPushCode(funcArgAddresses[funcID][argIndex], true);

            //TODO:
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

        AddCmdCode(RETURN, 0);

        AddCmdCode(END_OF_FUNC, 0);

        memorySize.push_back(variableNum);
    }

    bytecode.resize(bytecodeSize);

    return Code2Str();
}

void Convert::ListFunction()
{
    int codeIndex = 0;

    int funcID = 0;

    funcArgAddresses = std::vector<std::vector<int>>();

    std::unordered_map<std::string, std::string> newVarName;

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

                    isGlobalVariable[newName] = true;

                    code[codeIndex + 1] = newName;
                    newVarName[name] = newName;

                    codeIndex += 2;
                }

                newFuncData.argNum = argNum;

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

            if (isFuncExists[newFuncData] || isCppFuncExists[newFuncData])
            {
                //TODO: show detail
                printf("The function %s is already declared\n", newFuncData.funcName.c_str());
                break;
            }

            funcNames.insert(newFuncData.funcName);
            funcIDs[newFuncData] = funcID;
            isFuncExists[newFuncData] = true;
            funcID++;
        }
        else
        {
            printf("This code is broken #%d\n", codeIndex);
            break;
        }
    }
}

void Convert::ListCppFunction()
{
    CppFuncManager cppFuncManager;

    for (int funcID = 0; funcID < cppFuncManager.cppFunc.size(); funcID++)
    {
        cppFuncNames.insert(cppFuncManager.cppFunc[funcID].funcName);

        funcData newFuncData;

        newFuncData.funcName = cppFuncManager.cppFunc[funcID].funcName;
        newFuncData.argNum = cppFuncManager.cppFunc[funcID].argNum;

        cppFuncIDs[newFuncData] = funcID;
        isCppFuncExists[newFuncData] = true;
    }
}

int Convert::DeclareVariable(const std::string name, const bool isGlobal)
{
    if (variableType[name] > 0)
    {
        printf("Error : The variable %s is already declared\n", name.c_str());
        return -1;
    }

    if (isGlobal)
    {
        globalVariableType[name] = GLOBAL_VARIABLE;

        globalVariableNum++;
        globalVariableAddress[name] = globalVariableNum;

        return globalVariableNum;
    }
    else
    {
        variableType[name] = VARIABLE;

        variableNum++;
        variableAddresses[name] = variableNum;

        return variableNum;
    }

    return -1;
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

void Convert::AddPushCode(int address, bool absolute)
{
    AddCode(CODE_BEGIN);
    AddCode(PUSH);
    AddCode(0);
    AddCode(address);
    AddCode(absolute ? 1 : 0);
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
    AddPushCode(1, true);
}

void Convert::AddPushFalseCode()
{
    AddPushCode(2, true);
}

void Convert::AddPush0Code()
{
    AddPushCode(3, true);
}

void Convert::AddPush1Code()
{
    AddPushCode(4, true);
}

void Convert::InitConverter()
{

    bytecode = std::vector<int>(1000000);
    bytecodeIndex = 0;

    variableInitialValues = std::unordered_map<int, var>();

    variableType.clear();
    globalVariableType.clear();

    variableAddresses.clear();

    globalVariableNum = 4;
}

void Convert::ClearLocalVariable()
{
    variableType = globalVariableType;

    variableAddresses = globalVariableAddress;

    variableNum = 0;
}
