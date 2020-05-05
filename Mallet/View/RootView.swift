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
        ZStack {
            NavigationView {
                HomeView()
                    .environmentObject(HomeViewModel())
            }
                .navigationViewStyle(StackNavigationViewStyle())
                .zIndex(0)

            RunningAppView()
                .zIndex(1)
        }
    }
}

private struct RunningAppView: View {

    @ObservedObject var rootViewModel = AppController.rootViewModel

    var body: some View {
        ForEach(rootViewModel.runningApps, id: \.self) { viewModel in
            AppView()
                .environmentObject(viewModel)
                .transition(.asymmetric(insertion: .identity, removal: .move(edge: .bottom)))
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
