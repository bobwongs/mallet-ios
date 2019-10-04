//
//  objcpp.mm
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ModelIO/ModelIO.h>
#include <unordered_map>
#include <vector>
#import "objcpp.h"
#import "cpp.hpp"
#include "common.hpp"

@implementation ConverterObjCpp
{
    Convert *converter;
}

- (id)init
{
    if (self == [super init])
    {
        converter = new Convert();
    }

    return self;
}

- (NSString *)ConvertCode:(NSString *)codeStr
{
    std::string codeStrString = [codeStr UTF8String];

    std::string convertedCode = converter->ConvertCode(codeStrString);

    return [NSString stringWithUTF8String:convertedCode.c_str()];
}

@end

@implementation RunnerObjCpp
{
    Run *runner;
}

- (id)init
{
    if (self == [super init])
    {
        runner = new Run();
    }

    return self;
}

- (void)RunCode:(int)index
{
    //TODO:
    std::vector<var> arg(0);
    runner->RunCode(index, arg);
}

- (void)InitRunner:(NSString *)codeDataStr
{
    std::string codeDataStrString = [codeDataStr UTF8String];

    runner->InitRunner(codeDataStrString);
}

- (void)TerminateRunner
{
    runner->Terminate();
}

- (bool)UpdateCloudVariable:(NSString *)address :(NSString *)value
{
    return runner->UpdateCloudVariable([address UTF8String], [value UTF8String]);
}

@end
