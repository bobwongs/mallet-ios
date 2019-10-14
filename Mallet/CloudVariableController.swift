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
    private static let variablePath = "variable"

    private static let db = Firestore.firestore()

    private static var ref = db.collection("variables").document("variables")

    private static var listener: ListenerRegistration?

    static func startApp(appRunner: AppRunner) {

        DispatchQueue.global().async {
            ref.getDocument { (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }

                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }

                DispatchQueue.main.async {
                    CloudVariableController.updateCloudVariable(data: data, appRunner: appRunner)
                }
            }
        }

        self.listener = ref.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }

            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }

            CloudVariableController.updateCloudVariable(data: data, appRunner: appRunner)
        }
    }

    static func endApp() {
        self.listener?.remove()
    }

    static func startVariableSettings(variableSettingsController: VariableSettingsController) {
        self.listener?.remove()

        ref.getDocument { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }

            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }

            CloudVariableController.updateCloudVariableInVariableSettings(data: data, variableSettingsController: variableSettingsController)
        }

        self.listener = ref.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }

            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }

            CloudVariableController.updateCloudVariableInVariableSettings(data: data, variableSettingsController: variableSettingsController)
        }
    }

    static func endVariableSettings() {
        self.listener?.remove()
    }

    private static func updateCloudVariable(data: [String: Any], appRunner: AppRunner) {
        var variables = [AppVariable]()
//            var lists = []
        for variable in data {
            if let str = variable.value as? String {
                variables.append(AppVariable(address: -1, name: variable.key, value: str))
            }

            if let array = variable.value as? Array<String> {
                print("array-san")
            }
        }

        appRunner.updateCloudVariables(variables: variables)
    }

    private static func updateCloudVariableInVariableSettings(data: [String: Any], variableSettingsController: VariableSettingsController) {
        variableSettingsController.updateCloudVariable(variables: data)
    }

    static func setCloudVariable(varName: String, value: String) {
        ref.updateData([varName: value]) { error in
            print(error)
        }
    }
}
