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
    static const int Print = 1000;
    static const int Input = 1001;

    //* Control
    static const int Do = 2000;
    static const int If = 2001;
    static const int Repeat = 2002;
    static const int While = 2003;

    //* Variable
    static const int DeclareIntVariable = 3000;
    static const int AssignIntVariable = 3001;
    static const int IntVariableValue = 3002;
    static const int IntValue = 3003;
    static const int StringVariableValue = 3004;
    static const int DeclareStringVariable = 3006;
    static const int AssignStringVariable = 3007;

    static const int DeclareIntGlobalVariable = 3100;
    static const int AssignIntGlobalVariable = 3101;
    static const int IntGlobalVariableValue = 3102;
    static const int StringGlobalVariableValue = 3104;
    static const int DeclareStringGlobalVariable = 3106;
    static const int AssignStringGlobalVariable = 3107;

    //* Operation
    static const int Sum = 4000;
    static const int Sub = 4001;
    static const int Mul = 4002;
    static const int Div = 4003;
    static const int Mod = 4004;
    static const int Equal = 4005;
    static const int Bigger = 4006;
    static const int Not = 4007;
    static const int Inequal = 4008;

    //* UI
    static const int SetUIText = 5000;
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
