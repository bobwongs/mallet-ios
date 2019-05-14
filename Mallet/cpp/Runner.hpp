//
//  Runner.hpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/26.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#ifndef Runner_hpp
#define Runner_hpp

#include "cpp.hpp"
#include <stdio.h>

typedef struct
{
    std::vector<int> &numberVariable;
    std::vector<std::string> &stringVariable;
    Runner &runner;
} ArgData;

void RunBlock(std::vector<int> &code, int firstIndex, ArgData argData);

void IO(std::vector<int> &code, int firstIndex, ArgData argData);

void Control(std::vector<int> &code, int firstIndex, ArgData argData);

void Variable(std::vector<int> &code, int firstIndex, ArgData argData);

int OperateNumber(std::vector<int> &code, int firstIndex, ArgData argData);

void UI(std::vector<int> &code, int firstIndex, ArgData argData);

std::string OperateString(std::vector<int> &code, int firstIndex, ArgData argData);

void Do(std::vector<int> &code, int firstIndex, ArgData argData);

int GetNumberValue(std::vector<int> &code, int firstIndex, ArgData argData);

std::string GetStringValue(std::vector<int> &code, int firstIndex, ArgData argData);

void Print(std::vector<int> &code, int firstIndex, ArgData argData);

void SetNumberVariable(std::vector<int> &code, int firstIndex, ArgData argData);

void SetStringVariable(std::vector<int> &code, int firstIndex, ArgData argData);

void Repeat(std::vector<int> &code, int firstIndex, ArgData argData);

void If(std::vector<int> &code, int firstIndex, ArgData argData);

void While(std::vector<int> &code, int firstIndex, ArgData argData);

void SetUIText(std::vector<int> &code, int firstIndex, ArgData argData);

#endif /* Runner_hpp */
