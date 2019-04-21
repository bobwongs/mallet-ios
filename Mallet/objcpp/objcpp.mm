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

@end
