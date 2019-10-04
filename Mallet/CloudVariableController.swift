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
    private static var appRunner: AppRunner?

    private static var ref = Database.database().reference()

    private static let variablePath = "variable"

    static func start(appRunner: AppRunner) {
        self.appRunner = appRunner

        ref.child(variablePath).observeSingleEvent(of: .value, with: { snapshot in
            CloudVariableController.updateCloudVariable(snapshot: snapshot)
        })

        ref.child(variablePath).observe(.value, with: { snapshot in
            CloudVariableController.updateCloudVariable(snapshot: snapshot)
        })
    }

    static func end() {
        ref.removeAllObservers()
    }

    private static func updateCloudVariable(snapshot: DataSnapshot) {
        if let appRunner = appRunner {
            if let variableDic = snapshot.value as? NSDictionary {
                var variables = [AppVariable]()
                for variable in variableDic {
                    variables.append(AppVariable(address: -1, name: variable.key as? String ?? "", value: variable.value as? String ?? ""))
                }

                appRunner.updateCloudVariables(variables: variables)
            }
        }
    }

    static func setCloudVariable(varName: String, value: String) {
        ref.child(variablePath).updateChildValues([varName: value])
    }
}