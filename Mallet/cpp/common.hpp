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
    PUSH_GLOBAL_VARIABLE,
    PUSH_ADDRESS,

    //Function
    CALL_CPP_FUNC,
    CALL_MALLET_FUNC,

    //Variable
    SET_VARIABLE,
    SET_SHARED_VARIABLE,

    //List
    INIT_LIST,
    ADD_LIST,
    INSERT_LIST,
    REMOVE_LIST,
    GET_LIST,

    PRINT_NUMBER,
    PRINT_STRING,
    JUMP,
    ERROR,
    RETURN,
    END_OF_FUNC,

    // Type
    VARIABLE,
    GLOBAL_VARIABLE,
    SHARED_VARIABLE,
    LIST,
    GLOBAL_LIST,
    SHARED_LIST,

    // Operator
    OPERATOR_BEGIN,
    ADD,
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
    OPERATOR_END,
};

typedef std::variant<ControlCode, int, double, bool, std::string> var;

#endif /* common_h */
