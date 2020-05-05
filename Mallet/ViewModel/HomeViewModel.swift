//
//  HomeViewModel.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/19.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation
import RealmSwift

class HomeViewModel: ObservableObject {

    struct AppInfo {
        let appID: Int
        let appName: String
    }

    @Published var apps = appLists2AppInfo(Storage.allAppLists())

    @Published var showingEditor = false

    @Published var showingSettings = false

    @Published var editorViewModel: EditorViewModel

    private var notificationTokens: [NotificationToken] = []

    init() {
        self.editorViewModel = EditorViewModel()

        let appLists = Storage.allAppLists()

        notificationTokens.append(appLists.observe { change in
            switch change {
            case let .initial(results):
                self.apps = HomeViewModel.appLists2AppInfo(results)
            case let .update(results, _, _, _):
                self.apps = HomeViewModel.appLists2AppInfo(results)
            case let .error(error):
                print(error.localizedDescription)
            }
        })
    }

    deinit {
        notificationTokens.forEach({ $0.invalidate() })
    }

    static func appLists2AppInfo(_ results: Results<AppList>) -> [AppInfo] {
        results.first?.apps.map {
            AppInfo(appID: $0.appID, appName: $0.appName)
        } ?? []
    }

    func runApp(id: Int) {
        AppController.runApp(id: id)
    }

    func openEditor(appID: Int? = nil) {
        if let appID = appID {
            editorViewModel = EditorViewModel(Storage.loadApp(appID: appID))
        } else {
            editorViewModel = EditorViewModel(Storage.createNewApp())
        }
        showingEditor = true
    }

    func closeEditor() {
        showingEditor = false
    }
}
