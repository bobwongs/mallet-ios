//
//  cpp2objcpp.h
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/27.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#ifndef cpp2objcpp_h
#define cpp2objcpp_h


class Cpp2ObjCpp
{
public:
    static void SetUIText(int uiID, char *text);

    static void SetNumberGlobalVariable(int address, int value);

    static int GetNumberGlobalVariable(int address);

    static void SetStringGlobalVariable(int address, const char *value);

    static char *GetStringGlobalVariable(int address);
};

#endif /* cpp2objcpp_h */
