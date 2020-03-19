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

    @Published var apps: Results<AppRealmObject> = Storage.allApps()

    private var notificationTokens: [NotificationToken] = []

    init() {
        notificationTokens.append(apps.observe { change in
            switch change {
            case let .initial(results):
                self.apps = results
            case let .update(results, _, _, _):
                self.apps = results
            case let .error(error):
                print(error.localizedDescription)
            }
        })
    }

    deinit {
        notificationTokens.forEach({ $0.invalidate() })
    }
}
