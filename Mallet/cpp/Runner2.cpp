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

void Runner2::RunCode(std::vector<ByteCode> byteCode, Runner2 &runner)
{
    int stackIndex = -1;
    const int stackSize = 10000;
    std::vector<stackData> stack(stackSize);

    std::vector<double> numberVariable(10000, 0);
    std::vector<std::string> stringVariable(10000, "");
    std::vector<bool> boolVariable(10000, false);

    //* ###############
    numberVariable[0] = 128;
    numberVariable[1] = 256;
    //* ###############

    int byteCodeIndex = 0;

    bool error = false;

    while (byteCodeIndex < byteCode.size())
    {
        int id = byteCode[byteCodeIndex].id;
        int type = byteCode[byteCodeIndex].type;
        int value = byteCode[byteCodeIndex].value;
        int argNum = byteCode[byteCodeIndex].argNum;

        stackData newStackData;

        std::vector<stackData> topStackData;
        for (int i = 0; i < argNum; i++)
        {
            topStackData.push_back(getTopStackData(stack, stackIndex, error));
        }

        if (error)
            break;

        if (id / 10000 == 4)
        {
            double firstValue = topStackData[0].numberValue;
            double secondValue = id == CmdID::Not ? 0 : topStackData[1].numberValue;
            double result = 0;

            switch (id)
            {
            case CmdID::Add:
                result = firstValue + secondValue;

                break;

            case CmdID::Sub:
                result = firstValue - secondValue;

                break;

            case CmdID::Mul:
                result = firstValue * secondValue;

                break;

            case CmdID::Div:
                if (secondValue == 0)
                    result = 0;
                else
                    result = firstValue / secondValue;

                break;

            case CmdID::Mod:
                if ((int)secondValue == 0)
                    result = 0;
                else
                    result = (int)firstValue % (int)secondValue;

                break;

            case CmdID::Equal:
                result = firstValue == secondValue ? 1 : 0;

                break;

            case CmdID::NotEqual:
                result = firstValue != secondValue ? 1 : 0;

                break;

            case CmdID::GreaterThan:
                result = firstValue > secondValue ? 1 : 0;

                break;

            case CmdID::LessThan:
                result = firstValue < secondValue ? 1 : 0;

                break;

            case CmdID::GreaterThanOrEqual:
                result = firstValue >= secondValue ? 1 : 0;

                break;

            case CmdID::LessThanOrEqual:
                result = firstValue <= secondValue ? 1 : 0;

                break;

            case CmdID::And:
                result = (firstValue > 0) && (secondValue > 0) ? 1 : 0;

                break;

            case CmdID::Or:
                result = (firstValue > 0) || (secondValue > 0) ? 1 : 0;

                break;

            case CmdID::Not:
                result = (firstValue <= 0) ? 1 : 0;

                break;

            default:
                printf("Error : The operator %d is undefined\n", id);
                error = true;

                break;
            }

            newStackData.type = CmdID::NumberType;
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
            switch (id)
            {
            case CmdID::Push:
                if (stackIndex >= stackSize)
                {
                    printf("Error : Stack overflow\n");
                    error = true;
                    break;
                }

                newStackData.type = type;

                if (type == CmdID::NumberType)
                {
                    newStackData.numberValue = numberVariable[value];
                }
                if (type == CmdID::StringType)
                {
                    newStackData.stringValue = stringVariable[value];
                }
                if (type == CmdID::BoolType)
                {
                    newStackData.boolValue = boolVariable[value];
                }
                if (type == CmdID::CodeAddressType)
                {
                    newStackData.codeAddress = value;
                }

                stackIndex++;

                stack[stackIndex] = newStackData;

                break;

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
                    byteCodeIndex = topStackData[1].codeAddress - 1;

                break;

            default:
                printf("Error : %d is undefined\n", byteCode[byteCodeIndex].id);
                error = true;
                break;
            }
        }

        if (error)
        {
            break;
        }

        byteCodeIndex++;
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