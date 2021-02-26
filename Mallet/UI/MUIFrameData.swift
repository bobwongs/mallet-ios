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

    var rect: MUIRectType

    var lockHeight = false

    var lockWidth = false

    init(_ rect: MUIRectInGrid) {
        self.rect = .grid(rect)
    }

    init(_ rect: MUIRect) {
        self.rect = .free(rect)
    }

    func frame(screenSize: CGSize) -> MUIRect {
        switch rect {
        case .free(let value):
            return value
        case .grid(let value):
            return value.muiRect(screenSize: screenSize)
        }
    }

}

extension MUIFrameData: Equatable {

    public static func ==(lhs: MUIFrameData, rhs: MUIFrameData) -> Bool {
        lhs.rect == rhs.rect &&
            lhs.lockHeight == rhs.lockHeight &&
            lhs.lockWidth == rhs.lockWidth
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
