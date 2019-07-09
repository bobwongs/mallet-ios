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

Runner2::funcStackData Runner2::RunCode(int funcID, std::vector<Runner2::funcStackData> args)
{
    int funcType = funcTypes[funcID];

    int stackIndex = -1;
    constexpr int stackSize = 1000000;
    std::vector<stackData> stack(stackSize);

    funcStackData returnStackData;

    std::vector<double> numberVariable(10000000, 0);
    std::vector<std::string> stringVariable(100000, "");
    std::vector<bool> boolVariable(10000000, false);

    int reservedNumberMemorySize = numberGlobalVariableNum;
    int reservedStringMemorySize = stringGlobalVariableNum;
    int reservedBoolMemorySize = boolGlobalVariableNum;

    std::vector<double> numberStack(10000, 0);
    std::vector<std::string> stringStack(10000, "");
    std::vector<bool> boolStack(10000, false);
    int numberStackIndex = -1;
    int stringStackIndex = -1;
    int boolStackIndex = -1;

    for (int i = 0; i < numberVariableInitialValues.size(); i++)
        numberVariable[i] = numberVariableInitialValues[i];
    for (int i = 0; i < stringVariableInitialValues.size(); i++)
        stringVariable[i] = stringVariableInitialValues[i];
    for (int i = 0; i < boolVariableInitialValues.size(); i++)
        boolVariable[i] = boolVariableInitialValues[i];

    numberVariable[1] = 0;
    numberVariable[2] = 1;

    boolVariable[1] = true;
    boolVariable[2] = false;

    constexpr int pushCodeSize = 6;
    constexpr int defaultCodeSize = 3;

    int argIndex = 0;

    int currentFuncID = funcID;

    for (funcStackData arg : args)
    {
        switch (arg.type)
        {
        case CmdID::NumberType:
            numberVariable[argAddresses[funcID][argIndex]] = arg.numberValue;

            break;

        case CmdID::StringType:
            stringVariable[argAddresses[funcID][argIndex]] = arg.stringValue;

            break;

        case CmdID::BoolType:
            boolVariable[argAddresses[funcID][argIndex]] = arg.boolValue;

            break;

        case CmdID::IntType:
            //TODO:
            break;

        default:

            break;
        }

        argIndex++;
    }

    int bytecodeIndex = funcStartIndexes[funcID];
    int bytecodeSize = bytecode.size();

    bool error = false;

    std::vector<stackData *> topStackData(100);

    stackData newStackData;

    std::vector<funcStackData> callFuncArg;

    funcStackData newArg;
    funcStackData returnValue;

    bool endProcess = false;

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

            if (bytecodeIndex + pushCodeSize - 1 >= bytecodeSize)
            {
                error = true;
                printf("Error : bytecode is broken! #%d\n", bytecodeIndex);
                break;
            }

            int type = bytecode[bytecodeIndex + 3];
            int address = bytecode[bytecodeIndex + 4];
            bool absolute = bytecode[bytecodeIndex + 5] > 0;

            if (!absolute && type != CmdID::IntType)
            {
                //TODO:
                //address+= ;

                switch (type)
                {
                case CmdID::NumberType:
                    address += reservedNumberMemorySize;
                    break;
                case CmdID::NumberAddressType:
                    address += reservedNumberMemorySize;
                    break;

                case CmdID::StringType:
                    address += reservedStringMemorySize;
                    break;
                case CmdID::StringAddressType:
                    address += reservedStringMemorySize;
                    break;

                case CmdID::BoolType:
                    address += reservedBoolMemorySize;
                    break;
                case CmdID::BoolAddressType:
                    address += reservedBoolMemorySize;
                    break;

                default:
                    printf("Error : Unknown type #%d\n", bytecodeIndex);
                    error = true;
                    break;
                }
            }

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
                    else if (topStackData[1]->type == CmdID::NumberTmpType)
                    {
                        numberVariable[topStackData[0]->address] = numberStack[numberStackIndex];
                        numberStackIndex--;
                    }
                    else if (topStackData[1]->type == CmdID::BoolType)
                    {
                        numberVariable[topStackData[0]->address] = boolVariable[topStackData[1]->address];
                    }
                    if (topStackData[1]->type == CmdID::BoolTmpType)
                    {
                        numberVariable[topStackData[0]->address] = boolStack[boolStackIndex];
                        boolStackIndex--;
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

                    /*
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
                    */

                case CmdID::CallMalletFunc:

                    reservedNumberMemorySize += numberMemorySize[currentFuncID];
                    reservedStringMemorySize += stringMemorySize[currentFuncID];
                    reservedBoolMemorySize += boolMemorySize[currentFuncID];

                    callFuncID = topStackData[argNum - 1]->address;

                    /*
                    stackIndex++;
                    stack[stackIndex] = {CmdID::IntType, bytecodeIndex + defaultCodeSize};
                    */

                    stackIndex++;
                    stack[stackIndex] = {CmdID::StartFuncType, currentFuncID};

                    bytecodeIndex = funcStartIndexes[callFuncID];
                    jumped = true;

                    currentFuncID = callFuncID;

                    //callFuncArg = std::vector<funcStackData>(argNum - 1);

                    /*
                    for (int i = 0; i < argNum - 1; i++)
                    {
                        switch (topStackData[i]->type)
                        {
                        case CmdID::NumberType:
                            newArg.type = CmdID::NumberType;
                            newArg.numberValue = numberVariable[topStackData[i]->address];

                            break;

                        case CmdID::NumberTmpType:
                            newArg.type = CmdID::NumberType;
                            newArg.numberValue = numberStack[numberStackIndex];
                            numberStackIndex--;

                            break;

                        case CmdID::StringType:
                            newArg.type = CmdID::StringType;
                            newArg.stringValue = stringVariable[topStackData[i]->address];

                            break;

                        case CmdID::StringTmpType:
                            newArg.type = CmdID::StringType;
                            newArg.stringValue = stringStack[stringStackIndex];
                            stringStackIndex--;

                            break;

                        case CmdID::BoolType:
                            newArg.type = CmdID::BoolType;
                            newArg.boolValue = boolVariable[topStackData[i]->address];

                            break;

                        case CmdID::BoolTmpType:
                            newArg.type = CmdID::BoolType;
                            newArg.boolValue = boolStack[boolStackIndex];
                            boolStackIndex--;

                            break;

                        case CmdID::IntType:
                            newArg.type = CmdID::IntType;
                            newArg.address = topStackData[i]->address;

                            break;

                        default:
                            printf("Error : Unknown type\n");
                            error = true;
                            break;
                        }

                        callFuncArg[i] = newArg;
                    }

                    returnValue = RunCode(callFuncID, callFuncArg);

                    if (returnValue.type != CmdID::VoidType)
                    {
                        //stackIndex++;
                        //stack[stackIndex] = {returnValue.type, returnValue.address};

                        switch (returnValue.type)
                        {
                        case CmdID::NumberType:
                            numberStackIndex++;
                            numberStack[numberStackIndex] = returnValue.numberValue;

                            stackIndex++;
                            stack[stackIndex] = {CmdID::NumberTmpType, returnValue.address};

                            break;

                        case CmdID::StringType:
                            stringStackIndex++;
                            stringStack[stringStackIndex] = returnValue.stringValue;

                            stackIndex++;
                            stack[stackIndex] = {CmdID::StringTmpType, returnValue.address};

                            break;

                        case CmdID::BoolType:
                            boolStackIndex++;
                            boolStack[boolStackIndex] = returnValue.boolValue;

                            stackIndex++;
                            stack[stackIndex] = {CmdID::BoolTmpType, returnValue.address};

                            break;

                        default:
                            break;
                        }

                        break;
                    }
                    */

                    break;

                case CmdID::CallCppFunc:

                    break;

                case CmdID::Return:
                    newStackData = {stack[stackIndex].type, stack[stackIndex].address};

                    if (newStackData.type == CmdID::NumberType)
                    {
                        newStackData.type = CmdID::NumberTmpType;

                        numberStackIndex++;
                        numberStack[numberStackIndex] = numberVariable[newStackData.address];
                    }
                    if (newStackData.type == CmdID::StringType)
                    {
                        newStackData.type = CmdID::StringTmpType;

                        stringStackIndex++;
                        stringStack[stringStackIndex] = stringVariable[newStackData.address];
                    }
                    if (newStackData.type == CmdID::BoolType)
                    {
                        newStackData.type = CmdID::BoolTmpType;

                        boolStackIndex++;
                        boolStack[boolStackIndex] = boolVariable[newStackData.address + reservedBoolMemorySize];
                    }

                    while (stackIndex >= 0 && stack[stackIndex].type != CmdID::StartFuncType)
                        stackIndex--;

                    currentFuncID = stack[stackIndex].address;

                    stackIndex--;
                    bytecodeIndex = stack[stackIndex].address;
                    jumped = true;

                    reservedNumberMemorySize -= numberMemorySize[currentFuncID];
                    reservedStringMemorySize -= stringMemorySize[currentFuncID];
                    reservedBoolMemorySize -= boolMemorySize[currentFuncID];

                    stack[stackIndex] = newStackData;

                    break;

                case CmdID::EndOfFunc:
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

    if (funcType == CmdID::VoidType)
    {
        returnStackData.type = CmdID::VoidType;

        return returnStackData;
    }

    if (stackIndex < 0)
    {
        printf("Error : There is nothing in the stack\n");

        error = true;

        returnStackData.type = CmdID::Error;

        return returnStackData;
    }
    else
    {
        stackData topStackData = stack[stackIndex];
        stackIndex--;

        returnStackData.type = funcType;

        switch (topStackData.type)
        {
        case CmdID::NumberType:
            if (funcType != CmdID::NumberType)
            {
                printf("Error : Return type is wrong\n");
                error = true;
                break;
            }

            returnStackData.numberValue = numberVariable[topStackData.address];

            break;

        case CmdID::NumberTmpType:
            if (funcType != CmdID::NumberType)
            {
                printf("Error : Return type is wrong\n");
                error = true;
                break;
            }

            returnStackData.numberValue = numberStack[numberStackIndex];
            numberStackIndex--;

            break;

        case CmdID::StringType:
            if (funcType != CmdID::StringType)
            {
                printf("Error : Return type is wrong\n");
                error = true;
                break;
            }

            returnStackData.stringValue = stringVariable[topStackData.address];

            break;

        case CmdID::StringTmpType:
            if (funcType != CmdID::StringType)
            {
                printf("Error : Return type is wrong\n");
                error = true;
                break;
            }

            returnStackData.stringValue = stringStack[stringStackIndex];
            stringStackIndex--;

            break;

        case CmdID::BoolType:
            if (funcType != CmdID::BoolType)
            {
                printf("Error : Return type is wrong\n");
                error = true;
                break;
            }

            returnStackData.boolValue = boolVariable[topStackData.address];

            break;

        case CmdID::BoolTmpType:
            if (funcType != CmdID::BoolType)
            {
                printf("Error : Return type is wrong\n");
                error = true;
                break;
            }

            returnStackData.boolValue = boolStack[boolStackIndex];
            boolStackIndex--;

            break;

        case CmdID::IntType:
            if (funcType != CmdID::IntType)
            {
                printf("Error : Return type is wrong\n");
                error = true;
                break;
            }

            returnStackData.address = topStackData.address;

            break;

        default:
            printf("Error : Unknown type\n");
            error = true;
            break;
        }
    }

    if (error)
    {
        returnStackData.type = CmdID::Error;
        printf("Process finished with some errors\n");
    }
    else
    {
        //printf("Process finished succsessfully\n");
    }

    return returnStackData;
}

void Runner2::InitRunner(Runner2 &runner)
{
    runner.numberGlobalVariable = std::vector<double>(100000, 0);
    runner.stringGlobalVariable = std::vector<std::string>(10000, "");
    runner.boolGlobalVariable = std::vector<bool>(100000, false);

    runner.numberVariableInitialValues = std::vector<double>();
    runner.stringVariableInitialValues = std::vector<std::string>();
    runner.boolVariableInitialValues = std::vector<bool>();
}
