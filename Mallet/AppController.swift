//
//  AppController.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/05.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class AppController {

    static let rootViewModel = RootViewModel()

    static func runApp(id: Int) {
        rootViewModel.runApp(id: id)
    }

    static func exitApp(id: Int) {
        rootViewModel.exitApp(id: id)
    }

}
