//
//  Runner.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/16.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "Runner.hpp"
#include "../objcpp/cpp2objcpp.h"
#include <vector>
//#include "../objcpp/objcpp.h"

int GetNumberValue(std::vector<int> &code, int firstIndex, ArgData argData)
{
    int value = 0;

    if (code[firstIndex] == CmdID::IntVariableValue)
    {
        //* 変数
        value = argData.numberVariable[code[firstIndex + 2]];
    }
    else if (code[firstIndex] == CmdID::IntValue)
    {
        //* 数値
        value = code[firstIndex + 2];
    }
    else if (code[firstIndex] == CmdID::IntGlobalVariableValue)
    {
        //* グローバル変数
        value = argData.runner.numberGlobalVariable[code[firstIndex + 2]];
    }
    else if (code[firstIndex] == CmdID::IntTmpVariableValue)
    {
        //* 一時変数
        value = argData.tmpNumberVariable[code[firstIndex + 2]];
    }
    else
    {
        //* 数値ではない
        printf("%d is not number!\n", code[firstIndex]);
    }

    return value;
}

std::string GetStringValue(std::vector<int> &code, int firstIndex, ArgData argData)
{
    std::string value = "";

    if (code[firstIndex] == CmdID::StringVariableValue)
    {
        value = argData.stringVariable[code[firstIndex + 2]];
    }
    else if (code[firstIndex] == CmdID::StringGlobalVariableValue)
    {
        //char *str = Cpp2ObjCpp::GetStringGlobalVariable(code[firstIndex + 2]);
        value = argData.runner.stringGlobalVariable[code[firstIndex + 2]];
    }

    return value;
}

void Print(std::vector<int> &code, int firstIndex, ArgData argData)
{
    int valueIndex = firstIndex + 2;

    if (code[valueIndex] == CmdID::StringVariableValue)
    {
        //文字列を出力
        std::string value = GetStringValue(code, valueIndex, argData);

        //! DONT DELETE THIS
        printf("%s\n", value.c_str());
    }
    if (code[valueIndex] == CmdID::IntVariableValue || code[valueIndex] == CmdID::IntValue)
    {
        //数値を出力

        int value = GetNumberValue(code, valueIndex, argData);

        //! DONT DELETE THIS
        printf("%d\n", value);
    }
}

void SetNumberVariable(std::vector<int> &code, int firstIndex, ArgData argData)
{
    int addressIndex = firstIndex + 2;
    int valueIndex = firstIndex + 5;

    int address = OperateNumber(code, addressIndex, argData);
    int value = OperateNumber(code, valueIndex, argData);
    argData.numberVariable[address] = value;
}

void SetStringVariable(std::vector<int> &code, int firstIndex, ArgData argData)
{
    int addressIndex = firstIndex + 2;
    int valueIndex = firstIndex + 5;

    int address = OperateNumber(code, addressIndex, argData);
    std::string value = GetStringValue(code, valueIndex, argData);
    argData.stringVariable[address] = value;
}

void SetNumberGlobalVariable(std::vector<int> &code, int firstIndex, ArgData argData)
{
    int addressIndex = firstIndex + 2;
    int valueIndex = firstIndex + 5;

    int address = OperateNumber(code, addressIndex, argData);
    int value = OperateNumber(code, valueIndex, argData);
    //Cpp2ObjCpp::SetNumberGlobalVariable(address, value);
    argData.runner.numberGlobalVariable[address] = value;
}

void SetStringGlobalVariable(std::vector<int> &code, int firstIndex, ArgData argData)
{
    int addressIndex = firstIndex + 2;
    int valueIndex = firstIndex + 5;

    int address = OperateNumber(code, addressIndex, argData);
    const char *value = GetStringValue(code, valueIndex, argData).c_str();
    //Cpp2ObjCpp::SetStringGlobalVariable(address, value);
    argData.runner.stringGlobalVariable[address] = value;
}

