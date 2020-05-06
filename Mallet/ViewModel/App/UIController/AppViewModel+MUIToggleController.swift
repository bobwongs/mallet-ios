//
//  AppViewModel+MUIToggleController.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/06.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import XyloSwift

extension AppViewModel: MUIToggleController {

    func setValue(args: [XyObj]) -> XyObj {
        let ui = getUIData(args[0])
        if ui.toggleData.enabled.wrappedValue {
            ui.toggleData.value.wrappedValue = args[1].int() == 0
        }
        if ui.sliderData.enabled.wrappedValue {
            ui.sliderData.value.wrappedValue = CGFloat(args[1].float())
        }
        return .zero
    }

    func getValue(args: [XyObj]) -> XyObj {
        let ui = getUIData(args[0])
        if ui.toggleData.enabled.wrappedValue {
            return XyObj(ui.toggleData.value.wrappedValue ? 1 : 0)
        }
        if ui.sliderData.enabled.wrappedValue {
            return XyObj(Double(ui.sliderData.value.wrappedValue))
        }
        return .zero
    }

}
