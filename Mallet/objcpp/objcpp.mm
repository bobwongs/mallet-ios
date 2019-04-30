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
#import "objcpp.h"
#import "../cpp/cpp.hpp"

@implementation ObjCpp : NSObject
{
    Cpp *cpp;
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

    std::string json = cpp->ConvertCodeToJson(codeString, numberGlobalVariableAddressMap, stringGlobalVariableAddressMap);
    NSString *jsonNSString = [NSString stringWithUTF8String:json.c_str()];

    return jsonNSString;
}

- (void)RunCode:(NSString *)json
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


    cpp->RunCode(code, codeSize, stringVariableInitialValue, stringSize);

}

@end


