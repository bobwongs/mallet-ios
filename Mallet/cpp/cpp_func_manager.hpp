//
//  cpp_func_manager.hpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/25.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#ifndef cpp_func_manager_h
#define cpp_func_manager_h

#include "common.hpp"
#include "cast.hpp"

class CppFuncManager
{
public:
    typedef struct
    {
        var (*func)(std::vector<var> &args);

        std::string funcName;

        std::vector<ArgType> argType;

    } funcData;

    std::vector<funcData> cppFunc;

    CppFuncManager();

private:
    void addCppFunc(var (*func)(std::vector<var> &args), std::string funcName, std::vector<ArgType> argType);
};

#endif /* cpp_func_manager_h */
