//
//  convert.hpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/06/28.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#ifndef convert_hpp
#define convert_hpp

#include "common.hpp"
#include "cpp_func_manager.hpp"
#include "bytecode_to_string.hpp"

static const std::set<std::string> symbol = {"(", ")", "{", "}", "[", "]", ">", "<", "=", "+", "-", "*", "/", "%", "&", "|", "!", ":", ",", "~", "\""};
static const std::set<std::string> doubleSymbol = {"==", "!=", ">=", "<=", "&&", "||"};
static const std::set<std::string> reservedWord = {"print", "var", "repeat", "while", "if", "else", "SetUIText", "number", "string", "bool"};

class Convert
{

public:
    enum variableType
    {
        normal,
        persistent,
        cloud
    };

    struct variableData
    {
        variableType type;
        std::string name;
        std::string value;
    };

    struct listData
    {
        variableType type;
        std::string name;
        std::vector<std::string> value;
        int uiID;
    };

    static std::vector<variableData> getGlobalVariables(const std::string codeStr);

    static std::vector<listData> getGlobalLists(const std::string codeStr);

    std::string ConvertCode(std::string codeStr);

    static std::vector<std::string> SplitCode(std::string codeStr);

    std::vector<int> bytecode;

private:
    struct funcData
    {
        std::string funcName;
        std::vector<ArgType> argType;

        /*
        bool operator<(const funcData &value) const
        {
            return funcName < value.funcName;
        }
        */
    };

    struct formulaData
    {
        int codeSize;
        int type;
    };

    struct variableTypeInfo
    {
        bool isGlobalVariable = false;
        bool isCloudVariable = false;
        bool isPersistentVariable = false;
        bool isUI = false;
        bool isList = false;

        int nameAddress;
        int uiID;

        /*
        variableTypeInfo(
            bool isGlobalVariable,
            bool isCloudVariable,
            bool isPersistentVariable,
            bool isUI,
            int nameAddress,
            int uiID) : isGlobalVariable(isGlobalVariable),
                        isCloudVariable(isCloudVariable),
                        isPersistentVariable(isPersistentVariable),
                        isUI(isUI),
                        nameAddress(nameAddress),
                        uiID(uiID) {}
                        */
    };

    void AddCode(int code);

    void AddCmdCode(int code, int argNum);

    void AddPushCode(int address, bool absolute);

    void AddPushGlobalCode(int address);

    void AddPushPersistentCode(int address);

    void AddPushCloudCode(int address);

    void AddPushAddressCode(int address, bool absolute);

    void AddPushTrueCode();

    void AddPushFalseCode();

    void AddPush0Code();

    void AddPush1Code();

    static std::string RemoveComments(std::string codeStr);

    void ConvertValue(const int firstCodeIndex, const bool convert);

    int ConvertListElement(const int firstCodeIndex, const bool convert);

    int ConvertFormula(const int firstCodeIndex, int operatorNumber, const bool convert);

    int ConvertCodeBlock(const int firstCodeIndex, const int funcID);

    int ConvertFunc(const int firstCodeIndex, const bool convert);

    void DeclareConstant(const int firstCodeIndex);

    int DeclareString(const std::string str);

    formulaData GetFormulaSize(const int firstCodeIndex, int operatorNumber);

    int GetFuncSize(const int firstCodeIndex);

    int DeclareVariable(const std::string name, const bool isGlobal);

    int DeclareList(const std::string name, const bool isGlobal);

    void ListFunction();

    void ListCppFunction();

    void InitConverter();

    void ClearLocalVariable();

    int TypeName2ID(const std::string typeName);

    std::string ID2TypeName(const int typeID);

    int LocalType2GlobalType(const int typeID);

    int Type2AddressType(const int typeID);

    bool checkVariableOrFuncName(const std::string name);

    bool isSymbol(const std::string code);

    bool checkName(const std::string name);

    std::string Code2Str();

    std::set<std::string> typeName = {"void", "number", "string", "bool"};
    std::map<std::string, funcData> funcDataMap;
    std::map<std::string, int> funcIDs;
    std::map<std::string, bool> isFuncExists;
    std::vector<std::vector<int>> funcArgTypes;
    std::vector<std::vector<std::string>> funcArgOriginalVariableNames;

    std::map<std::string, funcData> cppFuncDataMap;
    std::map<std::string, int> cppFuncIDs;
    std::map<std::string, bool> isCppFuncExists;

    std::unordered_map<std::string, variableTypeInfo> globalVariableTypes;
    std::unordered_map<std::string, variableTypeInfo> variableTypes;

    std::unordered_map<std::string, int> variableAddresses;
    std::vector<int> variableNums;
    int variableNum;

    std::unordered_map<std::string, int> globalVariableAddress;
    int globalVariableNum;

    std::vector<int> memorySize;
    std::vector<int> listMemorySize;

    std::map<std::string, int> listAddresses;
    std::vector<int> listNums;
    int listNum;

    std::map<std::string, int> globalListAddresses;
    int globalListNum;

    std::unordered_map<int, var> variableInitialValues;

    std::vector<std::vector<int>> funcArgAddresses;
    std::vector<int> funcStartIndexes;
    std::vector<int> funcBytecodeStartIndexes;

    std::vector<std::string> code;

    std::vector<int> funcTypes;

    int bytecodeIndex;
    int bytecodeSize;

    std::vector<int> globalVariableDeclarationByteCode;

    std::set<std::string> defaultFuncNames;

    std::map<std::string, std::pair<int, std::vector<ArgType>>> defaultFuncData = {
        {"size", {GET_LIST_SIZE, {ArgType::LIST}}},
        {"add", {ADD_LIST, {ArgType::LIST, ArgType::VALUE}}},
        {"get", {GET_LIST, {ArgType::LIST, ArgType::VALUE}}},
        {"insert", {INSERT_LIST, {ArgType::LIST, ArgType::VALUE, ArgType::VALUE}}},
        {"remove", {REMOVE_LIST, {ArgType::LIST, ArgType::VALUE}}}};
};

#endif /* convert_hpp */
