//
// Created by Katsu Matsuda on 2019/12/18.
// Copyright (c) 2019 Katsu Matsuda. All rights reserved.
//

import Foundation

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

}