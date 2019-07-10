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
    cppFuncData = {{"testFunc", funcIDs::TEST_FUNC, NUMBER_TYPE, {NUMBER_TYPE}}};
}

void Convert::ListCppFunction()
{
    CppFunc cppFunc;

    for (auto func : cppFunc.cppFuncData)
    {
        cppFuncNames.insert(func.funcName);

        funcData newFuncData;

        newFuncData.funcName = func.funcName;
        newFuncData.argTypes = func.argTypes;

        cppFuncIDs[newFuncData] = func.funcID;
        isCppFuncExists[newFuncData] = true;
    }
}

double testFunc(double a)
{
    return a * 2;
}

Run::funcStackData Run::CallCppFunc(int funcID, std::vector<funcStackData> args)
{
    funcStackData returnStackData;

    if (funcID == 0)
    {
        returnStackData.type = NUMBER_TYPE;
        returnStackData.numberValue = testFunc(args[0].numberValue);
    }

    return returnStackData;
}
