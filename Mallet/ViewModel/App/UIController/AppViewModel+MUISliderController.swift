//
//  AppViewModel+MUISliderController.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/06.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import XyloSwift

extension AppViewModel: MUISliderController {

    func setMinValue(args: [XyObj]) -> XyObj {
        getUIData(args[0]).sliderData.minValue.wrappedValue = CGFloat(args[1].float())
        return .zero
    }

    func getMinValue(args: [XyObj]) -> XyObj {
        XyObj(Double(getUIData(args[0]).sliderData.minValue.wrappedValue))
    }

    func setMaxValue(args: [XyObj]) -> XyObj {
        getUIData(args[0]).sliderData.maxValue.wrappedValue = CGFloat(args[1].float())
        return .zero
    }

    func getMaxValue(args: [XyObj]) -> XyObj {
        XyObj(Double(getUIData(args[0]).sliderData.maxValue.wrappedValue))
    }


}
