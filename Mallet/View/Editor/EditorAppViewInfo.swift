//
//  EditorAppViewInfo.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2021/02/21.
//  Copyright (c) 2021 Katsu Matsuda. All rights reserved.
//

import UIKit

struct EditorAppViewInfo {

    static let gridRectSize: CGFloat = 34

    static let gridWidth = 8

    static let gridHeight1 = 10

    static let gridHeight2 = 2

    static func gridRectPadding(screenSize: CGSize) -> CGFloat {
        (screenSize.width - gridRectSize * CGFloat(gridWidth)) / CGFloat(gridWidth * 2)
    }

    static func gridSpacerHeight(screenSize: CGSize, rectPadding: CGFloat) -> CGFloat {
        screenSize.height - (gridRectSize + rectPadding * 2) * CGFloat(gridHeight1 + gridHeight2)
    }

    static func frameSize(gridWidth: Int, gridHeight: Int, rectPadding: CGFloat) -> CGSize {
        let width = (gridRectSize + rectPadding * 2) * CGFloat(gridWidth) - rectPadding * 2
        let height = (gridRectSize + rectPadding * 2) * CGFloat(gridHeight) - rectPadding * 2
        return CGSize(width: width, height: height)
    }

}