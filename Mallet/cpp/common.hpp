//
//  common.hpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/25.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#ifndef common_h
#define common_h

#include <stdio.h>
#include <map>
#include <iomanip>
#include <set>
#include <sstream>
#include <string>
#include <unordered_map>
#include <variant>
#include <vector>

enum class ControlCode
{
    NONE,
    CODE_BEGIN,
    END_OF_FUNC,
};

enum
{
    CODE_BEGIN = -1000000007,
    PUSH = 0,
    PUSH_ADDRESS,
    POP,
    INT_TYPE,
    CALL_CPP_FUNC,
    CALL_MALLET_FUNC,
    SET_NUMBER_VARIABLE,
    SET_STRING_VARIABLE,
    SET_VARIABLE,
    PRINT_NUMBER,
    PRINT_STRING,
    JUMP,
    ERROR,
    PUSH_TRUE,
    PUSH_FALSE,
    RETURN,
    END_OF_FUNC,

    // Type
    VARIABLE,
    GLOBAL_VARIABLE,
    STRING_TYPE,
    BOOL_TYPE,
    NUMBER_TYPE,
    NUMBER_GLOBAL_TYPE,
    STRING_GLOBAL_TYPE,
    BOOL_GLOBAL_TYPE,
    VOID_TYPE,
    NUMBER_TMP_TYPE,
    STRING_TMP_TYPE,
    BOOL_TMP_TYPE,
    NUMBER_ADDRESS_TYPE,
    STRING_ADDRESS_TYPE,
    BOOL_ADDRESS_TYPE,
    STRING_FUNC_TYPE,

    // Operator
    ADD = 1024,
    SUB,
    MUL,
    DIV,
    MOD,
    EQUAL,
    NOT_EQUAL,
    GREATER_THAN,
    LESS_THAN,
    GREATER_THAN_OR_EQUAL,
    LESS_THAN_OR_EQUAL,
    AND,
    OR,
    NOT,
};

typedef std::variant<ControlCode, int, double, bool, std::string> var;

#endif /* common_h */