void SetNumberTmpVariable(std::vector<int> &code, int firstIndex, ArgData argData)
{
    int addressIndex = firstIndex + 2;
    int valueIndex = firstIndex + 5;

    int address = OperateNumber(code, addressIndex, argData);
    int value = OperateNumber(code, valueIndex, argData);
    argData.tmpNumberVariable[address] = value;
}

void Repeat(std::vector<int> &code, int firstIndex, ArgData argData)
{
    printf("hogehoge\n");
    int processIndex = firstIndex + 5;
    int repeatTimeIndex = firstIndex + 2;
    int repeatTime = GetNumberValue(code, repeatTimeIndex, argData);

    printf("repeat:%d\n", repeatTime);

    for (int i = 0; i < repeatTime; i++)
    {
        Do(code, processIndex, argData);
    }
}

void If(std::vector<int> &code, int firstIndex, ArgData argData)
{
    int processIndex = firstIndex + 5;
    int checkIndex = firstIndex + 2;

    int check = GetNumberValue(code, checkIndex, argData);

    if (check <= 0)
        return;

    Do(code, processIndex, argData);
}

void While(std::vector<int> &code, int firstIndex, ArgData argData)
{
    int processIndex = firstIndex + 5;
    int checkIndex = firstIndex + 2;

    int check = GetNumberValue(code, checkIndex, argData);

    while (check > 0)
    {
        Do(code, processIndex, argData);

        check = GetNumberValue(code, checkIndex, argData);
    }
}

void Do(std::vector<int> &code, int firstIndex, ArgData argData)
{
    int i = firstIndex + 2;
    int codeSize = code[firstIndex + 1];

    while (i - firstIndex + 1 < codeSize)
    {
        RunBlock(code, i, argData);
        i += code[i + 1];
    }
}

void SetUIText(std::vector<int> &code, int firstIndex, ArgData argData)
{
    int uiNameIndex = firstIndex + 2;
    int uiTextIndex = firstIndex + 5;

    int uiName = GetNumberValue(code, uiNameIndex, argData);

    char uiTextStr[1000];
    if (code[uiTextIndex] == CmdID::StringVariableValue || code[uiTextIndex] == CmdID::StringGlobalVariableValue)
    {
        std::string uiText = GetStringValue(code, uiTextIndex, argData);
        snprintf(uiTextStr, 1000, "%s", uiText.c_str());
    }
    else
    {
        int uiText = GetNumberValue(code, uiTextIndex, argData);
        snprintf(uiTextStr, 1000, "%d", uiText);
    }

    Cpp2ObjCpp::SetUIText(uiName, uiTextStr);
}

void IO(std::vector<int> &code, int firstIndex, ArgData argData)
{
    switch (code[firstIndex])
    {
    case CmdID::Print:
        Print(code, firstIndex, argData);
        break;

    default:
        break;
    }
}

void Control(std::vector<int> &code, int firstIndex, ArgData argData)
{
    switch (code[firstIndex])
    {
    case CmdID::Do:
        Do(code, firstIndex, argData);
        break;

    case CmdID::If:
        If(code, firstIndex, argData);
        break;

    case CmdID::Repeat:
        Repeat(code, firstIndex, argData);
        break;

    case CmdID::While:
        While(code, firstIndex, argData);
        break;

    default:
        break;
    }
}

void Variable(std::vector<int> &code, int firstIndex, ArgData argData)
{
    switch (code[firstIndex])
    {
    case CmdID::DeclareIntVariable:
        //数値型変数宣言
        break;

    case CmdID::DeclareStringVariable:
        //文字列型変数宣言
        break;

    case CmdID::AssignIntVariable:
        SetNumberVariable(code, firstIndex, argData);
        break;

    case CmdID::AssignStringVariable:
        SetStringVariable(code, firstIndex, argData);
        break;

    case CmdID::AssignIntGlobalVariable:
        SetNumberGlobalVariable(code, firstIndex, argData);
        break;

    case CmdID::AssignStringGlobalVariable:
        SetStringGlobalVariable(code, firstIndex, argData);
        break;

    case CmdID::AssignIntTmpVariable:
        SetNumberTmpVariable(code, firstIndex, argData);
        break;

    default:
        break;
    }
}

