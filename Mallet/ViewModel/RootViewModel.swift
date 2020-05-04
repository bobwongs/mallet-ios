//
//  RootViewModel.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/04.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

class RootViewModel: ObservableObject {

    @Published var runningApps = [AppViewModel]()

    init() {
        runningApps.append(AppViewModel(rootViewModel: self))
    }

    func runApp(id: Int) {
        let appData = Storage.loadApp(appID: id)
        runningApps.append(AppViewModel(appData: appData, rootViewModel: self))
    }

    func exitApp(id: Int) {
        runningApps.removeAll {
            $0.appId == id
        }
    }

}
