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

typedef struct
{
    int type;
    int codeAddress;
    int varAddress;
    double numberValue;
    std::string stringValue;
    bool boolValue;
} stackData;

stackData getTopStackData(std::vector<stackData> &stack, int &stackIndex, bool &error)
{
    if (stackIndex < 0)
    {
        printf("Error : There is nothing in the stack\n");
        error = true;
        return stackData();
    }

    stackIndex--;
    return stack[stackIndex + 1];
}

void Runner2::RunCode(std::vector<int> byteCode, Runner2 &runner)
{
    int stackIndex = -1;
    const int stackSize = 10000;
    std::vector<stackData> stack(stackSize);

    std::vector<double> numberVariable(10000, 0);
    std::vector<std::string> stringVariable(10000, "");
    std::vector<bool> boolVariable(10000, false);

    constexpr int pushCodeSize = 5;
    constexpr int defaultCodeSize = 3;

    //* ###############
    numberVariable[0] = 128;
    numberVariable[1] = 256;
    //* ###############

    int byteCodeIndex = 0;

    bool error = false;

    while (byteCodeIndex < byteCode.size())
    {
        if (byteCode[byteCodeIndex] != CmdID::CodeBegin || byteCodeIndex + 2 >= byteCode.size())
        {
            error = true;
            printf("Error : Bytecode is broken!\n");
            break;
        }

        int cmd = byteCode[byteCodeIndex + 1];
        int argNum = byteCode[byteCodeIndex + 2];

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

            if (byteCodeIndex + 4 >= byteCode.size())
            {
                error = true;
                printf("Error : Bytecode is broken!\n");
                break;
            }

            int type = byteCode[byteCodeIndex + 3];
            int address = byteCode[byteCodeIndex + 4];

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
            if (type == CmdID::CodeAddressType)
            {
                newStackData.codeAddress = address;
            }

            stackIndex++;

            stack[stackIndex] = newStackData;

            byteCodeIndex += pushCodeSize;
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
                switch (cmd)
                {
                case CmdID::PrintNumber:
                    printf("%g\n", topStackData[0].numberValue);

                    break;

                case CmdID::PrintString:
                    printf("%s\n", topStackData[0].stringValue.c_str());

                    break;

                case CmdID::SetNumberVariable:
                    numberVariable[topStackData[0].varAddress] = topStackData[1].numberValue;

                    break;

                case CmdID::SetStringVariable:
                    stringVariable[topStackData[0].varAddress] = topStackData[1].stringValue;

                    break;

                case CmdID::Jump:
                    if (!topStackData[0].boolValue)
                        byteCodeIndex = topStackData[1].codeAddress;

                    break;

                default:
                    printf("Error : %d is undefined\n", cmd);
                    error = true;
                    break;
                }
            }

            if (cmd != CmdID::Jump)
                byteCodeIndex += defaultCodeSize;
        }

        if (error)
        {
            break;
        }
    }

    if (error)
    {
        printf("Process finished with some errors\n");
    }
    else
    {
        printf("Process finished succsessfully\n");
    }
}