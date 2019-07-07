#include "cpp.hpp"

void Bytecode2String::ShowBytecodeString(std::vector<int> bytecode)
{
    std::unordered_map<int, std::string> id2str = {
        {CmdID::Push, "Push"},
        {CmdID::CallCppFunc, "CallCppFunc"},
        {CmdID::CallMalletFunc, "CallMalletFunc"},
        {CmdID::SetNumberVariable, "SetNumberVariable"},
        {CmdID::SetStringVariable, "SetStringVariable"},
        {CmdID::PrintNumber, "PrintNumber"},
        {CmdID::PrintString, "PrintString"},
        {CmdID::Jump, "Jump"},
        {CmdID::Return, "Return"},
        {CmdID::NumberType, "Number"},
        {CmdID::StringType, "String"},
        {CmdID::BoolType, "Bool"},
        {CmdID::NumberGlobalType, "NumberGlobal"},
        {CmdID::StringGlobalType, "StringGlobal"},
        {CmdID::BoolGlobalType, "BoolGlobal"},
        {CmdID::NumberTmpType, "NumberTmp"},
        {CmdID::StringTmpType, "StringTmp"},
        {CmdID::BoolTmpType, "BoolTmp"},
        {CmdID::VoidType, "Void"},
        {CmdID::IntType, "Address"},
        {CmdID::EndOfFunc, "EndOfFunc"},
        {CmdID::Add, "+"},
        {CmdID::Sub, "-"},
        {CmdID::Mul, "*"},
        {CmdID::Div, "/"},
        {CmdID::Mod, "%"},
        {CmdID::Equal, "=="},
        {CmdID::NotEqual, "!="},
        {CmdID::GreaterThan, ">"},
        {CmdID::LessThan, "<"},
        {CmdID::GreaterThanOrEqual, ">="},
        {CmdID::LessThanOrEqual, "<="},
        {CmdID::And, "&&"},
        {CmdID::Or, "||"},
        {CmdID::Not, "!"},
    };

    std::string bytecodeString = "";

    int i = 0;
    while (i < bytecode.size())
    {
        if (bytecode[i] != CmdID::CodeBegin)
        {
            printf("This bytecode is broken!\n");
            return;
        }

        bytecodeString += "#" + std::to_string(i) + ": ";

        if (bytecode[i + 1] == CmdID::Push)
        {
            bytecodeString += id2str[bytecode[i + 1]] + " ";
            bytecodeString += id2str[bytecode[i + 3]] + " ";
            bytecodeString += std::to_string(bytecode[i + 4]) + " ";
            i += 5;
        }
        else
        {
            if (id2str[bytecode[i + 1]] == "")
            {
                bytecodeString += "Unknown Code";
            }
            else
            {
                bytecodeString += id2str[bytecode[i + 1]];
            }

            i += 3;
        }

        bytecodeString += "\n";
    }

    printf("\n%s\n", bytecodeString.c_str());
}