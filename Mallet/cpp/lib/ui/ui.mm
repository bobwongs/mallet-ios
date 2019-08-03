//
//  ui.mm
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/03.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <ModelIO/ModelIO.h>
#import "Mallet-Swift.h"
#include "ui.hpp"

var setUIText(std::vector<var> &args)
{
    NSString *text = [NSString stringWithCString:getOutValue(args[1]).c_str() encoding:NSUTF8StringEncoding];

    [[AppRunner alloc] SetUITextWithId:getIntValue(args[0]) text:text];

    printf("@@%d\n",getIntValue(args[0]));

    return 0;
}
