//
//  MUIFrameData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import XyloSwift

struct MUIFrameData: Codable {

    var frame: MUIRect

    var lockHeight = false

    var lockWidth = false

    init(_ frame: MUIRect) {
        self.frame = frame
    }
}

protocol MUIFrameController {

    /// - Parameter args: [UIID, X(Float), Y(Float), Width(Float), Height(Float)]
    /// - Returns: .zero
    func setFrame(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID, X(Float), Y(Float)]
    /// - Returns: .zero
    func setPosition(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID, Width(Float), Height(Float)]
    /// - Returns: .zero
    func setSize(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID, X(Float)]
    /// - Returns: .zero
    func setX(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID, Y(Float)]
    /// - Returns: .zero
    func setY(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID, Width(Float)]
    /// - Returns: .zero
    func setWidth(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID, Height(Float)]
    /// - Returns: .zero
    func setHeight(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: X(Float)
    func getX(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: Y(Float)
    func getY(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: Width(Float)
    func getWidth(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: Height(Float)
    func getHeight(args: [XyObj]) -> XyObj

    var muiFrameFuncs: [Xylo.Func] { get }

}
