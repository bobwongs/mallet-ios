//
//  MUIRectInGrid.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2021/02/21.
//  Copyright (c) 2021 Katsu Matsuda. All rights reserved.
//

import UIKit

struct MUIRectInGrid: Codable {

    var top: Int

    var left: Int

    var bottom: Int

    var right: Int

    static var zero: MUIRectInGrid {
        MUIRectInGrid(top: 0, left: 0, bottom: 0, right: 0)
    }

    var width: Int {
        right - left + 1
    }

    var height: Int {
        bottom - top + 1
    }

    func muiRect(screenSize: CGSize) -> MUIRect {
        let padding = EditorAppViewInfo.gridRectPadding(screenSize: screenSize)
        let spacerHeight = EditorAppViewInfo.gridSpacerHeight(screenSize: screenSize, rectPadding: padding)

        let tl = gridRectFrame(x: left, y: top, padding: padding, spacerHeight: spacerHeight)
        let br = gridRectFrame(x: right, y: bottom, padding: padding, spacerHeight: spacerHeight)

        return MUIRect(x: tl.minX, y: tl.minY, width: br.maxX - tl.minX, height: br.maxY - tl.minY)
    }

    func gridRectFrame(x: Int, y: Int, padding: CGFloat, spacerHeight: CGFloat) -> CGRect {
        let rectSize = EditorAppViewInfo.gridRectSize + padding * 2
        let minX = rectSize * CGFloat(x - 1) + padding
        let minY: CGFloat
        if y > EditorAppViewInfo.gridHeight1 {
            minY = rectSize * CGFloat(y - 1) + padding + spacerHeight
        } else {
            minY = rectSize * CGFloat(y - 1) + padding
        }

        return CGRect(x: minX, y: minY, width: EditorAppViewInfo.gridRectSize, height: EditorAppViewInfo.gridRectSize)
    }

}

extension MUIRectInGrid: Equatable {
    public static func ==(lhs: MUIRectInGrid, rhs: MUIRectInGrid) -> Bool {
        lhs.top == rhs.top &&
            lhs.left == rhs.top &&
            lhs.bottom == rhs.bottom &&
            lhs.right == rhs.right
    }
}
