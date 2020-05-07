//
//  AppViewModel+MUIBackgroundController.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/06.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import XyloSwift

extension AppViewModel: MUIBackgroundController {

    func setColor(args: [XyObj]) -> XyObj {
        getUIData(args[0]).backgroundData.color.wrappedValue = MUIColor(args[1].string())
        return .zero
    }

    func getColor(args: [XyObj]) -> XyObj {
        XyObj(getUIData(args[0]).backgroundData.color.wrappedValue.hexCode(withAlpha: true))
    }

    func setCornerRadius(args: [XyObj]) -> XyObj {
        getUIData(args[0]).backgroundData.cornerRadius.wrappedValue = CGFloat(args[1].float())
        return .zero
    }

    func getCornerRadius(args: [XyObj]) -> XyObj {
        XyObj(Double(getUIData(args[0]).backgroundData.cornerRadius.wrappedValue))
    }

    var muiBackgroundFuncs: [Xylo.Func] {
        [
            Xylo.Func(funcName: "setColor", argNum: 2, setColor),
            Xylo.Func(funcName: "getColor", argNum: 1, getColor),
            Xylo.Func(funcName: "setCornerRadius", argNum: 2, setCornerRadius),
            Xylo.Func(funcName: "getCornerRadius", argNum: 1, getCornerRadius),
        ]
    }
}
