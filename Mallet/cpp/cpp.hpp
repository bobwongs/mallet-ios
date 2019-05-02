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

class Cpp
{
public:
    static std::unordered_map<std::string, int> numberGlobalVariableAddress;
    static std::unordered_map<std::string, int> stringGlobalVariableAddress;

    static std::vector<int> numberGlobalVariable;
    static std::vector<std::string> stringGlobalVariable;

    static std::vector<std::vector<int>> codes;
    static std::vector<std::vector<std::string>> stringVariableInitialValues;

    int SplitCode(std::string originalCodeStr, std::string code[], int codeMaxSize,
                  std::set<char> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord);

    std::string RefactorCode(std::string code);

    std::string ConvertCodeToJson(std::string codeStr,
                                  std::unordered_map<std::string, int> numberGlobalVariableAddress, std::unordered_map<std::string, int> stringGlobalVariableAddress);

    void RunCode(int id); //(std::vector<int> code, int codeSize, std::vector<std::string> stringVariableInitialValue, int stringVariableInitialValueSize);

    void InitRunner(std::vector<std::vector<int>> codes, std::vector<std::vector<std::string>> stringVariableInitialValues);
};


//std::vector<int>  Cpp::numberGlobalVariable = std::vector<int>(100000);
//std::vector<std::string> Cpp::stringGlobalVariable = std::vector<std::string>(10000);

#endif /* cpp_hpp */
