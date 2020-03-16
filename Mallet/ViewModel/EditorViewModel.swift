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

    @Published var selectedUIGlobalPos: CGPoint? = nil

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

    func addUI(type: MUIType, frame: MUIRect, pos: CGPoint) {
        let uiID = maxUIID + 1
        let uiName = "\(type.rawValue)\(uiID)"

        uiIDs.append(uiID)
        uiData[uiID] = .defaultValue(uiID: uiID, uiName: uiName, type: type, frame: frame)

        selectUI(id: uiID, pos: pos)

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

        let diff = CGPoint(x: 20, y: 20)

        newUI.frameData.frame.x += diff.x
        newUI.frameData.frame.y += diff.y

        uiIDs.append(uiID)
        uiData[uiID] = newUI

        selectUI(id: uiID, pos: CGPoint(x: (selectedUIGlobalPos?.x ?? 0) + diff.x, y: (selectedUIGlobalPos?.y ?? 0) + diff.y))

        maxUIID += 1
    }

    func deleteUI() {
        guard let selectedUIID = self.selectedUIID else {
            return
        }

        uiData.removeValue(forKey: selectedUIID)
        uiIDs.removeAll(where: { $0 == selectedUIID })

        deselectUI()
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

    func selectUI(id: Int, pos: CGPoint) {
        selectedUIID = id
        textEditingUIID = nil
        selectedUIGlobalPos = pos
    }

    func deselectUI() {
        selectedUIID = nil
        textEditingUIID = nil
        selectedUIGlobalPos = nil
    }

    func editUIText(id: Int) {
        textEditingUIID = id
    }

    func endEditingUIText() {
        textEditingUIID = nil
    }
}
