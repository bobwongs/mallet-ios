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
        return self.x + self.width / 2
    }

    var midY: CGFloat {
        return self.y + self.height / 2
    }

    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    init(_ frame: CGRect) {
        self.x = frame.origin.x
        self.y = frame.origin.y
        self.width = frame.width
        self.height = frame.height
    }

    static var zero: MUIRect {
        MUIRect(x: 0, y: 0, width: 0, height: 0)
    }
}
