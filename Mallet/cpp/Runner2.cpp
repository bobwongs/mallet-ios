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
        errorStackData.type = ERROR;
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
        case NUMBER_TYPE:
            numberVariable[argAddresses[funcID][argIndex]] = arg.numberValue;

            break;

        case STRING_TYPE:
            stringVariable[argAddresses[funcID][argIndex]] = arg.stringValue;

            break;

        case BOOL_TYPE:
            boolVariable[argAddresses[funcID][argIndex]] = arg.boolValue;

            break;

        case INT_TYPE:
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

    stackIndex++;
    stack[stackIndex] = {INT_TYPE, bytecodeSize};
    stackIndex++;
    stack[stackIndex] = {STRING_FUNC_TYPE, -1};

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

        if (cmd == PUSH)
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

            if (!absolute && type != INT_TYPE)
            {
                //TODO:
                //address+= ;

                switch (type)
                {
                case NUMBER_TYPE:
                    address += reservedNumberMemorySize;
                    break;
                case NUMBER_ADDRESS_TYPE:
                    address += reservedNumberMemorySize;
                    break;

                case STRING_TYPE:
                    address += reservedStringMemorySize;
                    break;
                case STRING_ADDRESS_TYPE:
                    address += reservedStringMemorySize;
                    break;

                case BOOL_TYPE:
                    address += reservedBoolMemorySize;
                    break;
                case BOOL_ADDRESS_TYPE:
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

            if (cmd >= 1024)
            {
                double firstValue;
                double secondValue;

                int type = topStackData[0]->type;
                int address = topStackData[0]->address;

                if (type == NUMBER_TYPE)
                {
                    firstValue = numberVariable[address];
                }
                else if (type == BOOL_TYPE)
                {
                    firstValue = boolVariable[address] ? 1 : 0;
                }
                else if (type == NUMBER_TMP_TYPE)
                {
                    firstValue = numberStack[numberStackIndex];
                    numberStackIndex--;
                }
                else if (type == BOOL_TMP_TYPE)
                {
                    firstValue = boolStack[boolStackIndex];
                    boolStackIndex--;
                }

                if (cmd == NOT)
                {
                    secondValue = 0;
                }
                else
                {
                    int type = topStackData[1]->type;
                    int address = topStackData[1]->address;

                    if (type == NUMBER_TYPE)
                    {
                        secondValue = numberVariable[address];
                    }
                    else if (type == BOOL_TYPE)
                    {
                        secondValue = boolVariable[address] ? 1 : 0;
                    }
                    else if (type == NUMBER_TMP_TYPE)
                    {
                        secondValue = numberStack[numberStackIndex];
                        numberStackIndex--;
                    }
                    else if (type == BOOL_TMP_TYPE)
                    {
                        secondValue = boolStack[boolStackIndex];
                        boolStackIndex--;
                    }
                }

                double result = 0;
                int resultType;

                switch (cmd)
                {
                case ADD:
                    result = firstValue + secondValue;
                    resultType = NUMBER_TMP_TYPE;

                    break;

                case SUB:
                    result = firstValue - secondValue;
                    resultType = NUMBER_TMP_TYPE;

                    break;

                case MUL:
                    result = firstValue * secondValue;
                    resultType = NUMBER_TMP_TYPE;

                    break;

                case DIV:
                    if (secondValue == 0)
                        result = 0;
                    else
                        result = firstValue / secondValue;
                    resultType = NUMBER_TMP_TYPE;

                    break;

                case MOD:
                    if ((int)secondValue == 0)
                        result = 0;
                    else
                        result = (int)firstValue % (int)secondValue;
                    resultType = NUMBER_TMP_TYPE;

                    break;

                case EQUAL:
                    result = firstValue == secondValue ? 1 : 0;
                    resultType = BOOL_TMP_TYPE;

                    break;

                case NOT_EQUAL:
                    result = firstValue != secondValue ? 1 : 0;
                    resultType = BOOL_TMP_TYPE;

                    break;

                case GREATER_THAN:
                    result = firstValue > secondValue ? 1 : 0;
                    resultType = BOOL_TMP_TYPE;

                    break;

                case LESS_THAN:
                    result = firstValue < secondValue ? 1 : 0;
                    resultType = BOOL_TMP_TYPE;

                    break;

                case GREATER_THAN_OR_EQUAL:
                    result = firstValue >= secondValue ? 1 : 0;
                    resultType = BOOL_TMP_TYPE;

                    break;

                case LESS_THAN_OR_EQUAL:
                    result = firstValue <= secondValue ? 1 : 0;
                    resultType = BOOL_TMP_TYPE;

                    break;

                case AND:
                    result = (firstValue > 0) && (secondValue > 0) ? 1 : 0;
                    resultType = BOOL_TMP_TYPE;

                    break;

                case OR:
                    result = (firstValue > 0) || (secondValue > 0) ? 1 : 0;
                    resultType = BOOL_TMP_TYPE;

                    break;

                case NOT:
                    result = (firstValue <= 0) ? 1 : 0;
                    resultType = BOOL_TMP_TYPE;

                    break;

                default:
                    printf("Error : The operator %d is undefined #%d\n", cmd, bytecodeIndex);
                    error = true;

                    break;
                }

                newStackData.type = resultType;

                if (resultType == NUMBER_TMP_TYPE)
                {
                    numberStackIndex++;
                    numberStack[numberStackIndex] = result;
                }
                if (resultType == BOOL_TMP_TYPE)
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
                case PRINT_NUMBER:
                    if (topStackData[0]->type == NUMBER_TYPE)
                    {
                        printf("%.10g\n", numberVariable[topStackData[0]->address]);
                    }
                    if (topStackData[0]->type == NUMBER_TMP_TYPE)
                    {
                        printf("%.10g\n", numberStack[numberStackIndex]);
                        numberStackIndex--;
                    }

                    break;

                case PRINT_STRING:
                    if (topStackData[0]->type == STRING_TYPE)
                    {
                        printf("%s\n", stringVariable[topStackData[0]->address].c_str());
                    }
                    if (topStackData[0]->type == STRING_TMP_TYPE)
                    {
                        printf("%s\n", stringStack[stringStackIndex].c_str());
                        stringStackIndex--;
                    }

                    break;

                case SET_NUMBER_VARIABLE:
                    if (topStackData[1]->type == NUMBER_TYPE)
                    {
                        numberVariable[topStackData[0]->address] = numberVariable[topStackData[1]->address];
                    }
                    else if (topStackData[1]->type == NUMBER_TMP_TYPE)
                    {
                        numberVariable[topStackData[0]->address] = numberStack[numberStackIndex];
                        numberStackIndex--;
                    }
                    else if (topStackData[1]->type == BOOL_TYPE)
                    {
                        numberVariable[topStackData[0]->address] = boolVariable[topStackData[1]->address];
                    }
                    if (topStackData[1]->type == BOOL_TMP_TYPE)
                    {
                        numberVariable[topStackData[0]->address] = boolStack[boolStackIndex];
                        boolStackIndex--;
                    }

                    break;

                case SET_STRING_VARIABLE:
                    if (topStackData[0]->type == STRING_TYPE)
                    {
                        stringVariable[topStackData[0]->address] = stringVariable[topStackData[1]->address];
                    }
                    if (topStackData[0]->type == STRING_TMP_TYPE)
                    {
                        stringVariable[topStackData[0]->address] = stringStack[stringStackIndex];
                        stringStackIndex--;
                    }

                    break;

                case JUMP:
                    if (topStackData[0]->type == BOOL_TYPE)
                    {
                        if (boolVariable[topStackData[0]->address])
                        {
                            bytecodeIndex = topStackData[1]->address;
                            jumped = true;
                        }
                    }
                    else if (topStackData[0]->type == BOOL_TMP_TYPE)
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
                case Call:

                    callFuncID = topStackData[0]->address;

                    for (int i = 0; i < argNum - 1; i++)
                        callFuncArg.push_back(*topStackData[i + 1]);

                    newStackData = runner.RunCode(callFuncID, callFuncArg, runner);

                    if (newStackData.type == Error)
                    {
                        error = true;
                    }
                    else if (newStackData.type != VoidType)
                    {
                        stackIndex++;
                        stack[stackIndex] = newStackData;
                    }

                    break;
                    */

                case CALL_MALLET_FUNC:

                    reservedNumberMemorySize += numberMemorySize[currentFuncID];
                    reservedStringMemorySize += stringMemorySize[currentFuncID];
                    reservedBoolMemorySize += boolMemorySize[currentFuncID];

                    callFuncID = topStackData[argNum - 1]->address;

                    /*
                    stackIndex++;
                    stack[stackIndex] = {IntType, bytecodeIndex + defaultCodeSize};
                    */

                    stackIndex++;
                    stack[stackIndex] = {STRING_FUNC_TYPE, currentFuncID};

                    bytecodeIndex = funcStartIndexes[callFuncID];
                    jumped = true;

                    currentFuncID = callFuncID;

                    //callFuncArg = std::vector<funcStackData>(argNum - 1);

                    /*
                    for (int i = 0; i < argNum - 1; i++)
                    {
                        switch (topStackData[i]->type)
                        {
                        case NumberType:
                            newArg.type = NumberType;
                            newArg.numberValue = numberVariable[topStackData[i]->address];

                            break;

                        case NumberTmpType:
                            newArg.type = NumberType;
                            newArg.numberValue = numberStack[numberStackIndex];
                            numberStackIndex--;

                            break;

                        case StringType:
                            newArg.type = StringType;
                            newArg.stringValue = stringVariable[topStackData[i]->address];

                            break;

                        case StringTmpType:
                            newArg.type = StringType;
                            newArg.stringValue = stringStack[stringStackIndex];
                            stringStackIndex--;

                            break;

                        case BoolType:
                            newArg.type = BoolType;
                            newArg.boolValue = boolVariable[topStackData[i]->address];

                            break;

                        case BoolTmpType:
                            newArg.type = BoolType;
                            newArg.boolValue = boolStack[boolStackIndex];
                            boolStackIndex--;

                            break;

                        case IntType:
                            newArg.type = IntType;
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

                    if (returnValue.type != VoidType)
                    {
                        //stackIndex++;
                        //stack[stackIndex] = {returnValue.type, returnValue.address};

                        switch (returnValue.type)
                        {
                        case NumberType:
                            numberStackIndex++;
                            numberStack[numberStackIndex] = returnValue.numberValue;

                            stackIndex++;
                            stack[stackIndex] = {NumberTmpType, returnValue.address};

                            break;

                        case StringType:
                            stringStackIndex++;
                            stringStack[stringStackIndex] = returnValue.stringValue;

                            stackIndex++;
                            stack[stackIndex] = {StringTmpType, returnValue.address};

                            break;

                        case BoolType:
                            boolStackIndex++;
                            boolStack[boolStackIndex] = returnValue.boolValue;

                            stackIndex++;
                            stack[stackIndex] = {BoolTmpType, returnValue.address};

                            break;

                        default:
                            break;
                        }

                        break;
                    }
                    */

                    break;

                case CALL_CPP_FUNC:

                    break;

                case RETURN:
                    newStackData = {stack[stackIndex].type, stack[stackIndex].address};

                    if (newStackData.type == NUMBER_TYPE)
                    {
                        newStackData.type = NUMBER_TMP_TYPE;

                        numberStackIndex++;
                        numberStack[numberStackIndex] = numberVariable[newStackData.address];
                    }
                    if (newStackData.type == STRING_TYPE)
                    {
                        newStackData.type = STRING_TMP_TYPE;

                        stringStackIndex++;
                        stringStack[stringStackIndex] = stringVariable[newStackData.address];
                    }
                    if (newStackData.type == BOOL_TYPE)
                    {
                        newStackData.type = BOOL_TMP_TYPE;

                        boolStackIndex++;
                        boolStack[boolStackIndex] = boolVariable[newStackData.address + reservedBoolMemorySize];
                    }

                    while (stackIndex >= 0 && stack[stackIndex].type != STRING_FUNC_TYPE)
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

    if (funcType == VOID_TYPE)
    {
        returnStackData.type = VOID_TYPE;

        return returnStackData;
    }

    if (stackIndex < 0)
    {
        printf("Error : There is nothing in the stack\n");

        error = true;

        returnStackData.type = ERROR;

        return returnStackData;
    }
    else
    {
        stackData topStackData = stack[stackIndex];
        stackIndex--;

        returnStackData.type = funcType;

        switch (topStackData.type)
        {
        case NUMBER_TYPE:
            if (funcType != NUMBER_TYPE)
            {
                printf("Error : Return type is wrong\n");
                error = true;
                break;
            }

            returnStackData.numberValue = numberVariable[topStackData.address];

            break;

        case NUMBER_TMP_TYPE:
            if (funcType != NUMBER_TYPE)
            {
                printf("Error : Return type is wrong\n");
                error = true;
                break;
            }

            returnStackData.numberValue = numberStack[numberStackIndex];
            numberStackIndex--;

            break;

        case STRING_TYPE:
            if (funcType != STRING_TYPE)
            {
                printf("Error : Return type is wrong\n");
                error = true;
                break;
            }

            returnStackData.stringValue = stringVariable[topStackData.address];

            break;

        case STRING_TMP_TYPE:
            if (funcType != STRING_TYPE)
            {
                printf("Error : Return type is wrong\n");
                error = true;
                break;
            }

            returnStackData.stringValue = stringStack[stringStackIndex];
            stringStackIndex--;

            break;

        case BOOL_TYPE:
            if (funcType != BOOL_TYPE)
            {
                printf("Error : Return type is wrong\n");
                error = true;
                break;
            }

            returnStackData.boolValue = boolVariable[topStackData.address];

            break;

        case BOOL_TMP_TYPE:
            if (funcType != BOOL_TYPE)
            {
                printf("Error : Return type is wrong\n");
                error = true;
                break;
            }

            returnStackData.boolValue = boolStack[boolStackIndex];
            boolStackIndex--;

            break;

        case INT_TYPE:
            if (funcType != INT_TYPE)
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
        returnStackData.type = ERROR;
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
