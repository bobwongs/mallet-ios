//
//  Extension.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/05.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
    }

    convenience init(hex: String, alpha: CGFloat) {
        let dec = Int(hex, radix: 16) ?? 0
        let r = CGFloat((dec / (256 * 256)) % 256) / 255
        let g = CGFloat((dec / 256) % 256) / 255
        let b = CGFloat(dec % 256) / 255

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }

    public func hexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        print(self)

        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        return String(format: "%02x%02x%02x%02x", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
    }

    public class func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor {
                (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                } else {
                    return light
                }
            }
        }
        return light
    }

    public static var vplBlock: UIColor {
        return dynamicColor(
                light: UIColor(hex: "DDDDDD"),
                dark: UIColor(hex: "333333")
        )
    }

    public static var vplBackground: UIColor {
        return dynamicColor(
                light: UIColor(hex: "FAFAFA"),
                dark: UIColor(hex: "1C1C1E")
        )
    }
}