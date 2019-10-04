//
//  objcpp.h
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#ifndef objcpp_h
#define objcpp_h

#import <Foundation/Foundation.h>

@interface ConverterObjCpp : NSObject

- (NSString *)ConvertCode:(NSString *)codeStr;

@end

@interface RunnerObjCpp : NSObject

- (void)RunCode:(int)index;

- (void)InitRunner:(NSString *)codeDataStr;

- (void)TerminateRunner;

- (bool)UpdateCloudVariable:(NSString *)name :(NSString *)value;
@end

#endif /* objcpp_h */
