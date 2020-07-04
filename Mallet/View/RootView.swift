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
        Spacer()
            .fullScreenCover(isPresented: $rootViewModel.showingApp) {
                if let app = rootViewModel.frontApp {
                    AppView()
                        .environmentObject(app)
                }
            }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
