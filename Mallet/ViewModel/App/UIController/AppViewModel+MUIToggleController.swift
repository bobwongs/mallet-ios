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
        getUIData(args[0]).toggleData.value.wrappedValue = args[1].int() == 0
        return .zero
    }

    func getValue(args: [XyObj]) -> XyObj {
        XyObj(getUIData(args[0]).toggleData.value.wrappedValue ? 1 : 0)
    }

}
