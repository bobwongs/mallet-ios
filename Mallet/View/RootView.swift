//
//  RootView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/27.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct RootView: View {

    var body: some View {
        NavigationView {
            HomeView()
        }
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
