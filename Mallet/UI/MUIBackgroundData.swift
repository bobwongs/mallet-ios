//
//  MUIBackgroundData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUIBackgroundData: Codable {

    var enabled = true

    var color: MUIColor

    var cornerRadius: CGFloat

    static let disabled = MUIBackgroundData(enabled: false, color: .clear, cornerRadius: 0)

    static let defaultValue = MUIBackgroundData(color: .clear, cornerRadius: 0)

}
