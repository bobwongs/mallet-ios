//
//  HomeView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/28.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct HomeAppCell: View {
    var body: some View {
        VStack {
            HStack {
                Text("Untitled App")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            HStack {
                Spacer()
                Button(action: {
                    print("Edit")
                }) {
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

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        HomeAppCell()
                    }
                        .padding(10)
                        .padding(.top, 20)
                }
                    .navigationBarTitle("My Apps", displayMode: .large)
                    .navigationBarItems(trailing:
                            HStack {
                                Button(action: {
                                    print(114514)
                                }) {
                                    Image(systemName: "plus")
                                }
                        }
                    )
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .colorScheme(.dark)

            HomeView()
                .colorScheme(.light)
        }
    }
}
