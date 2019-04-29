//
//  Refactor.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/29.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "Refactor.hpp"

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
                    processedCode += '\\';
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

std::string Cpp::RefactorCode(std::string code)
{
    std::string refactoredCode = "";

    refactoredCode = DeleteComments(code);

    return refactoredCode;
}
