//
//  ui.mm
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/03.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "Mallet-Swift.h"
#include "ui.hpp"

var setUIPositionX(std::vector<var> &args)
{
    double x = getNumberValue(args[1]);

    [AppUIController SetUIPositionXWithId:getIntValue(args[0]) x:x];

    return 0;
}

var setUIPositionY(std::vector<var> &args)
{
    double y = getNumberValue(args[1]);

    [AppUIController SetUIPositionYWithId:getIntValue(args[0]) y:y];

    return 0;
}

var setUIText(std::vector<var> &args)
{
    NSString *text = [NSString stringWithCString:getOutValue(args[1]).c_str() encoding:NSUTF8StringEncoding];

    [AppUIController SetUITextWithId:getIntValue(args[0]) text:text];

    return 0;
}
