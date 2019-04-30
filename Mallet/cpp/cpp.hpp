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
#include <unordered_map>

class Cpp
{
public:
    int SplitCode(std::string originalCodeStr, std::string code[], int codeMaxSize,
                  std::set<char> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord);

    std::string RefactorCode(std::string code);

    std::string ConvertCodeToJson(std::string codeStr,
                                  std::unordered_map<std::string, int> numberGlobalVariableAddress, std::unordered_map<std::string, int> stringGlobalVariableAddress);

    void RunCode(int code[], int codeSize, std::string stringVariableInitialValue[], int stringVariableInitialValueSize);
};

#endif /* cpp_hpp */
