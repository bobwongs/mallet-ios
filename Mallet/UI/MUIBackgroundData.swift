//
//  MUIBackgroundData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import XyloSwift

struct MUIBackgroundData: Codable {

    var enabled = true

    var color: MUIColor

    var cornerRadius: CGFloat

    static let disabled = MUIBackgroundData(enabled: false, color: .clear, cornerRadius: 0)

    static let defaultValue = MUIBackgroundData(color: .clear, cornerRadius: 0)

}

protocol MUIBackgroundController {

    /// - Parameter args: [UIID, Color(String, Hex Code)]
    /// - Returns: .zero
    func setColor(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: Color(String, Hex Code)
    func getColor(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID, Size(Float)]
    /// - Returns: .zero
    func setCornerRadius(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: Size(Float)
    func getCornerRadius(args: [XyObj]) -> XyObj

    var muiBackgroundFuncs: [Xylo.Func] { get }
}