int OperateNumber(std::vector<int> &code, int firstIndex, ArgData argData)
{
    if (code[firstIndex] / 1000 == 3)
    {
        //単体の値の場合
        return GetNumberValue(code, firstIndex, argData);
    }

    int firstValueIndex = firstIndex + 2;
    int secondValueIndex = firstIndex + 5;

    int value = 0;
    int firstValue = GetNumberValue(code, firstValueIndex, argData);
    int secondValue = 0;
    if (code[firstIndex] == CmdID::Not)
        secondValue = 0;
    else
        secondValue = GetNumberValue(code, secondValueIndex, argData);

    switch (code[firstIndex])
    {
    case CmdID::Sum:
        value = firstValue + secondValue;
        break;
    case CmdID::Sub:
        value = firstValue - secondValue;
        break;
    case CmdID::Mul:
        value = firstValue * secondValue;
        break;
    case CmdID::Div:
        value = firstValue / secondValue;
        break;
    case CmdID::Mod:
        value = firstValue % secondValue;
        break;
    case CmdID::Equal:
        value = firstValue == secondValue ? 1 : 0;
        break;
    case CmdID::Inequal:
        value = firstValue != secondValue ? 1 : 0;
        break;
    case CmdID::Bigger:
        value = firstValue > secondValue ? 1 : 0;
        break;
    case CmdID::Lower:
        value = firstValue < secondValue ? 1 : 0;
        break;
    case CmdID::BiggerAndEqual:
        value = firstValue >= secondValue ? 1 : 0;
        break;
    case CmdID::LowerAndEqual:
        value = firstValue <= secondValue ? 1 : 0;
        break;
    case CmdID::And:
        value = (firstValue > 0 && secondValue > 0) ? 1 : 0;
        break;
    case CmdID::Or:
        value = (firstValue > 0 || secondValue > 0) ? 1 : 0;
        break;
    case CmdID::Not:
        value = firstValue > 0 ? 0 : 1;
        break;
    default:
        break;
    }

    return value;
}

std::string OperateString(std::vector<int> &code, int firstIndex, ArgData argData)
{
    std::string value = "";

    return value;
}

void UI(std::vector<int> &code, int firstIndex, ArgData argData)
{
    switch (code[firstIndex])
    {
    case CmdID::SetUIText:
        SetUIText(code, firstIndex, argData);
        break;
    default:
        break;
    }
}

void RunBlock(std::vector<int> &code, int firstIndex, ArgData argData)
{
    switch (code[firstIndex] / 1000)
    {
    case 0:
        break;
    case 1:
        IO(code, firstIndex, argData);
        break;
    case 2:
        Control(code, firstIndex, argData);
        break;
    case 3:
        Variable(code, firstIndex, argData);
        break;
    case 4:
        break;
    case 5:
        UI(code, firstIndex, argData);
        break;
    default:
        break;
    }
}

void Runner::RunCode(int id, Runner &runner) //(std::vector<int> code, int codeSize, std::vector<std::string> stringVariableInitialValue, int stringVariableInitialValueSize)
{
    // 変数
    std::vector<int> numberVariable(100000, 0);
    std::vector<std::string> stringVariable(10000, "");

    std::vector<int> tmpNumberVariable(100000, 0);

    std::vector<int> code = runner.codes[id];

    ArgData argData = {
        numberVariable,
        stringVariable,
        tmpNumberVariable,
        runner,
    };

    //変数初期化
    for (int i = 0; i < runner.stringVariableInitialValues[id].size(); i++)
    {
        stringVariable[i] = runner.stringVariableInitialValues[id][i];
    }

    if (code[1] > code.size())
    {
        return;
    }

    printf("Process started!\n");

    int i = 0;
    while (i < code[1])
    {
        RunBlock(code, i, argData);
        i += code[i + 1];
    }

    printf("Process finished successfully!\n");
}

void Runner::InitRunner(Runner &runner)
{
    runner.numberGlobalVariable = std::vector<int>(100000);
    runner.stringGlobalVariable = std::vector<std::string>(10000);
}
