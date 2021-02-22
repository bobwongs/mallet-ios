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

    @Published var screen: Screen

    @Published var uiIDs: [Int]

    @Published var uiData: Dictionary<Int, MUI>

    @Published var selectedUIID: Int? = nil

    @Published var textEditingUIID: Int? = nil

    @Published var selectedUIGlobalFrame: CGRect? = nil

    private var maxUIID: Int

    convenience init() {
        self.init(appID: -1, appName: "Empty App", screen: .zero, uiIDs: [], uiData: [:])
    }

    convenience init(_ appData: AppData) {
        self.init(appID: appData.appID, appName: appData.appName, screen: appData.screen, uiIDs: appData.uiIDs, uiData: appData.uiData)
    }

    init(appID: Int, appName: String, screen: Screen, uiIDs: [Int], uiData: Dictionary<Int, MUI>) {
        self.appName = appName
        self.appID = appID
        self.screen = screen
        self.uiIDs = uiIDs
        self.uiData = uiData

        print(screen.gridW, screen.gridH)

        maxUIID = uiIDs.max(by: { (l, r) -> Bool in
            l < r
        }) ?? -1
    }

    func runApp() {
        saveAppSync()
        AppController.runApp(id: appID)
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
        guard  let selectedUIID = selectedUIID else {
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
        guard let selectedUIID = selectedUIID else {
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

// Storage
extension EditorViewModel {

    var currentAppData: AppData {
        AppData(appID: appID,
                appName: appName,
                screen: screen,
                uiIDs: uiIDs,
                uiData: uiData)
    }

    func saveApp() {
        Storage.saveApp(appData: currentAppData)
    }

    func saveAppSync() {
        Storage.saveAppSync(appData: currentAppData)
    }

}

// Grid
extension EditorViewModel {

    func findUIPosInGrid(uiGeo: GeometryProxy, appViewGeo: GeometryProxy) -> MUIRectInGrid {
        let appViewScale = appViewGeo.frame(in: .global).width / appViewGeo.size.width
        let padding = EditorAppViewInfo.gridRectPadding(screenSize: appViewGeo.size)
        let spacerHeight = EditorAppViewInfo.gridSpacerHeight(screenSize: appViewGeo.size, rectPadding: padding)
        let gridMaxHeight = EditorAppViewInfo.gridHeight1 + EditorAppViewInfo.gridHeight2
        let gridRectSizeWithPadding = EditorAppViewInfo.gridRectSize + padding * 2

        let globalUIFrame = uiGeo.frame(in: .global)
        let globalAppViewFrame = appViewGeo.frame(in: .global)

        let uiFrameInAppView = CGRect(x: (globalUIFrame.origin.x - globalAppViewFrame.origin.x) / appViewScale,
                                      y: (globalUIFrame.origin.y - globalAppViewFrame.origin.y) / appViewScale,
                                      width: uiGeo.size.width,
                                      height: uiGeo.size.height)

        let top: Int
        let left: Int
        let bottom: Int
        let right: Int

        let tempTop: Int
        let tempBottom: Int

        var isTopInSpacer = false
        var isBottomInSpacer = false

        let _top = Int((uiFrameInAppView.minY + padding) / gridRectSizeWithPadding) + 1
        if _top <= EditorAppViewInfo.gridHeight1 {
            tempTop = max(1, _top)
        } else if uiFrameInAppView.minY < gridRectSizeWithPadding * CGFloat(EditorAppViewInfo.gridHeight1) + spacerHeight + padding {
            tempTop = EditorAppViewInfo.gridHeight1 + 1
            isTopInSpacer = true
        } else {
            tempTop = min(gridMaxHeight, Int((uiFrameInAppView.minY + padding - spacerHeight) / gridRectSizeWithPadding) + 1)
        }

        let _bottom = gridMaxHeight - Int((appViewGeo.size.height - uiFrameInAppView.maxY + padding) / gridRectSizeWithPadding)
        if _bottom > EditorAppViewInfo.gridHeight1 {
            tempBottom = min(gridMaxHeight, _bottom)
        } else if uiFrameInAppView.maxY > gridRectSizeWithPadding * CGFloat(EditorAppViewInfo.gridHeight1) - padding {
            tempBottom = EditorAppViewInfo.gridHeight1
            isBottomInSpacer = true
        } else {
            tempBottom = max(1, EditorAppViewInfo.gridHeight1 - Int((gridRectSizeWithPadding * CGFloat(EditorAppViewInfo.gridHeight1) - uiFrameInAppView.maxY + padding) / gridRectSizeWithPadding))
        }

        if isTopInSpacer && isBottomInSpacer {
            if uiFrameInAppView.midY <= gridRectSizeWithPadding * CGFloat(EditorAppViewInfo.gridHeight1) + spacerHeight / 2 {
                top = EditorAppViewInfo.gridHeight1
                bottom = EditorAppViewInfo.gridHeight1
            } else {
                top = EditorAppViewInfo.gridHeight1 + 1
                bottom = EditorAppViewInfo.gridHeight1 + 1
            }
        } else {
            top = tempTop
            bottom = tempBottom
        }

        left = max(1, min(EditorAppViewInfo.gridWidth, Int((uiFrameInAppView.minX + padding) / gridRectSizeWithPadding) + 1))

        right = max(1, min(EditorAppViewInfo.gridWidth, EditorAppViewInfo.gridWidth - Int((appViewGeo.size.width - uiFrameInAppView.maxX + padding) / (gridRectSizeWithPadding))))

        return MUIRectInGrid(top: top, left: left, bottom: bottom, right: right)
    }

}