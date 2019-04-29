//
//  cpp.hpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#ifndef cpp_hpp
#define cpp_hpp

#include <stdio.h>
#include <string>

class Cpp
{
public:
    std::string RefactorCode(std::string code);
    std::string ConvertCodeToJson(std::string code);
    void RunCode(int code[], int codeSize, std::string stringVariableInitialValue[], int stringVariableInitialValueSize);
};

#endif /* cpp_hpp */
