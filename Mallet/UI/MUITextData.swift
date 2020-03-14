//
//  MUITextData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/11.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUITextData: Codable {

    var enabled = true

    var text: String

    var color: MUIColor

    var size: CGFloat

    var alignment: MUITextAlignment

    static let disabled = MUITextData(enabled: false, text: "", color: .clear, size: 0, alignment: .center)

    static let defaultValue = MUITextData(enabled: true, text: "Label", color: .black, size: 17, alignment: .center)

}

enum MUITextAlignment: Int, Codable {

    case leading

    case center

    case trailing

    var toAlignment: Alignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }

    var toTextAlignment: TextAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }

    var toNSTextAlignment: NSTextAlignment {
        switch self {
        case .leading: return .left
        case .center: return .center
        case .trailing: return .right
        }
    }
}
