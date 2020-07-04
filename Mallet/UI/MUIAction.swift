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

    func xyloFuncName(uiID: Int) -> String {
        "$\(name)_\(uiID)"
    }

    func xyloCodeStr(uiID: Int) -> String {
        """
        func \(xyloFuncName(uiID: uiID)) (\(args.enumerated().reduce("") { (a1, a2) in "\(a1 + a2.1) \(a2.0 == args.count - 1 ? "" : ",")" }))
        {
        \(code)
        }
        """
    }

}

extension MUIAction: Equatable {

    public static func ==(lhs: MUIAction, rhs: MUIAction) -> Bool {
        lhs.name == rhs.name &&
            lhs.args == rhs.args &&
            lhs.code == rhs.code
    }

}
