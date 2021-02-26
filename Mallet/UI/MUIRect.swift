//
// Created by Katsu Matsuda on 2019/12/18.
// Copyright (c) 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

struct MUIRect: Codable {

    var x: CGFloat

    var y: CGFloat

    var width: CGFloat

    var height: CGFloat

    var midX: CGFloat {
        x + width / 2
    }

    var midY: CGFloat {
        y + height / 2
    }

    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    init(_ frame: CGRect) {
        x = frame.origin.x
        y = frame.origin.y
        width = frame.width
        height = frame.height
    }

    static var zero: MUIRect {
        MUIRect(x: 0, y: 0, width: 0, height: 0)
    }

    var cgRect: CGRect {
        CGRect(x: x, y: y, width: width, height: height)
    }

    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}

extension MUIRect: Equatable {

    public static func ==(lhs: MUIRect, rhs: MUIRect) -> Bool {
        lhs.x == rhs.x &&
            lhs.y == rhs.y &&
            lhs.width == rhs.width &&
            lhs.height == rhs.height
    }

}
