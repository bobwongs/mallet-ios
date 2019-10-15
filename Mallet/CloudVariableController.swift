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

class CloudVariableController: NSObject {
    private static let variablePath = "variable"

    private static let db = Firestore.firestore()

    private static var ref = db.collection("variables").document("variables")

    private static var listener: ListenerRegistration?

    static let randomPrefixLength = "yyyyMMddHHmmssSSS".count + 5

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
        appRunner.updateCloudVariables(variables: data)
    }

    private static func updateCloudVariableInVariableSettings(data: [String: Any], variableSettingsController: VariableSettingsController) {
        variableSettingsController.updateCloudVariable(variables: data)
    }

    @objc static func setCloudVariable(varName: String, value: String) {
        ref.updateData([varName: value]) { error in
            print(error)
        }
    }

    static func setCloudList(varName: String, value: [String]) {
        let randomPrefix = generateRandomPrefix()

        var prefixedValue = [String]()
        for element in value {
            prefixedValue.append(randomPrefix + element)
        }

        ref.updateData([varName: prefixedValue]) { error in
            print(error)
        }
    }

    @objc static func setCloudList(varName: String, value: NSMutableArray) {
        var stringValue = [String]()
        for element in value {
            stringValue.append((element as? String) ?? "")
        }

        CloudVariableController.setCloudList(varName: varName, value: stringValue)
    }

    @objc static func addToCloudList(varName: String, value: String) {
        print("\(varName) \(value)")
        ref.updateData([varName: FieldValue.arrayUnion([CloudVariableController.generateRandomPrefix() + value])]) { error in
            print(error)
        }
    }

    private static func generateRandomPrefix() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMddHHmmssSSS"
        let randomStr = String(format: "%05d", Int.random(in: 0..<99999))

        return format.string(from: Date()) + randomStr
    }
}
