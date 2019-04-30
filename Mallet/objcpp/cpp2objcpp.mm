//
//  cpp2objcpp.mm
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/27.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <ModelIO/ModelIO.h>
#import "cpp2objcpp.h"
#import "Mallet-Swift.h"

@interface ObjCpp2Swift : NSObject
+ (void)SetUIText:(int)uiID :(char *)text;
@end

@implementation ObjCpp2Swift
+ (void)SetUIText:(int)uiID :(char *)text
{
    NSString *textStr = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];

    [[RunApp alloc] SetUITextWithId:uiID text:textStr];
}

+ (void)SetNumberGlobalVariable:(int)address :(int)value
{
    [[RunApp alloc] SetNumberGlobalVariableWithAddress:address value:value];
}

+ (int)GetNumberGlobalVariable:(int)address
{
    return [[RunApp alloc] GetNumberGlobalVariableWithAddress:address];
}


+ (void)SetStringGlobalVariable:(int)address :(NSString *)value
{
    [[RunApp alloc] SetStringGlobalVariableWithAddress:address value:value];
}

+ (NSString *)GetStringGlobalVariable:(int)address
{
    return [[RunApp alloc] GetStringGlobalVariableWithAddress:address];
}
@end

void Cpp2ObjCpp::SetUIText(int uiID, char *text)
{
    [ObjCpp2Swift SetUIText:uiID :text];
}

void Cpp2ObjCpp::SetNumberGlobalVariable(int address, int value)
{
    [ObjCpp2Swift SetNumberGlobalVariable:address :value];
}

int Cpp2ObjCpp::GetNumberGlobalVariable(int address)
{
    return [ObjCpp2Swift GetNumberGlobalVariable:address];
}

void Cpp2ObjCpp::SetStringGlobalVariable(int address, const char *value)
{
    NSString *str = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
    [ObjCpp2Swift SetStringGlobalVariable:address :str];
}


char *Cpp2ObjCpp::GetStringGlobalVariable(int address)
{
    NSString *str = [ObjCpp2Swift GetStringGlobalVariable:address];
    char *cstr = (char *) [str UTF8String];

    return cstr;
}