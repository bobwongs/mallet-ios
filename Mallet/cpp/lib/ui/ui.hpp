//
//  ui.hpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/03.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#ifndef ui_hpp
#define ui_hpp

#include "../../common.hpp"
#include "../../cast.hpp"

var setUIPositionX(std::vector<var> &args);

var setUIPositionY(std::vector<var> &args);

var setUIWidth(std::vector<var> &args);

var setUIHeight(std::vector<var> &args);

var setUIText(std::vector<var> &args);

var setUIFontColor(std::vector<var> &args);

var setUIFontSize(std::vector<var> &args);

var setUITextAlignment(std::vector<var> &args);

var setUIBackgroundColor(std::vector<var> &args);

var getUIText(std::vector<var> &args);

void setUITable(int uiID, std::vector<var> &list);

#endif /* ui_hpp */
