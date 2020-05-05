//
//  RootViewModel.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/04.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class RootViewModel: ObservableObject {

    @Published var runningApps = [AppViewModel]()

    init() {
    }

    func runApp(id: Int) {
        if runningApps.contains(where: { $0.appId == id }) {
            return
        }

        let appData = Storage.loadApp(appID: id)
        runningApps.append(AppViewModel(appData: appData, rootViewModel: self))

        StatusBar.style = .darkContent
    }

    func exitApp(id: Int) {
        withAnimation {
            runningApps.removeAll {
                $0.appId == id
            }
        }

        StatusBar.style = .default
    }

}
