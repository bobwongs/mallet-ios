//
//  RootViewModel.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/04.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class RootViewModel: ObservableObject {

    @Published var showingApp = false

    @Published var frontApp: AppViewModel? = nil

    private var runningApps = [AppViewModel]()

    init() {
    }

    func runApp(id: Int) {
        if runningApps.contains(where: { $0.appId == id }) {
            return
        }

        if !showingApp {
            withAnimation {
                showingApp = true
                StatusBar.style = .darkContent
            }
        }

        let appData = Storage.loadApp(appID: id)
        let appViewModel = AppViewModel(appData: appData, rootViewModel: self)
        runningApps.append(appViewModel)
        frontApp = appViewModel

        StatusBar.style = .darkContent
    }

    func exitApp(id: Int) {
        runningApps.removeLast()

        if let preAppViewModel = runningApps.last {
            frontApp = preAppViewModel
        } else {
            frontApp = nil
            withAnimation {
                showingApp = false
                StatusBar.style = .default
            }
        }
    }

}
