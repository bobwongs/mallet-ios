//
//  run.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/06/24.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "run.hpp"

var getTopStackData(std::vector<var> &stack, int &stackIndex, bool &error)
{
    if (stackIndex < 0)
    {
        printf("Error : There is nothing in the stack\n");
        error = true;

        var errorStackData;
        return errorStackData;
    }

    stackIndex--;
    return stack[stackIndex + 1];
}

var Run::RunCode(int funcID, std::vector<var> args)
{
    //int funcType = funcTypes[funcID];

    int stackIndex = -1;
    constexpr int stackSize = 1000000;
    std::vector<var> stack(stackSize);

    var returnStackData;

    std::vector<var> variable(100000);

    int reservedMemorySize = 0; //globalVariableNum;

    std::vector<list> lists(100000);

    int argIndex = 0;

    int currentFuncID = funcID;

    for (var arg : args)
    {
        globalVariable[argAddresses[funcID][argIndex]] = arg;

        argIndex++;
    }

    int bytecodeIndex = funcStartIndexes[funcID];
    int bytecodeSize = (int)bytecode.size();

    bool error = false;

    std::vector<var *> topStackData(100);

    var newStackData;

    std::vector<var> callFuncArg;

    var newArg;
    var returnValue;

    bool endProcess = false;

    stackIndex++;
    stack[stackIndex] = bytecodeSize;
    stackIndex++;
    stack[stackIndex] = -1;
    stackIndex++;
    stack[stackIndex] = ControlCode::END_OF_FUNC;

    while (bytecodeIndex < bytecodeSize)
    {
        if (bytecode[bytecodeIndex] != CODE_BEGIN || bytecodeIndex + 2 >= bytecodeSize)
        {
            error = true;
            printf("Error : bytecode is broken! #%d\n", bytecodeIndex);
            break;
        }

        int cmd = bytecode[bytecodeIndex + 1];
        int argNum = bytecode[bytecodeIndex + 2];

        for (int i = 0; i < argNum; i++)
        {
            topStackData[argNum - 1 - i] = &stack[stackIndex];
            stackIndex--;
        }

        if (error)
        {
            break;
        }

        if (cmd == PUSH || cmd == PUSH_ADDRESS || cmd == PUSH_GLOBAL_VARIABLE || cmd == PUSH_PERSISTENT_VARIABLE || cmd == PUSH_CLOUD_VARIABLE)
        {
            if (stackIndex >= stackSize)
            {
                printf("Error : Stack overflow #%d\n", bytecodeIndex);
                error = true;
                break;
            }

            if (bytecodeIndex + pushCodeSize - 1 >= bytecodeSize)
            {
                error = true;
                printf("Error : bytecode is broken! #%d\n", bytecodeIndex);
                break;
            }

            int address = bytecode[bytecodeIndex + 3];
            bool absolute = bytecode[bytecodeIndex + 4] > 0;

            if (!absolute)
            {
                address += reservedMemorySize;
            }

            stackIndex++;

            if (cmd == PUSH)
                stack[stackIndex] = variable[address];
            else if (cmd == PUSH_ADDRESS)
                stack[stackIndex] = address;
            else if (cmd == PUSH_GLOBAL_VARIABLE)
                stack[stackIndex] = globalVariable[address];
            else if (cmd == PUSH_PERSISTENT_VARIABLE)
            {
                std::string varName = getStringValue(globalVariable[address]);
                stack[stackIndex] = persistentVariables[varName];
            }
            else if (cmd == PUSH_CLOUD_VARIABLE)
            {
                std::string varName = getStringValue(globalVariable[address]);
                stack[stackIndex] = cloudVariables[varName];
            }

            bytecodeIndex += pushCodeSize;
        }
        else
        {
            bool jumped = false;

            if (OPERATOR_BEGIN < cmd && cmd < OPERATOR_END)
            {
                var result;

                if (cmd == CONNECT_STRING)
                {
                    result = getOutValue(*topStackData[0]) + getOutValue(*topStackData[1]);
                }
                else
                {
                    double firstValue = getNumberValue(*topStackData[0]);
                    double secondValue;

                    if (cmd == NOT)
                        secondValue = 0;
                    else
                        secondValue = getNumberValue(*topStackData[1]);

                    switch (cmd)
                    {
                    case ADD:
                        result = firstValue + secondValue;

                        break;

                    case SUB:
                        result = firstValue - secondValue;

                        break;

                    case MUL:
                        result = firstValue * secondValue;

                        break;

                    case DIV:
                        if (secondValue == 0)
                            result = 0;
                        else
                            result = firstValue / secondValue;

                        break;

                    case MOD:
                        if ((int)secondValue == 0)
                            result = 0;
                        else
                            result = (int)firstValue % (int)secondValue;

                        break;

                    case EQUAL:
                        result = firstValue == secondValue ? 1 : 0;

                        break;

                    case NOT_EQUAL:
                        result = firstValue != secondValue ? 1 : 0;

                        break;

                    case GREATER_THAN:
                        result = firstValue > secondValue ? 1 : 0;

                        break;

                    case LESS_THAN:
                        result = firstValue < secondValue ? 1 : 0;

                        break;

                    case GREATER_THAN_OR_EQUAL:
                        result = firstValue >= secondValue ? 1 : 0;

                        break;

                    case LESS_THAN_OR_EQUAL:
                        result = firstValue <= secondValue ? 1 : 0;

                        break;

                    case AND:
                        result = (firstValue > 0) && (secondValue > 0) ? 1 : 0;

                        break;

                    case OR:
                        result = (firstValue > 0) || (secondValue > 0) ? 1 : 0;
                        break;

                    case NOT:
                        result = (firstValue <= 0) ? 1 : 0;

                        break;

                    default:
                        printf("Error : The operator %d is undefined #%d\n", cmd, bytecodeIndex);
                        error = true;

                        break;
                    }
                }

                if (stackIndex >= stackSize)
                {
                    printf("Error : Stack overflow #%d\n", bytecodeIndex);
                    error = true;
                    break;
                }

                stackIndex++;
                stack[stackIndex] = result;
            }
            else
            {
                int callFuncID;

                switch (cmd)
                {
                case PRINT_NUMBER:
                    //printf("%.10g\n", getNumberValue(*topStackData[0]));
                    //printf("%s\n", getStringValue(*topStackData[0]).c_str());
                    printf("%s\n", getOutValue(*topStackData[0]).c_str());

                    break;

                case PRINT_STRING:
                    printf("%s\n", getStringValue(*topStackData[0]).c_str());

                    break;

                case SET_VARIABLE:
                    variable[getIntValue(*topStackData[0])] = *topStackData[1];

                    break;

                case SET_GLOBAL_VARIABLE:
                    globalVariable[getIntValue(*topStackData[0])] = *topStackData[1];

                    break;

                case SET_PERSISTENT_VARIABLE:
                {
                    int address = getIntValue(*topStackData[0]);
                    std::string varName = getStringValue(globalVariable[address]);
                    std::string value = getOutValue(*topStackData[1]);
#if defined(DEBUG)
                    setAppVariable(varName, value);
#endif
                    persistentVariables[varName] = value;
                }
                break;

                case SET_CLOUD_VARIABLE:
                {
                    int address = getIntValue(*topStackData[0]);
                    std::string varName = getStringValue(globalVariable[address]);
                    std::string value = getOutValue(*topStackData[1]);
#if defined(DEBUG)
                    setCloudVariable(varName, value);
#endif
                }
                break;

                case INIT_LIST:
                    lists[getIntValue(*topStackData[0])].clear();

                    break;

                case ADD_LIST:
                    lists[getIntValue(*topStackData[0])].push_back(*topStackData[1]);

                    break;

                case INSERT_LIST:
                {
                    int listAddress = getIntValue(*topStackData[0]);
                    int elementAddress = getIntValue(*topStackData[1]);

                    if (lists[listAddress].size() <= elementAddress)
                    {
                        lists[listAddress].push_back(*topStackData[2]);
                    }
                    else
                    {
                        lists[listAddress].insert(lists[listAddress].begin() + elementAddress, *topStackData[2]);
                    }
                }

                break;

                case REMOVE_LIST:
                {
                    int listAddress = getIntValue(*topStackData[0]);
                    int elementAddress = getIntValue(*topStackData[1]);

                    if (lists[listAddress].size() - 1 == elementAddress)
                    {
                        lists[listAddress].pop_back();
                    }
                    else if (lists[listAddress].size() - 1 > elementAddress)
                    {
                        lists[listAddress].erase(lists[listAddress].begin() + elementAddress);
                    }
                }

                break;

                case GET_LIST:
                {
                    int listAddress = getIntValue(*topStackData[0]);
                    int elementAddress = getIntValue(*topStackData[1]);

                    stackIndex++;

                    if (lists[listAddress].size() <= elementAddress)
                    {
                        stack[stackIndex] = 0;
                    }
                    else
                    {
                        stack[stackIndex] = lists[listAddress][elementAddress];
                    }
                }

                break;

                case GET_LIST_SIZE:

                    stackIndex++;

                    stack[stackIndex] = (int)lists[getIntValue(*topStackData[0])].size();

                    break;

                case SET_PERSISTENT_LIST:
                {
                    std::vector<var> list = globalList[getIntValue(*topStackData[0])];
                    int address = getIntValue(*topStackData[1]);
                    std::string varName = getStringValue(globalVariable[address]);

                    //TODO:
                }
                break;

                case SET_CLOUD_LIST:
                {
                    std::vector<var> list = globalList[getIntValue(*topStackData[0])];
                    int address = getIntValue(*topStackData[1]);
                    std::string varName = getStringValue(globalVariable[address]);

                    //TODO:
                }
                break;

                case JUMP:
                    if (getBoolValue(*topStackData[0]))
                    {
                        bytecodeIndex = getIntValue(*topStackData[1]);
                        jumped = true;
                    }

                    break;

                case CALL_MALLET_FUNC:

                    reservedMemorySize += memorySize[currentFuncID];

                    callFuncID = getIntValue(*topStackData[argNum - 1]);

                    stackIndex++;
                    stack[stackIndex] = currentFuncID;

                    stackIndex++;
                    stack[stackIndex] = ControlCode::END_OF_FUNC;

                    bytecodeIndex = funcStartIndexes[callFuncID];
                    jumped = true;

                    currentFuncID = callFuncID;

                    break;

                case CALL_CPP_FUNC:

                    callFuncID = getIntValue(*topStackData[argNum - 1]);

                    callFuncArg = std::vector<var>(argNum - 1);

                    for (int i = 0; i < argNum - 1; i++)
                    {
                        callFuncArg[i] = *topStackData[i];
                    }

                    returnValue = CallCppFunc(callFuncID, callFuncArg);

                    //TODO: void

                    stackIndex++;
                    stack[stackIndex] = returnValue;

                    break;

                case RETURN:
                    newStackData = stack[stackIndex];

                    while (stackIndex >= 0 && getControlCode(stack[stackIndex]) != ControlCode::END_OF_FUNC)
                        stackIndex--;

                    stackIndex--;

                    currentFuncID = getIntValue(stack[stackIndex]);

                    //                    printf("%d\n", currentFuncID);

                    if (currentFuncID == -1)
                    {
                        bytecodeIndex = bytecodeSize;
                        jumped = true;
                        break;
                    }

                    stackIndex--;
                    bytecodeIndex = getIntValue(stack[stackIndex]);
                    jumped = true;

                    reservedMemorySize -= memorySize[currentFuncID];

                    stack[stackIndex] = newStackData;

                    break;

                case END_OF_FUNC:
                    endProcess = true;
                    break;

                default:
                    printf("Error : %d is undefined #%d\n", cmd, bytecodeIndex);
                    error = true;
                    break;
                }
            }

            if (!jumped)
                bytecodeIndex += defaultCodeSize;
        }

        if (endProcess)
            break;

        if (error)
            break;

        if (terminate)
            return -1;
    }

    if (stackIndex < 0)
    {
        printf("Error : There is nothing in the stack\n");

        error = true;

        return returnStackData;
    }
    else
    {
        returnStackData = stack[stackIndex];
        stackIndex--;
    }

    if (error)
    {
        printf("Process finished with some errors\n");
    }
    else
    {
        //printf("Process finished succsessfully\n");
    }

    return returnStackData;
}

