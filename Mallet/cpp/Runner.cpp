//
//  Runner.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/16.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "Runner.hpp"
#include "../objcpp/cpp2objcpp.h"
#include <time.h>
#include <iostream>

int GetNumberValue(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    int value = 0;

    if (code[firstIndex] == 3002)
    {
        //* 変数
        value = numberVariable[code[firstIndex + 2]];
    }
    else if (code[firstIndex] == 3003)
    {
        //* 数値
        value = code[firstIndex + 2];
    }
    else if (code[firstIndex] == 3102)
    {
        //* グローバル変数
        value = Cpp2ObjCpp::GetNumberGlobalVariable(code[firstIndex + 2]);
    }

    return value;
}

std::string GetStringValue(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    std::string value = "";

    if (code[firstIndex] == 3004)
    {
        value = stringVariable[code[firstIndex + 2]];
    }
    else if (code[firstIndex] == 3104)
    {
        char *str = Cpp2ObjCpp::GetStringGlobalVariable(code[firstIndex + 2]);
        value = std::string(str);
    }

    return value;
}

void Print(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    int valueIndex = firstIndex + 2;

    if (code[valueIndex] == 3004)
    {
        //文字列を出力
        std::string value = GetStringValue(code, valueIndex, numberVariable, stringVariable);

        //! DONT DELETE THIS
        printf("%s\n", value.c_str());
    }
    if (code[valueIndex] == 3002 || code[valueIndex] == 3003)
    {
        //数値を出力

        int value = GetNumberValue(code, valueIndex, numberVariable, stringVariable);

        //! DONT DELETE THIS
        printf("%d\n", value);
    }
}

void SetNumberVariable(int *code, int firstIndex, int *numberVariable, std::string *stringVariable)
{
    int addressIndex = firstIndex + 2;
    int valueIndex = firstIndex + 5;

    int address = OperateNumber(code, addressIndex, numberVariable, stringVariable);
    int value = OperateNumber(code, valueIndex, numberVariable, stringVariable);
    numberVariable[address] = value;
}

void SetStringVariable(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    int addressIndex = firstIndex + 2;
    int valueIndex = firstIndex + 5;

    int address = OperateNumber(code, addressIndex, numberVariable, stringVariable);
    std::string value = GetStringValue(code, valueIndex, numberVariable, stringVariable);
    stringVariable[address] = value;
}

void SetNumberGlobalVariable(int *code, int firstIndex, int *numberVariable, std::string *stringVariable)
{
    int addressIndex = firstIndex + 2;
    int valueIndex = firstIndex + 5;

    int address = OperateNumber(code, addressIndex, numberVariable, stringVariable);
    int value = OperateNumber(code, valueIndex, numberVariable, stringVariable);
    Cpp2ObjCpp::SetNumberGlobalVariable(address, value);
}

void SetStringGlobalVariable(int *code, int firstIndex, int *numberVariable, std::string *stringVariable)
{
    int addressIndex = firstIndex + 2;
    int valueIndex = firstIndex + 5;

    int address = OperateNumber(code, addressIndex, numberVariable, stringVariable);
    const char *value = GetStringValue(code, valueIndex, numberVariable, stringVariable).c_str();
    Cpp2ObjCpp::SetStringGlobalVariable(address, value);
}


void Repeat(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    int processIndex = firstIndex + 5;
    int repeatTimeIndex = firstIndex + 2;
    int repeatTime = GetNumberValue(code, repeatTimeIndex, numberVariable, stringVariable);

    for (int i = 0; i < repeatTime; i++)
    {
        Do(code, processIndex, numberVariable, stringVariable);
    }
}

void If(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    int processIndex = firstIndex + 5;
    int checkIndex = firstIndex + 2;

    int check = GetNumberValue(code, checkIndex, numberVariable, stringVariable);

    if (check <= 0)
        return;

    Do(code, processIndex, numberVariable, stringVariable);
}

void Do(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    int i = firstIndex + 2;
    int codeSize = code[firstIndex + 1];

    while (i - firstIndex + 1 < codeSize)
    {
        RunBlock(code, i, numberVariable, stringVariable);
        i += code[i + 1];
    }
}

