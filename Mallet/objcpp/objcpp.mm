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

@implementation VariableDataObjC

@end

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

/*
- (NSString *)GetVariableDataObjCType:(VariableDataObjC)value
{
    if (value.type == VariableTypeObjC::normal_)
        return @"normal";
    if (value.type == VariableTypeObjC::persistent_)
        return @"persistent";
    if (value.type == VariableTypeObjC::cloud_)
        return @"cloud";

    return @"";
}

- (NSString *)GetVariableDataObjCName:(VariableDataObjC)value
{
    return value.name;
}

- (NSString *)GetVariableDataObjCValue:(VariableDataObjC)value
{
    return value.value;
}
 */

- (NSString *)ConvertCode:(NSString *)codeStr
{
    std::string codeStrString = [codeStr UTF8String];

    std::string convertedCode = converter->ConvertCode(codeStrString);

    return [NSString stringWithUTF8String:convertedCode.c_str()];
}

- (NSMutableArray<VariableDataObjC *> *)GetGlobalVariables:(NSString *)codeStr
{
    std::vector<Convert::variableData> variables = Convert::getGlobalVariables([codeStr UTF8String]);

    NSMutableArray<VariableDataObjC *> *globalVariables = [[NSMutableArray<VariableDataObjC *> alloc] init];

    for (Convert::variableData variable : variables)
    {
        VariableDataObjC *variableData = [VariableDataObjC alloc];
        if (variable.type == Convert::variableType::normal)
            variableData.type = @"normal";
        if (variable.type == Convert::variableType::persistent)
            variableData.type = @"persistent";
        if (variable.type == Convert::variableType::cloud)
            variableData.type = @"cloud";

        variableData.name = [NSString stringWithCString:variable.name.c_str() encoding:NSUTF8StringEncoding];
        variableData.value = [NSString stringWithCString:variable.value.c_str() encoding:NSUTF8StringEncoding];

        [globalVariables addObject:variableData];
    }

    return globalVariables;
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

- (void)InitRunner:(NSString *)codeDataStr :(NSDictionary<NSString *, NSString *> *)variables
{
    std::map<std::string, std::string> variablesMap = std::map<std::string, std::string>();

    for (id key in [variables keyEnumerator])
    {
        variablesMap[[key UTF8String]] = [[variables valueForKey:key] UTF8String];
    }

    std::string codeDataStrString = [codeDataStr UTF8String];

    runner->InitRunner(codeDataStrString, variablesMap);
}

- (void)TerminateRunner
{
    runner->Terminate();
}

- (bool)UpdateCloudVariable:(NSString *)address :(NSString *)value
{
    return runner->UpdateCloudVariable([address UTF8String], [value UTF8String]);
}

- (void)InitPersistentVariable:(NSDictionary<NSString *, NSString *> *)variables
{
}

@end
