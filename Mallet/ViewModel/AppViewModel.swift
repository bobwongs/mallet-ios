//
//  AppViewModel.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/03.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class AppViewModel: ObservableObject {

    let appName: String

    let appId: Int

    let uiIDs: [Int]

    @Published var uiData: Dictionary<Int, MUI>

    init() {
        appName = "Untitled App"
        appId = -1
        uiIDs = []
        uiData = .init()
    }

    init(_ appData: AppData) {
        appName = appData.appName
        appId = appData.appID
        uiIDs = appData.uiIDs
        uiData = appData.uiData
    }

    func getUIDataOf(_ id: Int) -> Binding<MUI> {
        Binding(
            get: { self.uiData[id] ?? MUI.none },
            set: { self.uiData[id] = $0 }
        )
    }
}

extension AppViewModel: Hashable {
    static func ==(lhs: AppViewModel, rhs: AppViewModel) -> Bool {
        lhs.appName == rhs.appName &&
            lhs.appId == rhs.appId &&
            lhs.uiIDs == rhs.uiIDs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(appName)
        hasher.combine(appId)
        hasher.combine(uiIDs)
    }
}
