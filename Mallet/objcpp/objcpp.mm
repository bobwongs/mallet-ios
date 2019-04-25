//
//  objcpp.m
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
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

@end
