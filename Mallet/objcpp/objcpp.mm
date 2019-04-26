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
#import "objcpp.h"
#import "../cpp/cpp.hpp"

@implementation ObjCpp : NSObject {
    Cpp *cpp;
}

- (NSString *)ConvertCodeToJson:(NSString *)code {
    std::string codeString = [code UTF8String];
    std::string json = cpp->ConvertCodeToJson(codeString);
    NSString *jsonNSString = [NSString stringWithUTF8String:json.c_str()];

    return jsonNSString;
}

- (void)RunCode:(NSString *)json {
    NSData *jsonData = [json dataUsingEncoding:NSUnicodeStringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];

    int code[1000000];
    std::string stringVariableInitialValue[10000];

    memset(code, 0, sizeof(code));

    int codeSize = [dic[@"code"] count];
    int stringSize = [dic[@"string"] count];

    for (int i = 0; i < codeSize; i++) {
        NSNumber *number = [dic[@"code"] objectAtIndex:i];
        code[i] = number.integerValue;
    }

    for (int i = 0; i < stringSize; i++) {
        NSString *string = [dic[@"string"] objectAtIndex:i];
        stringVariableInitialValue[i] = [string UTF8String];
    }

    cpp->RunCode(code, codeSize, stringVariableInitialValue, stringSize);
}

@end
