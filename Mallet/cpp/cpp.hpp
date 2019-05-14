//
//  cpp.hpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#ifndef cpp_hpp
#define cpp_hpp

#include <set>
#include <string>
#include <vector>
#include <unordered_map>

class CmdID
{
public:
    //* IO
    static constexpr int Print = 1000;
    static constexpr int Input = 1001;

    //* Control
    static constexpr int Do = 2000;
    static constexpr int If = 2001;
    static constexpr int Repeat = 2002;
    static constexpr int While = 2003;

    //* Variable
    static constexpr int DeclareIntVariable = 3000;
    static constexpr int AssignIntVariable = 3001;
    static constexpr int IntVariableValue = 3002;
    static constexpr int IntValue = 3003;
    static constexpr int StringVariableValue = 3004;
    static constexpr int DeclareStringVariable = 3006;
    static constexpr int AssignStringVariable = 3007;

    static constexpr int DeclareIntGlobalVariable = 3100;
    static constexpr int AssignIntGlobalVariable = 3101;
    static constexpr int IntGlobalVariableValue = 3102;
    static constexpr int StringGlobalVariableValue = 3104;
    static constexpr int DeclareStringGlobalVariable = 3106;
    static constexpr int AssignStringGlobalVariable = 3107;

    //* Operation
    static constexpr int Sum = 4000;
    static constexpr int Sub = 4001;
    static constexpr int Mul = 4002;
    static constexpr int Div = 4003;
    static constexpr int Mod = 4004;
    static constexpr int Equal = 4005;
    static constexpr int Bigger = 4006;
    static constexpr int Lower = 4007;
    static constexpr int Not = 4008;
    static constexpr int Inequal = 4009;

    //* UI
    static constexpr int SetUIText = 5000;
};

class Converter
{
public:
    std::unordered_map<std::string, int> numberGlobalVariableAddress;
    std::unordered_map<std::string, int> stringGlobalVariableAddress;

    int numberGlobalVariableNum;
    int stringGlobalVariableNum;

    int SplitCode(std::string originalCodeStr, std::string code[], int codeMaxSize,
                  std::set<char> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord);

    std::string RefactorCode(std::string code);

    std::string ConvertCodeToJson(std::string codeStr, bool isDefinitionOfGlobalVariable, Converter &converter);
};

class Runner
{
public:
    std::vector<int> numberGlobalVariable;
    std::vector<std::string> stringGlobalVariable;

    std::vector<std::vector<int>> codes;
    std::vector<std::vector<std::string>> stringVariableInitialValues;

    void RunCode(int id, Runner &runner);

    void InitRunner(Runner &runner);

    //void InitRunner(std::vector<std::vector<int>> codes, std::vector<std::vector<std::string>> stringVariableInitialValues);
};

#endif /* cpp_hpp */
