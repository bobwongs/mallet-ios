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

    @State var initialDragAmount: CGFloat = 250

    @State var dragAmount: CGFloat = 250

    private let uiTableModalHeight: CGFloat = 300

    private let uiTableModalMaxVisibleHeight: CGFloat = 250

    private let uiTableModalMinVisibleHeight: CGFloat = 50

    var body: some View {
        ZStack (alignment: .bottom) {

            EditorAppView()

            EditorModalView()

            GeometryReader { geo in
                VStack {
                    Spacer()
                    VStack {
                        VStack {
                            Color.clear
                        }
                            .background(Color(.systemBackground))
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .gesture(DragGesture(coordinateSpace: .global)
                                    .onChanged({ value in
                                        self.dragAmount = max(self.uiTableModalHeight - self.uiTableModalMaxVisibleHeight, min(self.uiTableModalHeight - self.uiTableModalMinVisibleHeight, self.initialDragAmount + value.translation.height))
                                    })
                                    .onEnded({
                                        value in
                                        withAnimation(.easeOut(duration: 0.2)) {
                                            if value.translation.height < 0 {
                                                self.dragAmount = self.uiTableModalHeight - self.uiTableModalMaxVisibleHeight
                                            }
                                            else {
                                                self.dragAmount = self.uiTableModalHeight - self.uiTableModalMinVisibleHeight
                                            }
                                        }

                                        self.initialDragAmount = self.dragAmount
                                    })
                            )
                    }
                        .frame(maxHeight: self.uiTableModalHeight)
                        .offset(x: 0, y: self.dragAmount - geo.safeAreaInsets.bottom)
                }
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

    private func generateUI() -> some View {
        return Text("UI")
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultPreview {
            EditorView()
        }
    }
}
