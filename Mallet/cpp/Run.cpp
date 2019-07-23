//
//  Run.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/06/24.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "Run.hpp"
#include <stdio.h>
#include <vector>

ControlCode getControlCode(var &variable)
{
    if (std::holds_alternative<ControlCode>(variable))
    {
        return std::get<ControlCode>(variable);
    }
    else
    {
        return ControlCode::NONE;
    }

    return ControlCode::NONE;
}

int getIntValue(var &variable)
{
    if (std::holds_alternative<ControlCode>(variable))
    {
        return 0;
    }

    if (std::holds_alternative<int>(variable))
    {
        return std::get<int>(variable);
    }

    if (std::holds_alternative<double>(variable))
    {
        return 0;
    }

    if (std::holds_alternative<bool>(variable))
    {
        return 0;
    }

    if (std::holds_alternative<std::string>(variable))
    {
        return 0;
    }

    return 0;
}

double getNumberValue(var &variable)
{
    if (std::holds_alternative<ControlCode>(variable))
    {
        return 0;
    }

    if (std::holds_alternative<int>(variable))
    {
        return 0;
    }

    if (std::holds_alternative<double>(variable))
    {
        return std::get<double>(variable);
    }

    if (std::holds_alternative<bool>(variable))
    {
        return (double)std::get<bool>(variable);
    }

    if (std::holds_alternative<std::string>(variable))
    {
        return std::stod(std::get<std::string>(variable));
    }

    return 0;
}

bool getBoolValue(var &variable)
{
    if (std::holds_alternative<ControlCode>(variable))
    {
        return 0;
    }

    if (std::holds_alternative<int>(variable))
    {
        return 0;
    }

    if (std::holds_alternative<double>(variable))
    {
        return std::get<double>(variable) > 0;
    }

    if (std::holds_alternative<bool>(variable))
    {
        return std::get<bool>(variable);
    }

    if (std::holds_alternative<std::string>(variable))
    {
        return false;
    }

    return false;
}

std::string getStringValue(var &variable)
{
    if (std::holds_alternative<ControlCode>(variable))
    {
        return 0;
    }

    if (std::holds_alternative<int>(variable))
    {
        return "";
    }

    if (std::holds_alternative<double>(variable))
    {
        return std::to_string(std::get<double>(variable));
    }

    if (std::holds_alternative<bool>(variable))
    {
        return std::get<bool>(variable) ? "true" : "false";
    }

    if (std::holds_alternative<std::string>(variable))
    {
        return std::get<std::string>(variable);
    }

    return "";
}

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
    int funcType = funcTypes[funcID];

    int stackIndex = -1;
    constexpr int stackSize = 1000000;
    std::vector<var> stack(stackSize);

    var returnStackData;

    std::vector<var> variable(100000);

    int reservedMemorySize = globalVariableNum;

    for (int i = 0; i < variableInitialValues.size(); i++)
        variable[i] = variableInitialValues[i];

    variable[1] = true;
    variable[2] = false;
    variable[3] = (double)0;
    variable[4] = (double)1;

    constexpr int pushCodeSize = 5;
    constexpr int defaultCodeSize = 3;

    int argIndex = 0;

    int currentFuncID = funcID;

    for (var arg : args)
    {
        variable[argAddresses[funcID][argIndex]] = arg;

        argIndex++;
    }

    int bytecodeIndex = funcStartIndexes[funcID];
    int bytecodeSize = bytecode.size();

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

        if (cmd == PUSH || cmd == PUSH_ADDRESS)
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
            else
                stack[stackIndex] = address;

            bytecodeIndex += pushCodeSize;
        }
        else
        {
            //TODO: String + String

            bool jumped = false;

            if (cmd >= 1024)
            {
                double firstValue = getNumberValue(*topStackData[0]);
                double secondValue;

                if (cmd == NOT)
                    secondValue = 0;
                else
                    secondValue = getNumberValue(*topStackData[1]);

                double result = 0;

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
                    printf("%.10g\n", getNumberValue(*topStackData[0]));
                    //printf("%s\n", getStringValue(*topStackData[0]).c_str());

                    break;

                case PRINT_STRING:
                    printf("%s\n", getStringValue(*topStackData[0]).c_str());

                    break;

                case SET_VARIABLE:
                    variable[getIntValue(*topStackData[0])] = *topStackData[1];

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

void Run::InitRunner(Run &runner)
{
    runner.globalVariable = std::vector<var>(100000);

    runner.variableInitialValues = std::vector<var>(100000);
}
