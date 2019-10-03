//
//  CloudVariableController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/03.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

@objcMembers
class CloudVariableController: NSObject {
    private static var ref = Database.database().reference()

    private static let variablePath = "variable"

    static func setCloudVariable(name: String, value: String) {
        ref.child(variablePath).updateChildValues([name: value])
    }
}