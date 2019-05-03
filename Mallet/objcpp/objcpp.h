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

- (NSString *)ConvertCodeToJson:(NSString *)code :(bool)isDefinitionOfGlobalVariable;// :(NSDictionary *)numberGlobalVariableAddress :(NSDictionary *)stringGlobalVariableAddress

@end

@interface RunnerObjCpp : NSObject

- (void)ExtractCodes:(NSArray<NSString *> *)codeJsons;

- (void)RunCode:(int)index;

- (void)InitRunner;
@end

#endif /* objcpp_h */
