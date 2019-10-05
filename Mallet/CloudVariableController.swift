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

    static func startApp(appRunner: AppRunner) {
        ref.removeAllObservers()

        ref.child(variablePath).observeSingleEvent(of: .value, with: { snapshot in
            CloudVariableController.updateCloudVariable(snapshot: snapshot, appRunner: appRunner)
        })

        ref.child(variablePath).observe(.value, with: { snapshot in
            CloudVariableController.updateCloudVariable(snapshot: snapshot, appRunner: appRunner)
        })
    }

    static func endApp() {
        ref.removeAllObservers()
    }

    static func startVariableSettings(variableSettingsController: VariableSettingsController) {
        ref.removeAllObservers()

        ref.child(variablePath).observeSingleEvent(of: .value, with: { snapshot in
            CloudVariableController.updateCloudVariableInVariableSettings(snapshot: snapshot, variableSettingsController: variableSettingsController)
        })

        ref.child(variablePath).observe(.value, with: { snapshot in
            CloudVariableController.updateCloudVariableInVariableSettings(snapshot: snapshot, variableSettingsController: variableSettingsController)
        })
    }

    static func endVariableSettings() {
        ref.removeAllObservers()
    }

    private static func updateCloudVariable(snapshot: DataSnapshot, appRunner: AppRunner) {
        if let variableDic = snapshot.value as? NSDictionary {
            var variables = [AppVariable]()
            for variable in variableDic {
                variables.append(AppVariable(address: -1, name: variable.key as? String ?? "", value: variable.value as? String ?? ""))
            }

            appRunner.updateCloudVariables(variables: variables)
        }
    }

    private static func updateCloudVariableInVariableSettings(snapshot: DataSnapshot, variableSettingsController: VariableSettingsController) {
        if let variableDic = snapshot.value as? NSDictionary {
            variableSettingsController.updateCloudVariable(variables: variableDic)
            /*
            var variables = [VariableSettingsController.VariableData]()
            for variable in variableDic {
                variables.append(VariableSettingsController.VariableData(type: .cloud, name: variable.key as? String ?? "", value: variable.value as? String ?? ""))
            }
            */
        }
    }

    static func setCloudVariable(varName: String, value: String) {
        ref.child(variablePath).updateChildValues([varName: value])
    }
}