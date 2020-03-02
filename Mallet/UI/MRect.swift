//
// Created by Katsu Matsuda on 2019/12/18.
// Copyright (c) 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

struct MRect: Codable {

    var x: Float

    var y: Float

    var width: Float

    var height: Float

    var midX: Float {
        return self.x + self.width / 2
    }

    var midY: Float {
        return self.y + self.height / 2
    }

    init(x: Float, y: Float, width: Float, height: Float) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    init(_ frame: CGRect) {
        self.x = Float(frame.origin.x)
        self.y = Float(frame.origin.y)
        self.width = Float(frame.width)
        self.height = Float(frame.height)
    }
}
