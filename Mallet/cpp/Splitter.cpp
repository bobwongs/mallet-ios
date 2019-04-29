//
//  Splitter.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/29.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "cpp.hpp"

std::string DeleteComments(std::string code)
{
    std::string processedCode = "";

    int i = 0;
    while (i < code.size())
    {
        if (code[i] == '"')
        {
            processedCode += '"';
            i++;

            while (i < code.size() && code[i] != '"')
            {
                if (i + 1 < code.size() && code[i] == '\\' && code[i + 1] == '"')
                {
                    processedCode += code[i];
                    i++;
                }

                processedCode += code[i];
                i++;
            }

            processedCode += '"';
            i++;
        }
        else if (code[i] == '/' &&
                 (code[i + 1] == '*' || code[i + 1] == '/'))
        {
            if (code[i + 1] == '*')
            {
                i += 2;
                while (i + 1 < code.size() && code[i] != '*' && code[i + 1] != '/')
                    i++;
                i += 2;
            }
            else
            {
                i += 2;
                while (i < code.size() && code[i] != '\n')
                    i++;
            }
        }
        else
        {
            if (code[i] == '\n')
                processedCode += ' ';
            else
                processedCode += code[i];

            i++;
        }
    }

    return processedCode;
}

int Cpp::SplitCode(std::string originalCodeStr, std::string code[], int codeMaxSize,
                   std::set<char> &symbol, std::set<std::string> &doubleSymbol, std::set<std::string> &reservedWord)
{

    originalCodeStr = DeleteComments(originalCodeStr);

    char splitChar = '$';

    originalCodeStr = "{" + originalCodeStr + "}";

    std::string codeStr = "";

    for (int i = 0; i < originalCodeStr.size(); i++)
    {
        if (originalCodeStr[i] == '\n')
            originalCodeStr[i] = ' ';
    }

    int codeSize = 0;

    int i = 0;
    while (i < originalCodeStr.size())
    {
        if (originalCodeStr[i] == ' ')
        {
            codeStr += splitChar;
            while (i < originalCodeStr.size() && originalCodeStr[i] == ' ')
                i++;

            continue;
        }

        if (originalCodeStr[i] == '"')
        {
            codeStr += '"';
            i++;

            std::string str = "\"";

            while (i < originalCodeStr.size() && originalCodeStr[i] != '"')
            {
                if (i + 1 < originalCodeStr.size() && originalCodeStr[i] == '\\' && originalCodeStr[i + 1] == '"')
                {
                    i++;
                }

                str += originalCodeStr[i];

                i++;
            }

            str += '"';

            code[codeSize] = str;
            codeSize++;

            i++;

            continue;
        }

        std::string str = "";

        while (i < originalCodeStr.size())
        {
            str += originalCodeStr[i];

            bool isSymbol = (bool)symbol.count(originalCodeStr[i]);

            bool isNextSymbol = false;

            bool isDoubleSymbol = false;

            bool isNextBlank = false;

            if (i + 1 < originalCodeStr.size())
            {
                isNextSymbol = (bool)symbol.count(originalCodeStr[i + 1]);
                isDoubleSymbol = (bool)doubleSymbol.count(std::string() + originalCodeStr[i] + originalCodeStr[i + 1]);
                isNextBlank = originalCodeStr[i + 1] == ' ';
            }

            if (((isSymbol || isNextSymbol) && !isDoubleSymbol) || isNextBlank)
            {
                code[codeSize] = str;
                codeSize++;
                break;
            }

            i++;
        }

        i++;
    }

    return codeSize;
}