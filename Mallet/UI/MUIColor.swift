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

    init(_ hexCode: String) {
        let resizedString: String

        if hexCode.count >= 8 {
            resizedString = String(hexCode.prefix(8))
        } else if hexCode.count >= 6 {
            resizedString = "FF" + String(hexCode.prefix(6))
        } else if hexCode.count >= 1 {
            let subStr = String(hexCode.prefix(min(3, hexCode.count)))
            resizedString = "FF" + subStr.map({ "\($0)\($0)" }).joined()
        } else {
            resizedString = "FFFFFFFF"
        }

        guard var number = Int(resizedString, radix: 16) else {
            self.init(r: 0, g: 0, b: 0)
            return
        }

        var colors = [Int]()
        for _ in 0..<4 {
            colors.append(number % 256)
            number /= 256
        }

        self.init(r: colors[2], g: colors[1], b: colors[0], a: colors[3])
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

extension MUIColor: Equatable {

    public static func ==(lhs: MUIColor, rhs: MUIColor) -> Bool {
        (lhs.a, lhs.r, lhs.b, lhs.g) == (rhs.a, rhs.r, rhs.b, rhs.g)
    }

}
