//
//  EditorViewModel.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/02.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class EditorViewModel: ObservableObject {

    @Published var appName: String

    @Published var appID: Int

    @Published var uiIDs: [Int]

    @Published var uiData: Dictionary<Int, MUI>

    @Published var selectedUIID: Int? = nil

    @Published var textEditingUIID: Int? = nil

    private var maxUIID: Int

    static var testModel: EditorViewModel {
        EditorViewModel(appName: "Yay",
                        appID: 0,
                        uiIDs: [],
                        uiData: [:])
    }

    init(appName: String, appID: Int, uiIDs: [Int], uiData: Dictionary<Int, MUI>) {
        self.appName = appName
        self.appID = appID
        self.uiIDs = uiIDs
        self.uiData = uiData

        maxUIID = uiIDs.max(by: { (l, r) -> Bool in
            return l < r
        }) ?? -1
    }

    func addUI(type: MUIType, frame: MUIRect) {
        let uiID = maxUIID + 1
        let uiName = "\(type.rawValue)\(uiID)"

        uiIDs.append(uiID)
        uiData[uiID] = .defaultValue(uiID: uiID, uiName: uiName, type: type, frame: frame)

        selectUI(id: uiID)

        maxUIID += 1
    }

    func duplicateUI() {
        guard  let selectedUIID = self.selectedUIID else {
            return
        }

        guard let ui = uiData[selectedUIID] else {
            return
        }

        let uiID = maxUIID + 1
        let uiName = "\(ui.uiType.rawValue)\(uiID)"
        var newUI = MUI.copyUIData(uiData: ui, uiID: uiID, uiName: uiName)

        newUI.frameData.frame.x += 20
        newUI.frameData.frame.y += 20

        uiIDs.append(uiID)
        uiData[uiID] = newUI

        selectUI(id: uiID)

        maxUIID += 1
    }

    func deleteUI() {
        guard let selectedUIID = self.selectedUIID else {
            return
        }

        uiData.removeValue(forKey: selectedUIID)
        uiIDs.removeAll(where: { $0 == selectedUIID })

        selectUI(id: nil)
    }

    func getUIDataOf(_ id: Int) -> Binding<MUI> {
        Binding(
            get: { self.uiData[id] ?? MUI.none },
            set: { self.uiData[id] = $0 }
        )
    }

    func getSelectedUIData() -> Binding<MUI> {
        if let id = selectedUIID {
            return getUIDataOf(id)
        } else {
            return .constant(.none)
        }
    }

    func selectUI(id: Int?) {
        selectedUIID = id
        textEditingUIID = nil
    }

    func editUIText(id: Int) {
        textEditingUIID = id
    }

    func endEditingUIText() {
        textEditingUIID = nil
    }
}
