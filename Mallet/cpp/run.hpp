
//
//  run.hpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/06/24.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#ifndef run_h
#define run_h

#include "common.hpp"
#include "cast.hpp"
#include "cpp_func_manager.hpp"

class Run
{
public:
    void Terminate();

    void InitRunner(std::string codeDataStr);

    var RunCode(int funcID, std::vector<var> args);

    Run();

private:
    bool terminate;

    CppFuncManager cppFuncManager;

    std::vector<int> memorySize;

    std::vector<var> globalVariable;

    int globalVariableNum;

    std::vector<int> bytecode;

    std::vector<var> variableInitialValues;

    std::vector<int> funcStartIndexes;
    std::vector<std::vector<int>> argAddresses;

    std::vector<int> funcTypes;

    var CallCppFunc(int funcID, std::vector<var> &args);
};

#endif /* run_h */
