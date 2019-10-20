//
//  math.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/20.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "math.hpp"

var round(std::vector<var> &args)
{
    return round(getNumberValue(args[0]));
}