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

@end

void Cpp2ObjCpp::SetUIText(int uiID, char *text)
{
    [ObjCpp2Swift SetUIText:uiID :text];
}
