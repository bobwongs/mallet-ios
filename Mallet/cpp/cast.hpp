//
//  cast.hpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/03.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#ifndef cast_hpp
#define cast_hpp

#include "common.hpp"

ControlCode getControlCode(var &variable);

int getIntValue(var &variable);

double getNumberValue(var &Variable);

bool getBoolValue(var &variable);

std::string getStringValue(var &variable);

std::string getOutValue(var &variable);

#endif /* cast_hpp */
