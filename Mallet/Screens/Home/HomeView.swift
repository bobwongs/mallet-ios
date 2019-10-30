//
//  HomeView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/28.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct HomeAppCell: View {

    var appID: Int

    var appName: String

    var body: some View {
        Button(action: {
            print("Run App")
        }) {
            VStack {
                HStack {
                    Text(self.appName)
                        .foregroundColor(Color(UIColor.label))
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()
                }
                HStack {
                    Spacer()
                    NavigationLink(destination: EditorView()) {
                        Image(systemName: "pencil")
                    }
                }

            }
                .frame(maxWidth: .infinity)
                .padding(15)
                .background(Color(UIColor.systemFill))
                .cornerRadius(10)
        }
    }

    func moveToEditor() {

    }
}

struct HomeView: View {

    struct app {
        let appID: Int
        let appName: String
    }

    @State var appData = [app]()

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        ForEach(self.appData, id: \.appID) { appData in
                            HomeAppCell(appID: appData.appID, appName: appData.appName)
                        }

                    }
                        .padding(10)
                        .padding(.top, 20)
                }
                    .navigationBarTitle("My Apps", displayMode: .large)
                    .navigationBarItems(trailing:
                            HStack {
                                Button(action: {
                                    print("Add app")
                                }) {
                                    Image(systemName: "plus")
                                }
                        }
                    )
            }
        }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: {
                self.reloadAppData()
            })
    }

    func reloadAppData() {
        self.appData = [app(appID: 0, appName: "Awesome App"), app(appID: 1, appName: "Cool App")]
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .colorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))

            HomeView()
                .colorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))

            HomeView()
                .colorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))

            HomeView()
                .colorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
        }
    }
}
