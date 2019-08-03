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
    typedef struct
    {
        var (*func)(std::vector<var> &args);

        std::string funcName;

        int argNum;

    } funcData;

public:
    std::unordered_map<std::string, int> cppFuncID;

    std::vector<funcData> cppFunc;

    CppFuncManager();

private:
    void addCppFunc(var (*func)(std::vector<var> &args), std::string funcName, int argNum);
};

#endif /* cpp_func_manager_h */
