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
//#include <unistd.h>

var sleepForSeconds(std::vector<var> &args)
{
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:getNumberValue(args[0])]];

    return 0;
}