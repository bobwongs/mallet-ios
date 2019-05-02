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

void RunBlock(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

void IO(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

void Control(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

void Variable(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

int OperateNumber(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

void UI(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

std::string OperateString(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

void Do(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

int GetNumberValue(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

std::string GetStringValue(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

void Print(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

void SetNumberVariable(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

void SetStringVariable(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

void Repeat(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

void If(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

void SetUIText(std::vector<int> &code, int firstIndex, std::vector<int> &numberVariable, std::vector<std::string> &stringVariable);

#endif /* Runner_hpp */
