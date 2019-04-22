//
//  DataSource.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

struct AppInfo {
    let title: String
}

struct AppInfoDataSource {
    let appInfo = [
        AppInfo(title: "App1"),
        AppInfo(title: "App2"),
        AppInfo(title: "App3"),
    ]
}
