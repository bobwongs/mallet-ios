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

class Convert
{
public:
    std::string ConvertCode(std::string codeStr);

private:
    struct funcData
    {
        std::string funcName;
        int argNum;

        bool operator<(const funcData &value) const
        {
            return std::tie(funcName, argNum) < std::tie(value.funcName, value.argNum);
        }
    };

    struct formulaData
    {
        int codeSize;
        int type;
    };

    void AddCode(int code);

    void AddCmdCode(int code, int argNum);

    void AddPushCode(int address, bool absolute);

    void AddPushAddressCode(int address, bool absolute);

    void AddPushTrueCode();

    void AddPushFalseCode();

    void AddPush0Code();

    void AddPush1Code();

    std::string RemoveComments(std::string codeStr);

    std::vector<std::string> SplitCode(std::string codeStr);

    int ConvertValue(const int firstCodeIndex, const bool convert);

    formulaData ConvertFormula(const int firstCodeIndex, int operatorNumber, const bool convert);

    int ConvertCodeBlock(const int firstCodeIndex, const int funcID);

    int ConvertFunc(const int firstCodeIndex, const bool convert);

    void DeclareConstant(const int firstCodeIndex);

    formulaData GetFormulaSize(const int firstCodeIndex, int operatorNumber);

    int GetFuncSize(const int firstCodeIndex);

    int DeclareVariable(const std::string name, const bool isGlobal);

    void ListFunction();

    void ListCppFunction();

    void InitConverter();

    void ClearLocalVariable();

    int TypeName2ID(const std::string typeName);

    std::string ID2TypeName(const int typeID);

    int LocalType2GlobalType(const int typeID);

    int Type2AddressType(const int typeID);

    std::string Code2Str();

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

    std::vector<int> memorySize;

    std::unordered_map<std::string, int> globalVariableAddress;

    int globalVariableNum;

    std::unordered_map<std::string, int> variableAddresses;
    std::vector<int> variableNums;
    int variableNum;

    std::unordered_map<int, var> variableInitialValues;

    std::vector<std::vector<int>> funcArgAddresses;
    std::vector<int> funcStartIndexes;
    std::vector<int> funcBytecodeStartIndexes;

    std::vector<std::string> code;

    std::vector<std::vector<int>> bytecodes;
    std::unordered_map<std::string, int> uiName;

    std::vector<int> funcTypes;

    std::vector<int> bytecode;
    int bytecodeIndex;
    int bytecodeSize;
};

#endif /* convert_hpp */
