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
        {CmdID::IntType, "Int"},
        {CmdID::NumberAddressType, "NumberAddress"},
        {CmdID::StringAddressType, "StringAddress"},
        {CmdID::BoolAddressType, "BoolAddress"},
        {CmdID::EndOfFunc, "\x1b[45m  EndOfFunc  \x1b[49m"},
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

    constexpr int pushCodeSize = 6;
    constexpr int defaultCodeSize = 3;

    std::string bytecodeString = "";

    int i = 0;
    while (i < bytecode.size())
    {
        if (bytecode[i] != CmdID::CodeBegin)
        {
            printf("This bytecode is broken!\n");
            return;
        }

        bytecodeString += "\x1b[32m#" + std::to_string(i) + ":\x1b[39m ";

        if (bytecode[i + 1] == CmdID::Push)
        {
            bytecodeString += "\x1b[33m" + id2str[bytecode[i + 1]] + "\x1b[39m ";
            bytecodeString += "\x1b[35m" + id2str[bytecode[i + 3]] + "\x1b[39m ";
            bytecodeString += std::to_string(bytecode[i + 4]) + " ";

            if (bytecode[i + 5] > 0 && (bytecode[i + 3] != CmdID::IntType))
                bytecodeString += "\x1b[36mAbsolute\x1b[39m";

            i += pushCodeSize;
        }
        else
        {
            if (id2str[bytecode[i + 1]] == "")
            {
                bytecodeString += "\x1b[33mUnknown Code\x1b[39m";
            }
            else
            {
                bytecodeString += "\x1b[33m" + id2str[bytecode[i + 1]] + "\x1b[39m";
            }

            i += defaultCodeSize;
        }

        bytecodeString += "\n";
    }

    printf("\n%s\n", bytecodeString.c_str());
}