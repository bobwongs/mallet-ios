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

    private let rootViewModel: RootViewModel

    @Published var apps = appLists2AppInfo(Storage.allAppLists())

    private var notificationTokens: [NotificationToken] = []

    init(rootViewModel: RootViewModel) {
        self.rootViewModel = rootViewModel

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
        rootViewModel.runApp(id: id)
    }
}
