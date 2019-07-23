//
//  CppFuncManager.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/10.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "cpp.hpp"

CppFunc::CppFunc()
{
    cppFuncData = {{"testFunc", funcIDs::TEST_FUNC, NUMBER_TYPE, 1}};
}

void Convert::ListCppFunction()
{
    CppFunc cppFunc;

    for (auto func : cppFunc.cppFuncData)
    {
        cppFuncNames.insert(func.funcName);

        funcData newFuncData;

        newFuncData.funcName = func.funcName;
        newFuncData.argNum = func.argNum;

        cppFuncIDs[newFuncData] = func.funcID;
        isCppFuncExists[newFuncData] = true;
    }
}

double testFunc(var a)
{
    double a_;
    if (std::holds_alternative<double>(a))
        a_ = std::get<double>(a);
    else
        a_ = 0;

    return a_ * 2;
}

var Run::CallCppFunc(int funcID, std::vector<var> args)
{
    var returnStackData;

    if (funcID == 0)
    {
        returnStackData = testFunc(args[0]);
    }

    return returnStackData;
}
