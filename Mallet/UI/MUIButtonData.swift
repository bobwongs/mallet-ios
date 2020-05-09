//
//  MUIButtonData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/07.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUIButtonData: Codable {

    var enabled = true

    var onTapped = MUIAction(name: "onTapped", args: [], code: "")

    static let disabled = MUIButtonData(enabled: false)

    static let defaultValue = MUIButtonData(enabled: true)

}

extension MUIButtonData: Equatable {

    public static func ==(lhs: MUIButtonData, rhs: MUIButtonData) -> Bool {
        lhs.enabled == rhs.enabled &&
            lhs.onTapped == rhs.onTapped
    }

}
