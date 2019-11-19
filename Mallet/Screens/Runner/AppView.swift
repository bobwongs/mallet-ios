//
//  AppView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/19.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct AppView: View {

    let appName: String

    var body: some View {
        NavigationView {
            ZStack {
                Text("Text")
            }
                .navigationBarTitle(Text(appName), displayMode: .inline)
        }
            .colorScheme(.light)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(appName: "App")
    }
}
