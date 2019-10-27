//
//  time.mm
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/04.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ModelIO/ModelIO.h>
#include "time.hpp"

var sleepForSeconds(std::vector<var> &args)
{

    double time = [[NSDate date] timeIntervalSince1970] + getNumberValue(args[0]);

    while (time > [[NSDate date] timeIntervalSince1970]) {}

    return 0;
}