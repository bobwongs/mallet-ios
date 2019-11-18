//
//  EditorView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/30.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorView: View {

    @State var showingAppSettingsView = false

    @State var initialDragAmount: CGFloat = 0.0

    @State var dragAmount: CGFloat = 0.0

    var body: some View {
        ZStack (alignment: .bottom) {
            ZStack {
                Spacer()
            }
                .background(Color.white)

            VStack {
                Spacer()
                VStack {
                    VStack {
                        Color(.systemBackground)
                    }
                        .cornerRadius(20)
                        .gesture(DragGesture(coordinateSpace: .global)
                                .onChanged({ value in
                                    self.dragAmount = self.initialDragAmount + value.translation.height
                                })
                                .onEnded({
                                    value in
                                    self.initialDragAmount = self.dragAmount
                                })
                        )
                }
                    .frame(maxHeight: 300)
                    .offset(x: 0, y: dragAmount)
            }
        }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("App Title", displayMode: .inline)
            .navigationBarItems(trailing:
                    HStack {
                        Button(action: {
                            self.showingAppSettingsView = true
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                            .sheet(isPresented: self.$showingAppSettingsView) {
                                AppSettingsView()
                        }

                        Button(action: {
                            print("Run")
                        }) {
                            Image(systemName: "play.fill")
                        }
                }
            )
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EditorView()
            }
                .colorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .navigationViewStyle(StackNavigationViewStyle())


            NavigationView {
                EditorView()
            }
                .colorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .navigationViewStyle(StackNavigationViewStyle())

            NavigationView {
                EditorView()
            }
                .colorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .navigationViewStyle(StackNavigationViewStyle())

            NavigationView {
                EditorView()
            }
                .colorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
