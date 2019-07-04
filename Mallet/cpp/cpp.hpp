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
#include <array>
#include <map>
#include <unordered_map>

class CmdID
{
public:
    //* New
    static constexpr int CodeBegin = -90000;
    static constexpr int Push = 90000;
    static constexpr int Pop = 90001;
    static constexpr int AddressType = 90012;
    static constexpr int CallCppFunc = 90004;
    static constexpr int CallMalletFunc = 90005;
    static constexpr int SetNumberVariable = 90006;
    static constexpr int SetStringVariable = 90007;

    static constexpr int PrintNumber = 90008;
    static constexpr int PrintString = 90009;

    static constexpr int Jump = 90010;
    static constexpr int Call = 90013;

    static constexpr int Error = 90014;

    static constexpr int PushTrue = 90015;
    static constexpr int PushFalse = 90016;

    static constexpr int NumberType = 80000;
    static constexpr int StringType = 80001;
    static constexpr int BoolType = 80002;
    static constexpr int NumberGlobalType = 80003;
    static constexpr int StringGlobalType = 80004;
    static constexpr int BoolGlobalType = 80005;
    static constexpr int VoidType = 80006;

    static constexpr int NumberTmpType = 80007;
    static constexpr int StringTmpType = 80008;
    static constexpr int BoolTmpType = 80009;

    //* IO
    static constexpr int Print = 10000;
    static constexpr int Input = 10001;

    //* Control
    static constexpr int Do = 20000;
    static constexpr int If = 20001;
    static constexpr int Repeat = 20002;
    static constexpr int While = 20003;

    //* Variable
    static constexpr int DeclareIntVariable = 30000;
    static constexpr int AssignIntVariable = 30001;
    static constexpr int IntVariableValue = 30002;
    static constexpr int IntValue = 30003;
    static constexpr int StringVariableValue = 30004;
    static constexpr int DeclareStringVariable = 30006;
    static constexpr int AssignStringVariable = 30007;

    static constexpr int DeclareIntGlobalVariable = 31000;
    static constexpr int AssignIntGlobalVariable = 31001;
    static constexpr int IntGlobalVariableValue = 31002;
    static constexpr int StringGlobalVariableValue = 31004;
    static constexpr int DeclareStringGlobalVariable = 31006;
    static constexpr int AssignStringGlobalVariable = 31007;

    static constexpr int AssignIntTmpVariable = 32001;
    static constexpr int IntTmpVariableValue = 32002;

    //* Operation
    static constexpr int Add = 40000;
    static constexpr int Sub = 40001;
    static constexpr int Mul = 40002;
    static constexpr int Div = 40003;
    static constexpr int Mod = 40004;
    static constexpr int Equal = 40005;
    static constexpr int NotEqual = 40006;
    static constexpr int GreaterThan = 40007;
    static constexpr int LessThan = 40008;
    static constexpr int GreaterThanOrEqual = 40009;
    static constexpr int LessThanOrEqual = 40010;
    static constexpr int And = 40011;
    static constexpr int Or = 40012;
    static constexpr int Not = 40013;

    //* UI
    static constexpr int SetUIText = 50000;
};

class Converter
{
public:
    std::unordered_map<std::string, int> numberGlobalVariableAddress;
    std::unordered_map<std::string, int> stringGlobalVariableAddress;

    int numberGlobalVariableNum;
    int stringGlobalVariableNum;

    int SplitCode(std::string originalCodeStr, std::string code[], int codeMaxSize,
                  std::set<std::string> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord);

    std::string RefactorCode(std::string code);
    std::string ConvertCodeToJson(std::string codeStr, bool isDefinitionOfGlobalVariable, std::unordered_map<std::string, int> uiName, Converter &converter);
};

class Converter2
{
public:
    std::unordered_map<std::string, int> numberGlobalVariableAddress;
    std::unordered_map<std::string, int> stringGlobalVariableAddress;

    int numberGlobalVariableNum;
    int stringGlobalVariableNum;

    std::unordered_map<int, double> numberVariableInitialValue;
    std::unordered_map<int, std::string> stringVariableInitialValue;

    std::vector<std::string> code;

    std::vector<int> bytecode;
    int bytecodeIndex;
    int bytecodeSize;
    std::unordered_map<std::string, int> uiName;

    std::string ConvertCodeToJson(std::string codeStr);

    void ListFunction();

private:
    struct funcData
    {
        std::string funcName;
        std::vector<int> argTypes;

        bool operator<(const funcData &value) const
        {
            return std::tie(funcName, argTypes) < std::tie(value.funcName, value.argTypes);
        }
    };

    struct formulaData
    {
        int codeSize;
        int type;
    };

    void AddCode(int code);
    void AddCmdCode(int code, int argNum);
    void AddPushCode(int type, int address);
    void AddPushTrueCode();
    void AddPushFalseCode();
    void AddPush0Code();
    void AddPush1Code();

    int ConvertValue(const int firstCodeIndex);
    formulaData ConvertFormula(const int firstCodeIndex, int operatorNumber);
    int ConvertCodeBlock(const int firstCodeIndex);
    int ConvertFunc(const int firstCodeIndex);

    void InitConverter();

    int TypeName2ID(std::string typeName);

    //TODO: Rename
    std::set<std::string> symbol;
    std::set<std::string> doubleSymbol;
    std::set<std::string> reservedWord;
    std::set<std::string> typeName;
    std::set<std::string> funcName;
    std::map<funcData, int> funcID;
    std::vector<int> funcType;

    std::unordered_map<std::string, int> numberVariableAddress;
    int numberVariableNum;
    std::unordered_map<std::string, int> stringVariableAddress;
    int stringVariableNum;
    std::unordered_map<std::string, int> boolVariableAddress;
    int boolVariableNum;

    std::unordered_map<std::string, int> variableType;
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

class Runner2
{
public:
    typedef struct
    {
        int type;
        int address;
    } stackData;

    std::vector<double> numberGlobalVariable;
    std::vector<std::string> stringGlobalVariable;
    std::vector<bool> boolGlobalVariable;

    std::vector<std::vector<int>> bytecodes;
    std::vector<std::vector<double>> numberVariableInitialValues;
    std::vector<std::vector<std::string>> stringVariableInitialValues;
    std::vector<std::vector<bool>> boolVariableInitialValues;

    stackData RunCode(int funcID, std::vector<stackData> arg, Runner2 &runner);

    void InitRunner(Runner2 &runner);

    //void InitRunner(std::vector<std::vector<int>> codes, std::vector<std::vector<std::string>> stringVariableInitialValues);
};

class Bytecode2String
{
public:
    void ShowBytecodeString(std::vector<int> bytecode);
};

#endif /* cpp_hpp */
