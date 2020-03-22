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

    @Published var apps = Storage.allAppLists().first?.apps.map {
        AppInfo(appID: $0.appID, appName: $0.appName)
    } ?? []

    private var notificationTokens: [NotificationToken] = []

    init() {
        let appLists = Storage.allAppLists()

        notificationTokens.append(appLists.observe { change in
            switch change {
            case let .initial(results):
                self.apps = results.first?.apps.map {
                    AppInfo(appID: $0.appID, appName: $0.appName)
                } ?? []
            case let .update(results, _, _, _):
                self.apps = results.first?.apps.map {
                    AppInfo(appID: $0.appID, appName: $0.appName)
                } ?? []
            case let .error(error):
                print(error.localizedDescription)
            }
        })
    }

    deinit {
        notificationTokens.forEach({ $0.invalidate() })
    }
}
