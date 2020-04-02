//
//  MUIColor.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUIColor: Codable {

    var r: Int

    var g: Int

    var b: Int

    var a: Int

    static let clear = MUIColor(r: 0, g: 0, b: 0, a: 0)

    static let black = MUIColor(r: 0, g: 0, b: 0, a: 255)

    static let white = MUIColor(r: 255, g: 255, b: 255, a: 255)

    init(r: Int, g: Int, b: Int, a: Int = 255) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }

    init(_ color: UIColor) {
        if let components = color.cgColor.components {
            r = Int(components[0] * 255)
            g = Int(components[1] * 255)
            b = Int(components[2] * 255)
            a = Int(components[3] * 255)

            return
        }

        r = 0
        g = 0
        b = 0
        a = 0
    }

    var toColor: Color {
        Color(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }

    var toUIColor: UIColor {
        UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    var toHexCode: String {
        ""
    }

}
