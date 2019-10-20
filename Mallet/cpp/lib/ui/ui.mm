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

#include <iostream>


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

var setUIWidth(std::vector<var> &args)
{
    double w = getNumberValue(args[1]);

    [AppUIController SetUIWidthWithId:getIntValue(args[0]) width:w];

    return 0;
}

var setUIHeight(std::vector<var> &args)
{
    double h = getNumberValue(args[1]);

    [AppUIController SetUIHeightWithId:getIntValue(args[0]) height:h];

    return 0;
}

var setUIValue(std::vector<var> &args)
{
    NSString *text = [NSString stringWithCString:getOutValue(args[1]).c_str() encoding:NSUTF8StringEncoding];

    [AppUIController setUIValueWithId:getIntValue(args[0]) value:text];

    return 0;
}

var setUIText(std::vector<var> &args)
{
    NSString *text = [NSString stringWithCString:getOutValue(args[1]).c_str() encoding:NSUTF8StringEncoding];

    [AppUIController SetUITextWithId:getIntValue(args[0]) text:text];

    return 0;
}

var setUIFontColor(std::vector<var> &args)
{
    NSString *value = [NSString stringWithCString:getOutValue(args[1]).c_str() encoding:NSUTF8StringEncoding];

    [AppUIController SetUIFontColorWithId:getIntValue(args[0]) color:value];

    return 0;
}

var setUIFontSize(std::vector<var> &args)
{
    int value = getIntValue(args[1]);

    [AppUIController SetUIFontSizeWithId:getIntValue(args[0]) size:value];

    return 0;
}

var setUITextAlignment(std::vector<var> &args)
{
    NSString *value = [NSString stringWithCString:getOutValue(args[1]).c_str() encoding:NSUTF8StringEncoding];

    [AppUIController SetUITextAlignmentWithId:getIntValue(args[0]) alignmentStr:value];

    return 0;
}

var setUIBackgroundColor(std::vector<var> &args)
{
    NSString *value = [NSString stringWithCString:getOutValue(args[1]).c_str() encoding:NSUTF8StringEncoding];

    //TODO:

    return 0;
}

var getUIValue(std::vector<var> &args)
{
    std::string str = [[AppUIController getUIValueWithId:getIntValue(args[0])] UTF8String];

    return str;
}

void setUITable(int uiID, std::vector<var> &list)
{
    NSMutableArray *listString = [[NSMutableArray alloc] init];

    for (var element : list)
    {
        [listString addObject:[NSString stringWithCString:getOutValue(element).c_str() encoding:NSUTF8StringEncoding]];
    }

    [AppUIController setUITableWithId:uiID list:listString];
}