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
    public static var appRunner: AppRunner?

    private static var ref = Database.database().reference()

    private static let variablePath = "variable"

    static func start() {
        ref.child(variablePath).observe(.value, with: { snapshot in
            print(114514)
            if let appRunner = appRunner {
                let variables = snapshot.value as? NSDictionary
                if let value = variables?["label"] as? String {
                    appRunner.updateUIWithCloudVariable(name: "label", value: value)
                }
            }
        })
    }

    static func setCloudVariable(name: String, value: String) {
        ref.child(variablePath).updateChildValues([name: value])
    }
}