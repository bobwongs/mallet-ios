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
        return Runner2::stackData();
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

    //* ###############
    numberVariable[0] = 128;
    numberVariable[1] = 256;
    //* ###############

    int bytecodeIndex = 0;

    bool error = false;

    while (bytecodeIndex < bytecode.size())
    {
        if (bytecode[bytecodeIndex] != CmdID::CodeBegin || bytecodeIndex + 2 >= bytecode.size())
        {
            error = true;
            printf("Error : bytecode is broken!\n");
            break;
        }

        int cmd = bytecode[bytecodeIndex + 1];
        int argNum = bytecode[bytecodeIndex + 2];

        stackData newStackData;

        std::vector<stackData> topStackData;
        for (int i = 0; i < argNum; i++)
        {
            topStackData.push_back(getTopStackData(stack, stackIndex, error));
        }

        if (error)
            break;

        if (cmd == CmdID::Push)
        {
            if (stackIndex >= stackSize)
            {
                printf("Error : Stack overflow\n");
                error = true;
                break;
            }

            if (bytecodeIndex + 4 >= bytecode.size())
            {
                error = true;
                printf("Error : bytecode is broken!\n");
                break;
            }

            int type = bytecode[bytecodeIndex + 3];
            int address = bytecode[bytecodeIndex + 4];

            newStackData.type = type;

            if (type == CmdID::NumberType)
            {
                newStackData.numberValue = numberVariable[address];
            }
            if (type == CmdID::StringType)
            {
                newStackData.stringValue = stringVariable[address];
            }
            if (type == CmdID::BoolType)
            {
                newStackData.boolValue = boolVariable[address];
            }
            if (type == CmdID::AddressType)
            {
                newStackData.address = address;
            }

            stackIndex++;

            stack[stackIndex] = newStackData;

            bytecodeIndex += pushCodeSize;
        }
        else
        {

            if (cmd / 10000 == 4)
            {
                double firstValue;
                double secondValue;
                if (topStackData[0].type == CmdID::NumberType)
                    firstValue = topStackData[0].numberValue;
                if (topStackData[0].type == CmdID::BoolType)
                    firstValue = topStackData[0].boolValue ? 1 : 0;

                if (cmd == CmdID::Not)
                {
                    secondValue = 0;
                }
                else
                {
                    if (topStackData[1].type == CmdID::NumberType)
                        secondValue = topStackData[1].numberValue;
                    if (topStackData[1].type == CmdID::BoolType)
                        secondValue = topStackData[1].boolValue ? 1 : 0;
                }

                double result = 0;
                int resultType;

                switch (cmd)
                {
                case CmdID::Add:
                    result = firstValue + secondValue;
                    resultType = CmdID::NumberType;

                    break;

                case CmdID::Sub:
                    result = firstValue - secondValue;
                    resultType = CmdID::NumberType;

                    break;

                case CmdID::Mul:
                    result = firstValue * secondValue;
                    resultType = CmdID::NumberType;

                    break;

                case CmdID::Div:
                    if (secondValue == 0)
                        result = 0;
                    else
                        result = firstValue / secondValue;
                    resultType = CmdID::NumberType;

                    break;

                case CmdID::Mod:
                    if ((int)secondValue == 0)
                        result = 0;
                    else
                        result = (int)firstValue % (int)secondValue;
                    resultType = CmdID::NumberType;

                    break;

                case CmdID::Equal:
                    result = firstValue == secondValue ? 1 : 0;
                    resultType = CmdID::BoolType;

                    break;

                case CmdID::NotEqual:
                    result = firstValue != secondValue ? 1 : 0;
                    resultType = CmdID::BoolType;

                    break;

                case CmdID::GreaterThan:
                    result = firstValue > secondValue ? 1 : 0;
                    resultType = CmdID::BoolType;

                    break;

                case CmdID::LessThan:
                    result = firstValue < secondValue ? 1 : 0;
                    resultType = CmdID::BoolType;

                    break;

                case CmdID::GreaterThanOrEqual:
                    result = firstValue >= secondValue ? 1 : 0;
                    resultType = CmdID::BoolType;

                    break;

                case CmdID::LessThanOrEqual:
                    result = firstValue <= secondValue ? 1 : 0;
                    resultType = CmdID::BoolType;

                    break;

                case CmdID::And:
                    result = (firstValue > 0) && (secondValue > 0) ? 1 : 0;
                    resultType = CmdID::BoolType;

                    break;

                case CmdID::Or:
                    result = (firstValue > 0) || (secondValue > 0) ? 1 : 0;
                    resultType = CmdID::BoolType;

                    break;

                case CmdID::Not:
                    result = (firstValue <= 0) ? 1 : 0;
                    resultType = CmdID::BoolType;

                    break;

                default:
                    printf("Error : The operator %d is undefined\n", cmd);
                    error = true;

                    break;
                }

                newStackData.type = resultType;
                newStackData.numberValue = result;

                if (stackIndex >= stackSize)
                {
                    printf("Error : Stack overflow\n");
                    error = true;
                    break;
                }

                stackIndex++;
                stack[stackIndex] = newStackData;
            }
            else
            {
                int callFuncID;
                std::vector<stackData> callFuncArg;

                switch (cmd)
                {
                case CmdID::PrintNumber:
                    printf("%g\n", topStackData[0].numberValue);

                    break;

                case CmdID::PrintString:
                    printf("%s\n", topStackData[0].stringValue.c_str());

                    break;

                case CmdID::SetNumberVariable:
                    numberVariable[topStackData[0].address] = topStackData[1].numberValue;

                    break;

                case CmdID::SetStringVariable:
                    stringVariable[topStackData[0].address] = topStackData[1].stringValue;

                    break;

                case CmdID::Jump:
                    if (!topStackData[0].boolValue)
                        bytecodeIndex = topStackData[1].address;

                    break;

                case CmdID::Call:

                    callFuncID = topStackData[0].address;

                    for (int i = 0; i < argNum - 1; i++)
                        callFuncArg.push_back(topStackData[i + 1]);

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
                    printf("Error : %d is undefined\n", cmd);
                    error = true;
                    break;
                }
            }

            if (cmd != CmdID::Jump)
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
