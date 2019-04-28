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

void RunBlock(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

void IO(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

void Control(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

void Variable(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

int OperateNumber(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

void UI(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

std::string OperateString(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

void Do(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

int GetNumberValue(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

std::string GetStringValue(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

void Print(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

void SetNumberVariable(int *code, int firstIndex, int *numberVariable, std::string *stringVariable);

void SetStringVariable(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

void Repeat(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

void If(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

void SetUIText(int code[], int firstIndex, int numberVariable[], std::string stringVariable[]);

#endif /* Runner_hpp */
