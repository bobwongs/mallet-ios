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
                        uiData: [MUI(uiID: 0, uiName: "Text", uiType: .text, frame: MRect(x: 100, y: 100, width: 200, height: 100)),
                                 MUI(uiID: 1, uiName: "Yay", uiType: .text, frame: MRect(x: 100, y: 200, width: 200, height: 100)),
                                 MUI(uiID: 2, uiName: "Button", uiType: .button, frame: MRect(x: 200, y: 200, width: 100, height: 100))
                        ])
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
        let uiId = maxUIID + 1
        let uiName = "\(type.rawValue)\(uiId)"

        uiData.append(MUI(uiID: uiId, uiName: uiName, uiType: type, frame: frame))

        selectedUIID = uiId

        maxUIID += 1
    }
}