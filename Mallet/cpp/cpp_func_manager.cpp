//
//  cpp_func_manager.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/10.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "cpp_func_manager.hpp"

var testFunc(std::vector<var> &args)
{
    double a_;
    if (std::holds_alternative<double>(args[0]))
        a_ = std::get<double>(args[0]);
    else
        a_ = 0;

    return a_ * 2;
}

var sqrt_(std::vector<var> &args)
{
    double a_;
    if (std::holds_alternative<double>(args[0]))
        a_ = std::get<double>(args[0]);
    else
        a_ = 0;

    return sqrt(a_);
}

var square(std::vector<var> &args)
{
    double a_;
    if (std::holds_alternative<double>(args[0]))
        a_ = std::get<double>(args[0]);
    else
        a_ = 0;

    return a_ * a_;
}

CppFuncManager::CppFuncManager()
{
    addCppFunc(testFunc, "testFunc", 1);
    addCppFunc(sqrt_, "sqrt", 1);
    addCppFunc(square, "square", 1);
}

void CppFuncManager::addCppFunc(var (*func)(std::vector<var> &args), std::string funcName, int argNum)
{
    cppFunc.push_back({func, funcName, argNum});
    cppFuncID[funcName] = argNum;
}