var Run::CallCppFunc(int funcID, std::vector<var> &args)
{
    return (cppFuncManager.cppFunc[funcID].func)(args);
}

void Run::InitRunner(std::string codeDataStr, std::map<std::string, std::string> variables)
{
    globalVariable = std::vector<var>(100000);

    variableInitialValues = std::vector<var>(100000);
    bytecode.clear();
    funcStartIndexes.clear();
    argAddresses.clear();
    memorySize.clear();
    globalVariableNum = 0;

    std::vector<std::string> codeData;
    int index = 0;
    while (index < codeDataStr.size())
    {
        std::string str = "";
        while (index < codeDataStr.size() && codeDataStr[index] != '\n')
        {
            str += codeDataStr[index];
            index++;
        }

        codeData.push_back(str);

        index++;
    }

    if (codeData[0] != "#START" || codeData[codeData.size() - 1] != "#END")
    {
        printf("failed\n");
        return;
    }

    index = 1;
    while (codeData[index] != "#END")
    {
        std::string type = codeData[index];
        std::string endLabel = type + "_END";

        index++;

        if (type == "#CODE")
        {
            while (index < codeData.size() && codeData[index] != endLabel)
            {
                bytecode.push_back((int)strtol(codeData[index].c_str(), NULL, 10));
                index++;
            }

            index++;
        }
        else if (type == "#INITIAL_VALUE")
        {
            while (index < codeData.size() && codeData[index] != endLabel)
            {
                int varIndex = (int)strtol(codeData[index].c_str(), NULL, 10);
                std::string varType = codeData[index + 1];
                var value;

                if (varType == "CONTROL_CODE")
                {
                    value = (ControlCode)strtol(codeData[index + 2].c_str(), NULL, 10);
                }
                else if (varType == "INT")
                {
                    value = (int)strtol(codeData[index + 2].c_str(), NULL, 10);
                }
                else if (varType == "NUMBER")
                {
                    value = strtod(codeData[index + 2].c_str(), NULL);
                }
                else if (varType == "BOOL")
                {
                    value = codeData[index + 2] == "1";
                }
                else if (varType == "STRING")
                {
                    value = codeData[index + 2];
                }
                else
                {
                    printf("failed\n");
                    puts(varType.c_str());
                    bytecode.clear();
                    return;
                }

                variableInitialValues[varIndex] = value;

                index += 3;
            }

            index++;
        }
        else if (type == "#FUNC_START_INDEXES")
        {
            while (index < codeData.size() && codeData[index] != endLabel)
            {
                funcStartIndexes.push_back((int)strtol(codeData[index].c_str(), NULL, 10));
                index++;
            }

            index++;
        }
        else if (type == "#ARG_ADDRESSES")
        {
            int funcID = 0;
            while (codeData[index] != endLabel)
            {
                argAddresses.push_back(std::vector<int>());
                int argNum = (int)strtol(codeData[index].c_str(), NULL, 10);

                index++;

                for (int i = 0; i < argNum; i++)
                {
                    argAddresses[funcID].push_back((int)strtol(codeData[index].c_str(), NULL, 10));
                    index++;
                }

                funcID++;
            }

            index++;
        }
        else if (type == "#MEMORY_SIZE")
        {
            while (index < codeData.size() && codeData[index] != endLabel)
            {
                memorySize.push_back((int)strtol(codeData[index].c_str(), NULL, 10));
                index++;
            }

            index++;
        }
        else if (type == "#GLOBAL_VARIABLE_NUM")
        {
            globalVariableNum = (int)strtol(codeData[index].c_str(), NULL, 10);
            index += 2;
        }
        else if (type == "#LIST_MEMORY_SIZE")
        {
            while (index < codeData.size() && codeData[index] != endLabel)
            {
                listMemorySize.push_back((int)strtol(codeData[index].c_str(), NULL, 10));
                index++;
            }

            index++;
        }
        else if (type == "#GLOBAL_LIST_NUM")
        {
            globalListNum = (int)strtol(codeData[index].c_str(), NULL, 10);
            index += 2;
        }
        else
        {
            puts(codeData[index].c_str());
            printf("failed\n");
            bytecode.clear();
            return;
        }
    }

    for (int i = 0; i < variableInitialValues.size(); i++)
        globalVariable[i] = variableInitialValues[i];

    globalVariable[1] = true;
    globalVariable[2] = false;
    globalVariable[3] = (double)0;
    globalVariable[4] = (double)1;

    globalList = std::vector<list>(globalListNum + 10);

    cloudVariables = std::map<std::string, std::string>();

    persistentVariables = std::map<std::string, std::string>();

    for (auto variable : variables)
    {
        persistentVariables[variable.first] = variable.second;
    }

    terminate = false;

    RunCode(0, std::vector<var>(0));
}

bool Run::UpdateCloudVariable(std::string varName, std::string value)
{
    if (cloudVariables[varName] == value)
        return false;

    cloudVariables[varName] = value;
    return true;
}

void Run::Terminate()
{
    terminate = true;
}

Run::Run()
{
    cppFuncManager = CppFuncManager();
}
