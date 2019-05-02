//
//  objcpp.m
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

@implementation ObjCpp : NSObject
{
    Cpp *cpp;
    std::vector<std::vector<int>> codes;
    std::vector<int> codeSizes;
    std::vector<std::vector<std::string>> stringVariableInitialValues;
    std::vector<int> stringSizes;
}

- (void)ExtractCodes:(NSArray<NSString *> *)codeJsons
{
    cpp = new Cpp();

    for (int i = 0; i < codeJsons.count; i++)
    {
        int code[100000];
        std::string stringVariableInitialValue[10000];

        NSError *error;
        NSData *jsonData = [codeJsons[i] dataUsingEncoding:NSUnicodeStringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];

        int codeSize = [dic[@"code"] count];
        int stringSize = [dic[@"string"] count];

        codeSizes.push_back(codeSize);
        stringSizes.push_back(stringSize);

        codes.push_back(std::vector<int>());
        stringVariableInitialValues.push_back(std::vector<std::string>());

        for (int j = 0; j < codeSize; j++)
        {
            NSNumber *number = [dic[@"code"] objectAtIndex:j];
            //code[j] = number.integerValue;

            codes[i].push_back(number.integerValue);

            //printf("%d %d\n", i, code[j]);
        }

        for (int j = 0; j < stringSize; j++)
        {
            NSString *string = [dic[@"string"] objectAtIndex:j];
            //stringVariableInitialValue[j] = [string UTF8String];

            stringVariableInitialValues[i].push_back([string UTF8String]);
        }

        //codes.push_back(code);
        //stringVariableInitialValues.push_back(stringVariableInitialValue);
    }

    cpp->InitRunner(codes, stringVariableInitialValues);
}

- (NSString *)ConvertCodeToJson:(NSString *)code :(NSDictionary *)numberGlobalVariableAddress :(NSDictionary *)stringGlobalVariableAddress
{
    std::string codeString = [code UTF8String];
    std::unordered_map<std::string, int> numberGlobalVariableAddressMap;
    std::unordered_map<std::string, int> stringGlobalVariableAddressMap;

    for (id key in [numberGlobalVariableAddress keyEnumerator])
    {
        std::string keyStr = [key UTF8String];
        numberGlobalVariableAddressMap[keyStr] = ((NSNumber *) [numberGlobalVariableAddress valueForKey:key]).integerValue;
    }

    for (id key in [stringGlobalVariableAddress keyEnumerator])
    {
        std::string keyStr = [key UTF8String];
        stringGlobalVariableAddressMap[keyStr] = ((NSNumber *) [stringGlobalVariableAddress valueForKey:key]).integerValue;
    }

    Cpp::numberGlobalVariableAddress = numberGlobalVariableAddressMap;
    Cpp::stringGlobalVariableAddress = stringGlobalVariableAddressMap;

    std::string json = cpp->ConvertCodeToJson(codeString, numberGlobalVariableAddressMap, stringGlobalVariableAddressMap);
    NSString *jsonNSString = [NSString stringWithUTF8String:json.c_str()];

    return jsonNSString;
}

- (void)RunCodeFromJson:(NSString *)json
{
    NSData *jsonData = [json dataUsingEncoding:NSUnicodeStringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];

    int code[1000000];
    std::string stringVariableInitialValue[10000];

    memset(code, 0, sizeof(code));

    int codeSize = [dic[@"code"] count];
    int stringSize = [dic[@"string"] count];

    for (int i = 0; i < codeSize; i++)
    {
        NSNumber *number = [dic[@"code"] objectAtIndex:i];
        code[i] = number.integerValue;
    }

    for (int i = 0; i < stringSize; i++)
    {
        NSString *string = [dic[@"string"] objectAtIndex:i];
        stringVariableInitialValue[i] = [string UTF8String];
    }

    // cpp->RunCode(code, codeSize, stringVariableInitialValue, stringSize);

}

- (void)RunCode:(int)index
{
    /*
    int code[100000];
    std::string stringVariableInitialValue[10000];

    for (int i = 0; i < codes[index].size(); i++)
        code[i] = codes[index][i];

    for (int i = 0; i < stringVariableInitialValues[index].size(); i++)
        stringVariableInitialValue[i] = stringVariableInitialValues[index][i];
    */

    //cpp->RunCode(code, codeSizes[index], stringVariableInitialValue, stringSizes[index]);
    cpp->RunCode(index);
}

@end
