//
//  MUIAction.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/08.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

struct MUIAction: Codable {

    let name: String

    let args: [String]

    var code: String

}

extension MUIAction: Equatable {

    public static func ==(lhs: MUIAction, rhs: MUIAction) -> Bool {
        lhs.name == rhs.name &&
            lhs.args == rhs.args &&
            lhs.code == rhs.code
    }

}