void SetUIText(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    int uiNameIndex = firstIndex + 2;
    int uiTextIndex = firstIndex + 5;

    int uiName = GetNumberValue(code, uiNameIndex, numberVariable, stringVariable);

    char uiTextStr[1000];
    if (code[uiTextIndex] == 3004 || code[uiTextIndex] == 3104)
    {
        std::string uiText = GetStringValue(code, uiTextIndex, numberVariable, stringVariable);
        snprintf(uiTextStr, 1000, "%s", uiText.c_str());
    }
    else
    {
        int uiText = GetNumberValue(code, uiTextIndex, numberVariable, stringVariable);
        snprintf(uiTextStr, 1000, "%d", uiText);
    }

    Cpp2ObjCpp::SetUIText(uiName, uiTextStr);
}

void IO(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    switch (code[firstIndex])
    {
    case 1000:
        Print(code, firstIndex, numberVariable, stringVariable);
        break;

    default:
        break;
    }
}

void Control(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    switch (code[firstIndex])
    {
    case 2000:
        Do(code, firstIndex, numberVariable, stringVariable);
        break;

    case 2001:
        If(code, firstIndex, numberVariable, stringVariable);
        break;

    case 2002:
        Repeat(code, firstIndex, numberVariable, stringVariable);
        break;

    default:
        break;
    }
}

void Variable(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    switch (code[firstIndex])
    {
    case 3000:
        //数値型変数宣言
        break;

    case 3006:
        //文字列型変数宣言
        break;

    case 3001:
        SetNumberVariable(code, firstIndex, numberVariable, stringVariable);
        break;

    case 3007:
        SetStringVariable(code, firstIndex, numberVariable, stringVariable);
        break;

    case 3101:
        SetNumberGlobalVariable(code, firstIndex, numberVariable, stringVariable);
        break;

    case 3107:
        SetStringGlobalVariable(code, firstIndex, numberVariable, stringVariable);
        break;

    default:
        break;
    }
}

int OperateNumber(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    if (code[firstIndex] / 1000 == 3)
    {
        //単体の値の場合
        return GetNumberValue(code, firstIndex, numberVariable, stringVariable);
    }

    int firstValueIndex = firstIndex + 2;
    int secondValueIndex = firstIndex + 5;

    int value = 0;
    int firstValue = GetNumberValue(code, firstValueIndex, numberVariable, stringVariable);
    int secondValue = 0;
    if (code[firstIndex] == 4007)
        secondValue = 0;
    else
        secondValue = GetNumberValue(code, secondValueIndex, numberVariable, stringVariable);

    switch (code[firstIndex])
    {
    case 4000:
        value = firstValue + secondValue;
        break;
    case 4001:
        value = firstValue - secondValue;
        break;
    case 4002:
        value = firstValue * secondValue;
        break;
    case 4003:
        value = firstValue / secondValue;
        break;
    case 4004:
        value = firstValue % secondValue;
        break;
    case 4005:
        value = firstValue == secondValue ? 1 : 0;
        break;
    case 4006:
        value = firstValue > secondValue ? 1 : 0;
        break;
    case 4007:
        value = firstValue > 0 ? 0 : 1;
        break;
    case 4008:
        value = firstValue != secondValue ? 1 : 0;
        break;
    default:
        break;
    }

    return value;
}

std::string OperateString(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    std::string value = "";

    return value;
}

void UI(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    switch (code[firstIndex])
    {
    case 5000:
        SetUIText(code, firstIndex, numberVariable, stringVariable);
        break;
    default:
        break;
    }
}

void RunBlock(int code[], int firstIndex, int numberVariable[], std::string stringVariable[])
{
    switch (code[firstIndex] / 1000)
    {
    case 0:
        break;
    case 1:
        IO(code, firstIndex, numberVariable, stringVariable);
        break;
    case 2:
        Control(code, firstIndex, numberVariable, stringVariable);
        break;
    case 3:
        Variable(code, firstIndex, numberVariable, stringVariable);
        break;
    case 4:
        break;
    case 5:
        UI(code, firstIndex, numberVariable, stringVariable);
        break;
    default:
        break;
    }
}

void Cpp::RunCode(int code[], int codeSize, std::string stringVariableInitialValue[], int stringVariableInitialValueSize)
{
    // 変数
    int numberVariable[100000];
    std::string stringVariable[10000];

    //変数初期化
    memset(numberVariable, 0, sizeof(numberVariable));
    for (int i = 0; i < stringVariableInitialValueSize; i++)
    {
        stringVariable[i] = stringVariableInitialValue[i];
    }

    if (code[1] > codeSize)
    {
        return;
    }

    printf("Process started!\n");

    int i = 0;
    while (i < code[1])
    {
        RunBlock(code, i, numberVariable, stringVariable);
        i += code[i + 1];
    }

    printf("Process finished successfully!\n");
}