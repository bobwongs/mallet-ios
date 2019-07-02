//
//  Runner2.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/06/24.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "Runner2.hpp"
#include <stdio.h>
#include <vector>
#include <array>

Runner2::stackData getTopStackData(std::vector<Runner2::stackData> &stack, int &stackIndex, bool &error)
{
    if (stackIndex < 0)
    {
        printf("Error : There is nothing in the stack\n");
        error = true;

        Runner2::stackData errorStackData;
        errorStackData.type = CmdID::Error;
        return errorStackData;
    }

    stackIndex--;
    return stack[stackIndex + 1];
}

Runner2::stackData Runner2::RunCode(int funcID, std::vector<stackData> arg, Runner2 &runner)
{
    std::vector<int> bytecode = runner.bytecodes[funcID];

    int stackIndex = -1;
    const int stackSize = 10000;
    std::vector<stackData> stack(stackSize);

    stackData returnStackData;

    std::vector<double> numberVariable(10000, 0);
    std::vector<std::string> stringVariable(10000, "");
    std::vector<bool> boolVariable(10000, false);

    std::vector<double> numberStack(10000, 0);
    std::vector<std::string> stringStack(10000, "");
    std::vector<bool> boolStack(10000, false);
    int numberStackIndex = -1;
    int stringStackIndex = -1;
    int boolStackIndex = -1;

    constexpr int pushCodeSize = 5;
    constexpr int defaultCodeSize = 3;

    for (stackData i : arg)
    {
        stackIndex++;
        stack[stackIndex] = i;
    }

    for (int i = 0; i < runner.numberVariableInitialValues[funcID].size(); i++)
        numberVariable[i] = runner.numberVariableInitialValues[funcID][i];
    for (int i = 0; i < runner.stringVariableInitialValues[funcID].size(); i++)
        stringVariable[i] = runner.stringVariableInitialValues[funcID][i];
    for (int i = 0; i < runner.boolVariableInitialValues[funcID].size(); i++)
        boolVariable[i] = runner.boolVariableInitialValues[funcID][i];

    boolVariable[1] = true;
    boolVariable[2] = false;

    int bytecodeIndex = 0;

    bool error = false;

    std::vector<stackData *> topStackData(100);

    stackData newStackData;

    std::vector<stackData> callFuncArg;

    int bytecodeSize = bytecode.size();

    while (bytecodeIndex < bytecodeSize)
    {
        if (bytecode[bytecodeIndex] != CmdID::CodeBegin || bytecodeIndex + 2 >= bytecodeSize)
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

        if (cmd == CmdID::Push)
        {
            if (stackIndex >= stackSize)
            {
                printf("Error : Stack overflow #%d\n", bytecodeIndex);
                error = true;
                break;
            }

            if (bytecodeIndex + 4 >= bytecodeSize)
            {
                error = true;
                printf("Error : bytecode is broken! #%d\n", bytecodeIndex);
                break;
            }

            int type = bytecode[bytecodeIndex + 3];
            int address = bytecode[bytecodeIndex + 4];

            stackIndex++;

            stack[stackIndex].type = type;
            stack[stackIndex].address = address;

            bytecodeIndex += pushCodeSize;
        }
        else
        {
            bool jumped = false;

            if (cmd / 10000 == 4)
            {
                double firstValue;
                double secondValue;

                int type = topStackData[0]->type;
                int address = topStackData[0]->address;

                if (type == CmdID::NumberType)
                {
                    firstValue = numberVariable[address];
                }
                else if (type == CmdID::BoolType)
                {
                    firstValue = boolVariable[address] ? 1 : 0;
                }
                else if (type == CmdID::NumberTmpType)
                {
                    firstValue = numberStack[numberStackIndex];
                    numberStackIndex--;
                }
                else if (type == CmdID::BoolTmpType)
                {
                    firstValue = boolStack[boolStackIndex];
                    boolStackIndex--;
                }

                if (cmd == CmdID::Not)
                {
                    secondValue = 0;
                }
                else
                {
                    int type = topStackData[1]->type;
                    int address = topStackData[1]->address;

                    if (type == CmdID::NumberType)
                    {
                        secondValue = numberVariable[address];
                    }
                    else if (type == CmdID::BoolType)
                    {
                        secondValue = boolVariable[address] ? 1 : 0;
                    }
                    else if (type == CmdID::NumberTmpType)
                    {
                        secondValue = numberStack[numberStackIndex];
                        numberStackIndex--;
                    }
                    else if (type == CmdID::BoolTmpType)
                    {
                        secondValue = boolStack[boolStackIndex];
                        boolStackIndex--;
                    }
                }

                double result = 0;
                int resultType;

                switch (cmd)
                {
                case CmdID::Add:
                    result = firstValue + secondValue;
                    resultType = CmdID::NumberTmpType;

                    break;

                case CmdID::Sub:
                    result = firstValue - secondValue;
                    resultType = CmdID::NumberTmpType;

                    break;

                case CmdID::Mul:
                    result = firstValue * secondValue;
                    resultType = CmdID::NumberTmpType;

                    break;

                case CmdID::Div:
                    if (secondValue == 0)
                        result = 0;
                    else
                        result = firstValue / secondValue;
                    resultType = CmdID::NumberTmpType;

                    break;

                case CmdID::Mod:
                    if ((int)secondValue == 0)
                        result = 0;
                    else
                        result = (int)firstValue % (int)secondValue;
                    resultType = CmdID::NumberTmpType;

                    break;

                case CmdID::Equal:
                    result = firstValue == secondValue ? 1 : 0;
                    resultType = CmdID::BoolTmpType;

                    break;

                case CmdID::NotEqual:
                    result = firstValue != secondValue ? 1 : 0;
                    resultType = CmdID::BoolTmpType;

                    break;

                case CmdID::GreaterThan:
                    result = firstValue > secondValue ? 1 : 0;
                    resultType = CmdID::BoolTmpType;

                    break;

                case CmdID::LessThan:
                    result = firstValue < secondValue ? 1 : 0;
                    resultType = CmdID::BoolTmpType;

                    break;

                case CmdID::GreaterThanOrEqual:
                    result = firstValue >= secondValue ? 1 : 0;
                    resultType = CmdID::BoolTmpType;

                    break;

                case CmdID::LessThanOrEqual:
                    result = firstValue <= secondValue ? 1 : 0;
                    resultType = CmdID::BoolTmpType;

                    break;

                case CmdID::And:
                    result = (firstValue > 0) && (secondValue > 0) ? 1 : 0;
                    resultType = CmdID::BoolTmpType;

                    break;

                case CmdID::Or:
                    result = (firstValue > 0) || (secondValue > 0) ? 1 : 0;
                    resultType = CmdID::BoolTmpType;

                    break;

                case CmdID::Not:
                    result = (firstValue <= 0) ? 1 : 0;
                    resultType = CmdID::BoolTmpType;

                    break;

                default:
                    printf("Error : The operator %d is undefined #%d\n", cmd, bytecodeIndex);
                    error = true;

                    break;
                }

                newStackData.type = resultType;

                if (resultType == CmdID::NumberTmpType)
                {
                    numberStackIndex++;
                    numberStack[numberStackIndex] = result;
                }
                if (resultType == CmdID::BoolTmpType)
                {
                    boolStackIndex++;
                    boolStack[boolStackIndex] = result;
                }

                if (stackIndex >= stackSize)
                {
                    printf("Error : Stack overflow #%d\n", bytecodeIndex);
                    error = true;
                    break;
                }

                stackIndex++;
                stack[stackIndex].address = -1;
                stack[stackIndex].type = resultType;
            }
            else
            {
                int callFuncID;

                switch (cmd)
                {
                case CmdID::PrintNumber:
                    if (topStackData[0]->type == CmdID::NumberType)
                    {
                        printf("%.10g\n", numberVariable[topStackData[0]->address]);
                    }
                    if (topStackData[0]->type == CmdID::NumberTmpType)
                    {
                        printf("%.10g\n", numberStack[numberStackIndex]);
                        numberStackIndex--;
                    }

                    break;

                case CmdID::PrintString:
                    if (topStackData[0]->type == CmdID::StringType)
                    {
                        printf("%s\n", stringVariable[topStackData[0]->address].c_str());
                    }
                    if (topStackData[0]->type == CmdID::StringTmpType)
                    {
                        printf("%s\n", stringStack[stringStackIndex].c_str());
                        stringStackIndex--;
                    }

                    break;

                case CmdID::SetNumberVariable:
                    if (topStackData[1]->type == CmdID::NumberType)
                    {
                        numberVariable[topStackData[0]->address] = numberVariable[topStackData[1]->address];
                    }
                    if (topStackData[1]->type == CmdID::NumberTmpType)
                    {
                        numberVariable[topStackData[0]->address] = numberStack[numberStackIndex];
                        numberStackIndex--;
                    }

                    break;

                case CmdID::SetStringVariable:
                    if (topStackData[0]->type == CmdID::StringType)
                    {
                        stringVariable[topStackData[0]->address] = stringVariable[topStackData[1]->address];
                    }
                    if (topStackData[0]->type == CmdID::StringTmpType)
                    {
                        stringVariable[topStackData[0]->address] = stringStack[stringStackIndex];
                        stringStackIndex--;
                    }

                    break;

                case CmdID::Jump:
                    if (topStackData[0]->type == CmdID::BoolType)
                    {
                        if (boolVariable[topStackData[0]->address])
                        {
                            bytecodeIndex = topStackData[1]->address;
                            jumped = true;
                        }
                    }
                    else if (topStackData[0]->type == CmdID::BoolTmpType)
                    {
                        if (boolStack[boolStackIndex])
                        {
                            bytecodeIndex = topStackData[1]->address;
                            jumped = true;
                        }
                        boolStackIndex--;
                    }

                    break;

                case CmdID::Call:

                    callFuncID = topStackData[0]->address;

                    for (int i = 0; i < argNum - 1; i++)
                        callFuncArg.push_back(*topStackData[i + 1]);

                    newStackData = runner.RunCode(callFuncID, callFuncArg, runner);

                    if (newStackData.type == CmdID::Error)
                    {
                        error = true;
                    }
                    else if (newStackData.type != CmdID::VoidType)
                    {
                        stackIndex++;
                        stack[stackIndex] = newStackData;
                    }

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

        if (error)
        {
            break;
        }
    }

    if (stackIndex == -1)
    {
        returnStackData.type = CmdID::VoidType;
    }
    else if (stackIndex == 0)
    {
        returnStackData = stack[0];
    }
    else
    {
        error = true;
    }

    if (error)
    {
        returnStackData.type = CmdID::Error;
        printf("Process finished with some errors\n");
    }
    else
    {
        printf("Process finished succsessfully\n");
    }

    return returnStackData;
}

void Runner2::InitRunner(Runner2 &runner)
{
    runner.numberGlobalVariable = std::vector<double>(100000, 0);
    runner.stringGlobalVariable = std::vector<std::string>(10000, "");
    runner.boolGlobalVariable = std::vector<bool>(100000, false);

    runner.numberVariableInitialValues = std::vector<std::vector<double>>(runner.bytecodes.size());
    runner.stringVariableInitialValues = std::vector<std::vector<std::string>>(runner.bytecodes.size());
    runner.boolVariableInitialValues = std::vector<std::vector<bool>>(runner.bytecodes.size());
}
