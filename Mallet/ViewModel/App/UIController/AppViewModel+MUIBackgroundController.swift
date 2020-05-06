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
        XyObj(getUIData(args[0]).backgroundData.color.wrappedValue.hexCode)
    }

    func setCornerRadius(args: [XyObj]) -> XyObj {
        getUIData(args[0]).backgroundData.cornerRadius.wrappedValue = CGFloat(args[1].float())
        return .zero
    }

    func getCornerRadius(args: [XyObj]) -> XyObj {
        XyObj(Double(getUIData(args[0]).backgroundData.cornerRadius.wrappedValue))
    }

}
