//
//  cpp_func_manager.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/10.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "cpp_func_manager.hpp"

#if defined(DEBUG)
#include "./lib/ui/ui.hpp"
#include "./lib/time/time.hpp"
#endif

CppFuncManager::CppFuncManager()
{
#if defined(DEBUG)
    //ui.hpp
    addCppFunc(setUIPositionX, "setUIPositionX", 2);
    addCppFunc(setUIPositionY, "setUIPositionY", 2);
    addCppFunc(setUIText, "setUIText", 2);
    addCppFunc(getUIText, "getUIText", 1);

    //time.hpp
    addCppFunc(sleepForSeconds, "sleep", 1);
#endif
}

void CppFuncManager::addCppFunc(var (*func)(std::vector<var> &args), std::string funcName, int argNum)
{
    cppFunc.push_back({func, funcName, argNum});
    cppFuncID[funcName] = argNum;
}
