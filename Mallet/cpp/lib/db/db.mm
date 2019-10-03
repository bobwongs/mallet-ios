//
//  db.mm
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/02.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#include "Mallet-Swift.h"
#include "db.hpp"

void setAppVariable(int address, std::string value)
{
    NSString *valueString = [NSString stringWithCString:value.c_str() encoding:NSUTF8StringEncoding];

    [AppDatabaseController setAppVariableWithAddress:address value:valueString];
}

std::string getAppVariable(int address)
{
    NSString *valueString = [AppDatabaseController getAppVariableValueWithAddress:address];

    return [valueString UTF8String];
}

void setCloudVariable(std::string name, std::string value)
{

}

std::string getCloudVariable(std::string name)
{

    return "";
}
