//
//  RootView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/27.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct RootView: View {

    @ObservedObject var rootViewModel = RootViewModel()

    var body: some View {
        ZStack {
            NavigationView {
                HomeView()
            }
                .navigationViewStyle(StackNavigationViewStyle())

            ForEach(rootViewModel.runningApps, id: \.self) { viewModel in
                AppView()
                    .environmentObject(viewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
