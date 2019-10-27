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

enum class ArgType
{
    VALUE,
    VAR,
    LIST,
    UI,
};

enum
{
    CODE_BEGIN = -1000000007,
    PUSH = 0,
    PUSH_GLOBAL_VARIABLE,
    PUSH_PERSISTENT_VARIABLE,
    PUSH_CLOUD_VARIABLE,
    PUSH_ADDRESS,

    //Function
    CALL_CPP_FUNC,
    CALL_MALLET_FUNC,

    //Variable
    SET_VARIABLE,
    SET_GLOBAL_VARIABLE,
    SET_PERSISTENT_VARIABLE,
    SET_CLOUD_VARIABLE,

    //List
    SET_PERSISTENT_LIST,
    SET_CLOUD_LIST,
    ADD_TO_CLOUD_LIST,
    INIT_LIST,
    ADD_LIST,
    INSERT_LIST,
    REMOVE_LIST,
    GET_LIST,
    GET_LIST_SIZE,
    SET_LIST_UI,

    PRINT_NUMBER,
    PRINT_STRING,
    JUMP,
    ERROR,
    RETURN,
    END_OF_FUNC,

    // Type
    VARIABLE,
    GLOBAL_VARIABLE,
    PERSISTENT_VARIABLE,
    CLOUD_VARIABLE,

    LIST,
    GLOBAL_LIST,
    PERSISTENT_LIST,
    CLOUD_LIST,

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
    CONNECT_STRING,
    OPERATOR_END,
};

typedef std::variant<ControlCode, int, double, bool, std::string> var;
typedef std::vector<var> list;

#endif /* common_h */