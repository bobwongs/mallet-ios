//
//  Extension.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/05.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

extension UIColor {
    class func rgb(red: Int, green: Int, blue: Int) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
    }
}