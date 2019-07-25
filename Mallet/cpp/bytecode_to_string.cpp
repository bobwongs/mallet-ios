#include "bytecode_to_string.hpp"

void Bytecode2String::ShowBytecodeString(std::vector<int> bytecode)
{
    std::unordered_map<int, std::string> id2str = {
        {PUSH, "Push"},
        {PUSH_ADDRESS, "PushAddress"},
        {CALL_CPP_FUNC, "CallCppFunc"},
        {CALL_MALLET_FUNC, "CallMalletFunc"},
        {SET_NUMBER_VARIABLE, "SetNumberVariable"},
        {SET_STRING_VARIABLE, "SetStringVariable"},
        {SET_VARIABLE, "SetVariable"},
        {PRINT_NUMBER, "PrintNumber"},
        {PRINT_STRING, "PrintString"},
        {JUMP, "Jump"},
        {RETURN, "Return"},
        {NUMBER_TYPE, "Number"},
        {STRING_TYPE, "String"},
        {BOOL_TYPE, "Bool"},
        {NUMBER_GLOBAL_TYPE, "NumberGlobal"},
        {STRING_GLOBAL_TYPE, "StringGlobal"},
        {BOOL_GLOBAL_TYPE, "BoolGlobal"},
        {NUMBER_TMP_TYPE, "NumberTmp"},
        {STRING_TMP_TYPE, "StringTmp"},
        {BOOL_TMP_TYPE, "BoolTmp"},
        {VOID_TYPE, "Void"},
        {INT_TYPE, "Int"},
        {NUMBER_ADDRESS_TYPE, "NumberAddress"},
        {STRING_ADDRESS_TYPE, "StringAddress"},
        {BOOL_ADDRESS_TYPE, "BoolAddress"},
        {END_OF_FUNC, "\x1b[45m  EndOfFunc  \x1b[49m"},
        {ADD, "+"},
        {SUB, "-"},
        {MUL, "*"},
        {DIV, "/"},
        {MOD, "%"},
        {EQUAL, "=="},
        {NOT_EQUAL, "!="},
        {GREATER_THAN, ">"},
        {LESS_THAN, "<"},
        {GREATER_THAN_OR_EQUAL, ">="},
        {LESS_THAN_OR_EQUAL, "<="},
        {AND, "&&"},
        {OR, "||"},
        {NOT, "!"},
    };

    constexpr int pushCodeSize = 5;
    constexpr int defaultCodeSize = 3;

    std::string bytecodeString = "";

    int i = 0;
    while (i < bytecode.size())
    {
        if (bytecode[i] != CODE_BEGIN)
        {
            printf("This bytecode is broken!\n");
            return;
        }

        bytecodeString += "\x1b[32m#" + std::to_string(i) + ":\x1b[39m ";

        if (bytecode[i + 1] == PUSH || bytecode[i + 1] == PUSH_ADDRESS)
        {
            bytecodeString += "\x1b[33m" + id2str[bytecode[i + 1]] + "\x1b[39m ";
            //bytecodeString += "\x1b[35m" + id2str[bytecode[i + 3]] + "\x1b[39m ";
            bytecodeString += std::to_string(bytecode[i + 3]) + " ";

            if (bytecode[i + 4] > 0)
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