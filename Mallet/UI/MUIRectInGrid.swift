//
//  MUIRectInGrid.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2021/02/21.
//  Copyright (c) 2021 Katsu Matsuda. All rights reserved.
//

import Foundation

struct MUIRectInGrid: Codable {

    var top: Int

    var left: Int

    var bottom: Int

    var right: Int

    static var zero: MUIRectInGrid {
        MUIRectInGrid(top: 0, left: 0, bottom: 0, right: 0)
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
