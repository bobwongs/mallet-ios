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

@interface VariableDataObjC : NSObject

@property NSString *type;

@property NSString *name;

@property NSString *value;

@end

@interface ListDataObjC : NSObject

@property NSString *type;

@property NSString *name;

@property NSMutableArray<NSString *> *value;

@property NSNumber *uiID;

@end

@interface ConverterObjCpp : NSObject

- (NSString *)GetVariableDataObjCType:(VariableDataObjC *)value;

- (NSString *)GetVariableDataObjCName:(VariableDataObjC *)value;

- (NSString *)GetVariableDataObjCValue:(VariableDataObjC *)value;

- (NSString *)ConvertCode:(NSString *)codeStr;

- (NSMutableArray<NSString *> *)SplitCode:(NSString *)codeStr;

- (NSMutableArray<VariableDataObjC *> *)GetGlobalVariables:(NSString *)codeStr;

- (NSMutableArray<ListDataObjC *> *)GetGlobalLists:(NSString *)codeStr;

@end

@interface RunnerObjCpp : NSObject

- (void)RunCode:(int)index;

- (void)InitRunner:(NSString *)codeDataStr :(NSDictionary<NSString *, NSString *> *)variables;

- (void)TerminateRunner;

- (bool)UpdateCloudVariable:(NSString *)name :(NSString *)value;

- (bool)UpdateCloudList:(NSString *)name :(NSMutableArray<NSString *> *)value;

- (void)InitPersistentVariable:(NSDictionary<NSString *, NSString *> *)variables;

@end

#endif /* objcpp_h */
