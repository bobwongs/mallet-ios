//
//  AppViewModel.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/03.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import XyloSwift

class AppViewModel: ObservableObject {

    private let rootViewModel: RootViewModel

    private var eval: Xylo?

    let appName: String

    let appId: Int

    let uiIDs: [Int]

    @Published var uiData: Dictionary<Int, MUI>

    convenience init(rootViewModel: RootViewModel) {
        self.init(appData: AppData(appID: -1, appName: "Untitled App", uiIDs: [], uiData: .init()), rootViewModel: rootViewModel)
    }

    init(appData: AppData, rootViewModel: RootViewModel) {
        self.rootViewModel = rootViewModel
        appName = appData.appName
        appId = appData.appID
        uiIDs = appData.uiIDs
        uiData = appData.uiData

        eval = Xylo(source: xyloCode(), funcs: muiActions())

        #if DEBUG
            print("""
                  ###################
                  ### Source Code ###
                  ###################

                  \(xyloCode())

                  ###################
                  ###################
                  ###################
                  """)
        #endif
    }

    func getUIDataOf(_ id: Int) -> Binding<MUI> {
        Binding(
            get: { self.uiData[id] ?? MUI.none },
            set: { self.uiData[id] = $0 }
        )
    }

    func exitApp() {
        rootViewModel.exitApp(id: appId)
    }
}

extension AppViewModel {
    func getUIData(_ obj: XyObj) -> Binding<MUI> {
        getUIDataOf(obj.int())
    }
}

extension AppViewModel {
    func run() {
        eval?.run()
    }

    func xyloCode() -> String {
        String(uiData.flatMap { _, ui in ui.getCodeStr() })
    }

    private func muiActions() -> [Xylo.Func] {
        [
            muiBackgroundFuncs,
            muiFrameFuncs,
            muiSliderFuncs,
            muiTextFuncs,
            muiTextFieldFuncs,
            muiToggleFuncs,
        ].flatMap { $0 }
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
