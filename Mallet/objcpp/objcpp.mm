//
//  objcpp.mm
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <ModelIO/ModelIO.h>
#include <unordered_map>
#include <vector>
#import "objcpp.h"
#import "../cpp/cpp.hpp"

@implementation ConverterObjCpp
{
    Converter *converter;
}

- (id)init
{
    if (self == [super init])
    {
        converter = new Converter();
    }

    return self;
}

- (NSString *)ConvertCodeToJson:(NSString *)code :(NSDictionary *)uiName :(bool)isDefinitionOfGlobalVariable
{
    std::string codeString = [code UTF8String];

    std::unordered_map<std::string, int> uiNameMap;

    for (id key in [uiName keyEnumerator])
    {
        std::string name = [key UTF8String];
        int uiID = [[uiName valueForKey:key] intValue];

        uiNameMap[name] = uiID;
    }

    std::string json = converter->ConvertCodeToJson(codeString, isDefinitionOfGlobalVariable, uiNameMap, *converter);
    NSString *jsonNSString = [NSString stringWithUTF8String:json.c_str()];

    return jsonNSString;
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
        [self InitRunner];
    }

    return self;
}

- (void)ExtractCodes:(NSArray<NSString *> *)codeJsons
{
    std::vector<std::vector<int>> codes;
    std::vector<std::vector<std::string>> stringVariableInitialValues;

    for (int i = 0; i < codeJsons.count; i++)
    {
        NSError *error;
        NSData *jsonData = [codeJsons[i] dataUsingEncoding:NSUnicodeStringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];

        int codeSize = (int) [dic[@"code"] count];
        int stringSize = (int) [dic[@"string"] count];

        codes.push_back(std::vector<int>());

        stringVariableInitialValues.push_back(std::vector<std::string>());

        for (int j = 0; j < codeSize; j++)
        {
            NSNumber *number = [dic[@"code"] objectAtIndex:j];

            codes[i].push_back((int) number.integerValue);
        }

        for (int j = 0; j < stringSize; j++)
        {
            NSString *string = [dic[@"string"] objectAtIndex:j];

            stringVariableInitialValues[i].push_back([string UTF8String]);
        }

    }

    runner->codes = codes;
    runner->stringVariableInitialValues = stringVariableInitialValues;
}

- (void)RunCode:(int)index
{
    runner->RunCode(index, *runner);
}

- (void)InitRunner
{
    runner->InitRunner(*runner);
}

@end
