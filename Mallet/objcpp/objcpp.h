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

@interface ObjCpp : NSObject

- (NSString *)ConvertCodeToJson:(NSString *)code;

@end

#endif /* objcpp_h */
