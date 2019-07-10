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

enum
{
    CODE_BEGIN = -1000000007,
    PUSH = 0,
    POP,
    INT_TYPE,
    CALL_CPP_FUNC,
    CALL_MALLET_FUNC,
    SET_NUMBER_VARIABLE,
    SET_STRING_VARIABLE,
    PRINT_NUMBER,
    PRINT_STRING,
    JUMP,
    ERROR,
    PUSH_TRUE,
    PUSH_FALSE,
    RETURN,
    END_OF_FUNC,

    // Type
    NUMBER_TYPE,
    STRING_TYPE,
    BOOL_TYPE,
    NUMBER_GLOBAL_TYPE,
    STRING_GLOBAL_TYPE,
    BOOL_GLOBAL_TYPE,
    VOID_TYPE,
    NUMBER_TMP_TYPE,
    STRING_TMP_TYPE,
    BOOL_TMP_TYPE,
    NUMBER_ADDRESS_TYPE,
    STRING_ADDRESS_TYPE,
    BOOL_ADDRESS_TYPE,
    STRING_FUNC_TYPE,

    // Operator
    ADD = 1024,
    SUB,
    MUL,
    DIV,
    MOD,
    EQUAL,
    NOT_EQUAL,
    GREATER_THAN,
    LESS_THAN,
    GREATER_THAN_OR_EQUAL,
    LESS_THAN_OR_EQUAL,
    AND,
    OR,
    NOT,
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
    std::vector<int> numberMemorySize;
    std::vector<int> stringMemorySize;
    std::vector<int> boolMemorySize;

    std::unordered_map<std::string, int> numberGlobalVariableAddress;
    std::unordered_map<std::string, int> stringGlobalVariableAddress;
    std::unordered_map<std::string, int> boolGlobalVariableAddress;

    int numberGlobalVariableNum;
    int stringGlobalVariableNum;
    int boolGlobalVariableNum;

    std::unordered_map<std::string, int> numberVariableAddress;
    std::vector<int> numberVariableNums;
    int numberVariableNum;

    std::unordered_map<std::string, int> stringVariableAddress;
    std::vector<int> stringVariableNums;
    int stringVariableNum;

    std::unordered_map<std::string, int> boolVariableAddress;
    std::vector<int> boolVariableNums;
    int boolVariableNum;

    std::unordered_map<int, double> numberVariableInitialValue;
    std::unordered_map<int, std::string> stringVariableInitialValue;

    std::vector<std::vector<int>> funcArgAddresses;
    std::vector<int> funcStartIndexes;
    std::vector<int> funcBytecodeStartIndexes;

    std::vector<std::string> code;

    std::vector<std::vector<int>> bytecodes;
    std::unordered_map<std::string, int> uiName;

    std::vector<int> funcTypes;

    std::string ConvertCodeToJson(std::string codeStr);

    std::vector<int> bytecode;
    int bytecodeIndex;
    int bytecodeSize;

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

    void AddPushCode(int type, int address, bool absolute);

    void AddPushTrueCode();

    void AddPushFalseCode();

    void AddPush0Code();

    void AddPush1Code();

    int ConvertValue(const int firstCodeIndex, const bool convert);

    formulaData ConvertFormula(const int firstCodeIndex, int operatorNumber, const bool convert);

    int ConvertCodeBlock(const int firstCodeIndex, const int funcID);

    int ConvertFunc(const int firstCodeIndex, const bool convert);

    void DeclareConstant(const int firstCodeIndex);

    formulaData GetFormulaSize(const int firstCodeIndex, int operatorNumber);

    int GetFuncSize(const int firstCodeIndex);

    int DeclareVariable(const int type, const std::string name, const bool isGlobal);

    void ListFunction();

    void ListCppFunction();

    void InitConverter();

    void ClearLocalVariable();

    int TypeName2ID(const std::string typeName);

    std::string ID2TypeName(const int typeID);

    int LocalType2GlobalType(const int typeID);

    int Type2AddressType(const int typeID);

    std::set<std::string> symbol = {"(", ")", "{", "}", ">", "<", "=", "+", "-", "*", "/", "%", "&", "|", "!", ":", ",", "\""};
    std::set<std::string> doubleSymbol = {"==", "!=", ">=", "<=", "&&", "||"};
    std::set<std::string> reservedWord = {"print", "var", "repeat", "while", "if", "else", "SetUIText", "number", "string", "bool"};
    std::set<std::string> typeName = {"void", "number", "string", "bool"};
    std::set<std::string> funcNames;
    std::map<funcData, int> funcIDs;
    std::map<funcData, bool> isFuncExists;
    std::vector<std::vector<int>> funcArgTypes;
    std::vector<std::vector<std::string>> funcArgOriginalVariableNames;

    std::set<std::string> cppFuncNames;
    std::map<funcData, int> cppFuncIDs;
    std::map<funcData, bool> isCppFuncExists;

    std::unordered_map<std::string, int> variableType;
    std::unordered_map<std::string, int> globalVariableType;
    std::unordered_map<std::string, bool> isGlobalVariable;
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

    typedef struct
    {
        int type;
        double numberValue;
        std::string stringValue;
        bool boolValue;
        int address;
    } funcStackData;

    std::vector<int> numberMemorySize;
    std::vector<int> stringMemorySize;
    std::vector<int> boolMemorySize;

    std::vector<double> numberGlobalVariable;
    std::vector<std::string> stringGlobalVariable;
    std::vector<bool> boolGlobalVariable;

    int numberGlobalVariableNum;
    int stringGlobalVariableNum;
    int boolGlobalVariableNum;

    std::vector<int> bytecode;
    std::vector<double> numberVariableInitialValues;
    std::vector<std::string> stringVariableInitialValues;
    std::vector<bool> boolVariableInitialValues;

    std::vector<int> funcStartIndexes;
    std::vector<std::vector<int>> argAddresses;

    std::vector<int> funcTypes;

    funcStackData RunCode(int funcID, std::vector<funcStackData> args);

    funcStackData CallCppFunc(int funcID, std::vector<funcStackData> args);

    void InitRunner(Runner2 &runner);

    //void InitRunner(std::vector<std::vector<int>> codes, std::vector<std::vector<std::string>> stringVariableInitialValues);
};

class Bytecode2String
{
public:
    void ShowBytecodeString(std::vector<int> bytecode);
};

class CppFunc
{
    typedef struct
    {
        std::string funcName;

        int funcID;

        int funcType;

        std::vector<int> argTypes;

    } funcData;

    struct funcIDs
    {
        static constexpr int TEST_FUNC = 0;
    };

public:
    std::vector<funcData> cppFuncData;

    CppFunc();
};

#endif /* cpp_hpp */
