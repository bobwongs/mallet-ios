//
//  cpp_func_manager.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/10.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "cpp_func_manager.hpp"

#ifndef TEST
#include "./lib/ui/ui.hpp"
#include "./lib/time/time.hpp"
#endif

CppFuncManager::CppFuncManager()
{
#ifndef TEST
    //ui.hpp
    addCppFunc(setUIPositionX, "setUIPositionX", {ArgType::UI, ArgType::VALUE});
    addCppFunc(setUIPositionY, "setUIPositionY", {ArgType::UI, ArgType::VALUE});
    addCppFunc(setUIWidth, "setUIWidth", {ArgType::UI, ArgType::VALUE});
    addCppFunc(setUIHeight, "setUIHeight", {ArgType::UI, ArgType::VALUE});
    addCppFunc(setUIFontColor, "setUIFontColor", {ArgType::UI, ArgType::VALUE});
    addCppFunc(setUIFontSize, "setUIFontSize", {ArgType::UI, ArgType::VALUE});
    addCppFunc(setUITextAlignment, "setUITextAlignment", {ArgType::UI, ArgType::VALUE});
    addCppFunc(setUIText, "setUIText", {ArgType::UI, ArgType::VALUE});
    addCppFunc(setUIValue, "setUIValue", {ArgType::UI, ArgType::VALUE});
    addCppFunc(getUIValue, "getUIValue", {ArgType::UI});

    //time.hpp
    addCppFunc(sleepForSeconds, "sleep", {ArgType::VALUE});
#endif
}

void CppFuncManager::addCppFunc(var (*func)(std::vector<var> &args), std::string funcName, std::vector<ArgType> argType)
{
    cppFunc.push_back({func, funcName, argType});
}
