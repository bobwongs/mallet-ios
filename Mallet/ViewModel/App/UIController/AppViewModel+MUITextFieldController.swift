//
//  AppViewModel+MUITextFieldController.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/05.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import XyloSwift

extension AppViewModel: MUITextFieldController {

    func setPlaceHolder(args: [XyObj]) -> XyObj {
        getUIData(args[0]).textFieldData.text.wrappedValue = args[1].string()
        return .zero
    }

    func getPlaceHolder(args: [XyObj]) -> XyObj {
        XyObj(getUIData(args[0]).textFieldData.text.wrappedValue)
    }

    var muiTextFieldFuncs: [Xylo.Func] {
        [
            Xylo.Func(funcName: "setPlaceHolder", argNum: 2, setPlaceHolder),
            Xylo.Func(funcName: "getPlaceHolder", argNum: 1, getPlaceHolder),
        ]
    }

}