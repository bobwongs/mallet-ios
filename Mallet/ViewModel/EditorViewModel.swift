//
//  EditorViewModel.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/02.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class EditorViewModel: ObservableObject {

    private let rootViewModel: RootViewModel

    @Published var appName: String

    @Published var appID: Int

    @Published var uiIDs: [Int]

    @Published var uiData: Dictionary<Int, MUI>

    @Published var selectedUIID: Int? = nil

    @Published var textEditingUIID: Int? = nil

    @Published var selectedUIGlobalFrame: CGRect? = nil

    private var maxUIID: Int

    convenience init(rootViewModel: RootViewModel) {
        self.init(appID: -1, appName: "Empty App", uiIDs: [], uiData: [:], rootViewModel: rootViewModel)
    }

    convenience init(_ appData: AppData, rootViewModel: RootViewModel) {
        self.init(appID: appData.appID, appName: appData.appName, uiIDs: appData.uiIDs, uiData: appData.uiData, rootViewModel: rootViewModel)
    }

    init(appID: Int, appName: String, uiIDs: [Int], uiData: Dictionary<Int, MUI>, rootViewModel: RootViewModel) {
        self.rootViewModel = rootViewModel
        self.appName = appName
        self.appID = appID
        self.uiIDs = uiIDs
        self.uiData = uiData

        maxUIID = uiIDs.max(by: { (l, r) -> Bool in
            return l < r
        }) ?? -1
    }

    func runApp() {
        rootViewModel.runApp(id: appID)
    }

    func addUI(type: MUIType, frame: MUIRect, globalFrame: CGRect) {
        let uiID = maxUIID + 1
        let uiName = "\(type.rawValue)\(uiID)"

        uiIDs.append(uiID)
        uiData[uiID] = .defaultValue(uiID: uiID, uiName: uiName, type: type, frame: frame)

        selectUI(id: uiID, frame: globalFrame)

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

        selectUI(id: uiID, frame: CGRect(x: (selectedUIGlobalFrame?.origin.x ?? 0) + diff.x,
                                         y: (selectedUIGlobalFrame?.origin.x ?? 0) + diff.y,
                                         width: selectedUIGlobalFrame?.width ?? 0,
                                         height: selectedUIGlobalFrame?.height ?? 0))

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

    func selectUI(id: Int, frame: CGRect) {
        selectedUIID = id
        textEditingUIID = nil
        selectedUIGlobalFrame = frame
    }

    func deselectUI() {
        selectedUIID = nil
        textEditingUIID = nil
        selectedUIGlobalFrame = nil
    }

    func editUIText(id: Int) {
        textEditingUIID = id
    }

    func endEditingUIText() {
        textEditingUIID = nil
    }

    func moveToFront() {
        guard let uiID = selectedUIID else {
            return
        }

        uiIDs.removeAll(where: { $0 == uiID })
        uiIDs.append(uiID)
    }

    func moveForward() {
        guard let uiID = selectedUIID else {
            return
        }

        guard let idx = uiIDs.firstIndex(of: uiID) else {
            return
        }

        uiIDs.swapAt(idx, min(idx + 1, uiIDs.count - 1))
    }

    func moveToBack() {
        guard let uiID = selectedUIID else {
            return
        }

        uiIDs.removeAll(where: { $0 == uiID })
        uiIDs.insert(uiID, at: 0)
    }

    func moveBackward() {
        guard let uiID = selectedUIID else {
            return
        }

        guard let idx = uiIDs.firstIndex(of: uiID) else {
            return
        }

        uiIDs.swapAt(idx, max(idx - 1, 0))
    }
}

extension EditorViewModel {

    func saveApp() {
        let appData = AppData(appID: appID,
                              appName: appName,
                              uiIDs: uiIDs,
                              uiData: uiData)

        Storage.saveApp(appData: appData)
    }

}
