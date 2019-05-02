//
//  cpp.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "cpp.hpp"

std::vector<int> Cpp::numberGlobalVariable;
std::vector<std::string> Cpp::stringGlobalVariable;

std::vector<std::vector<int>> Cpp::codes;
std::vector<std::vector<std::string>> Cpp::stringVariableInitialValues;

std::unordered_map<std::string, int>Cpp::numberGlobalVariableAddress;
std::unordered_map<std::string, int>Cpp::stringGlobalVariableAddress;

void Cpp::InitRunner(std::vector<std::vector<int>> codes, std::vector<std::vector<std::string>> stringVariableInitialValues)
{
    Cpp::numberGlobalVariable = std::vector<int>(100000);
    Cpp::stringGlobalVariable = std::vector<std::string>(10000);

    Cpp::numberGlobalVariable[1] = 114514;
    Cpp::numberGlobalVariable[2] = 0;

    Cpp::stringGlobalVariable[1] = "ぐろーばる すとりんぐ";

    Cpp::codes = codes;
    Cpp::stringVariableInitialValues = stringVariableInitialValues;
}