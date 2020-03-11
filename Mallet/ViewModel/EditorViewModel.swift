//
//  EditorViewModel.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/02.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

class EditorViewModel: ObservableObject {

    @Published var appName: String

    @Published var appID: Int

    @Published var uiData: [MUI]

    @Published var selectedUIID: Int? = nil

    private var maxUIID: Int

    static var testModel: EditorViewModel {
        EditorViewModel(appName: "Yay",
                        appID: 0,
                        uiData: [])
    }

    init(appName: String, appID: Int, uiData: [MUI]) {
        self.appName = appName
        self.appID = appID
        self.uiData = uiData

        maxUIID = uiData.max(by: { (l, r) -> Bool in
            return l.uiID < r.uiID
        })?.uiID ?? -1
    }

    func addUI(type: MUIType, frame: MRect) {
        let uiID = maxUIID + 1
        let uiName = "\(type.rawValue)\(uiID)"

        uiData.append(.defaultValue(uiID: uiID, uiName: uiName, type: type, frame: frame))

        selectedUIID = uiID

        maxUIID += 1
    }

    func duplicateUI() {
        guard let ui = uiData.first(where: { $0.uiID == selectedUIID }) else {
            return
        }

        let uiId = maxUIID + 1
        let uiName = "\(ui.uiType.rawValue)\(uiId)"
        var frame = ui.frame
        frame.x += 20
        frame.y += 20

        uiData.append(MUI(uiID: uiId, uiName: uiName, uiType: ui.uiType, frame: frame))

        selectedUIID = uiId

        maxUIID += 1
    }

    func deleteUI() {
        uiData.removeAll(where: { $0.uiID == selectedUIID })
        selectedUIID = nil
    }
}
