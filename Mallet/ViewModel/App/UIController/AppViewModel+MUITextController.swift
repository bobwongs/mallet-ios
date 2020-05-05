//
//  AppViewModel+MUITextController.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/05.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import XyloSwift

extension AppViewModel: MUITextController {

    func setText(args: [XyObj]) -> XyObj {
        getUIData(args[0]).textData.text.wrappedValue = args[1].string()
        return .zero
    }

    func getText(args: [XyObj]) -> XyObj {
        XyObj(getUIData(args[0]).textData.text.wrappedValue)
    }

    func setTextColor(args: [XyObj]) -> XyObj {
        fatalError("setTextColor(args:) has not been implemented")
    }

    func getTextColor(args: [XyObj]) -> XyObj {
        fatalError("getTextColor(args:) has not been implemented")
    }

    func setTextSize(args: [XyObj]) -> XyObj {
        getUIData(args[0]).textData.size.wrappedValue = CGFloat(args[1].float())
        return .zero
    }

    func getTextSize(args: [XyObj]) -> XyObj {
        XyObj(Double(getUIData(args[0]).textData.size.wrappedValue))
    }

    func setTextAlignment(args: [XyObj]) -> XyObj {
        fatalError("setTextAlignment(args:) has not been implemented")
    }

    func getTextAlignment(args: [XyObj]) -> XyObj {
        fatalError("getTextAlignment(args:) has not been implemented")
    }

}
