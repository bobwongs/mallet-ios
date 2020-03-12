//
//  EditorView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/30.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorView: View {

    @EnvironmentObject var editorViewModel: EditorViewModel

    @State private var showAppSettingsView = false

    @State private var appViewOffset = CGPoint.zero

    @State private var appViewScale: CGFloat = 0.8

    @State private var modalOffset: CGFloat = 0

    @State private var selectedUIType: MUIType = .space

    @State private var selectedUIFrame = CGRect.zero

    private let modalControlBarHeight: CGFloat = 30

    private let toolBarHeight: CGFloat = 40

    private let appViewPadding: CGFloat = 300

    private let scrollViewMaxInsets = UIEdgeInsets(top: 30, left: 30, bottom: 40, right: 30)

    private let scrollViewInitialOffset = CGPoint(x: 0, y: 10)

    let closeEditor: () -> Void

    var body: some View {
        ZStack {
            Color.gray

            GeometryReader { screenGeo in
                VStack(spacing: 0) {
                    GeometryReader { geo in
                        EditorAppScrollView(scale: self.$appViewScale,
                                            offset: self.$appViewOffset,
                                            scrollViewSize: geo.size,
                                            contentSize: CGSize(width: screenGeo.size.width, height: screenGeo.size.height),
                                            contentPadding: self.appViewPadding,
                                            maxInsets: self.scrollViewMaxInsets,
                                            initialOffset: self.scrollViewInitialOffset
                        ) {
                            EditorAppView(appViewScale: self.$appViewScale)
                                .environmentObject(self.editorViewModel)
                                .edgesIgnoringSafeArea(.all)
                                .padding(self.appViewPadding)
                        }
                    }

                    Spacer()
                        .frame(height: screenGeo.safeAreaInsets.bottom + self.toolBarHeight + self.modalControlBarHeight - 10)
                }
            }

            GeometryReader { geo in
                ZStack {
                    SemiModalView(height: 200,
                                  minHeight: self.toolBarHeight,
                                  controlBarHeight: self.modalControlBarHeight,
                                  offset: self.$modalOffset) {
                        UISelectionView(editorGeo: geo,
                                        closeModalView: { self.closeModalView() },
                                        selectedUIType: self.$selectedUIType,
                                        selectedUIFrame: self.$selectedUIFrame,
                                        appViewScale: self.$appViewScale,
                                        appViewOffset: self.$appViewOffset
                        )
                    }

                    EditorToolBar(offset: self.$modalOffset, height: self.toolBarHeight)
                        .environmentObject(self.editorViewModel)

                    if self.selectedUIType != .space {
                        UISelectionView.generateUI(type: self.selectedUIType)
                            .environmentObject(self.editorViewModel)
                            .frame(width: self.selectedUIFrame.width, height: self.selectedUIFrame.height)
                            .background(MUI.defaultValue(type: self.selectedUIType).backgroundData.color.toColor)
                            .cornerRadius(MUI.defaultValue(type: self.selectedUIType).backgroundData.cornerRadius)
                            .scaleEffect(self.appViewScale)
                            .position(x: self.selectedUIFrame.midX - geo.frame(in: .global).origin.x,
                                      y: self.selectedUIFrame.midY - geo.frame(in: .global).origin.y)
                    }
                }
            }
        }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("Untitled App", displayMode: .inline)
            .navigationBarItems(leading: navigationBarLeadingUI(), trailing: navigationBarTrailingUI())
    }

    private func navigationBarLeadingUI() -> some View {
        Button(action: {
            self.closeEditor()
        }) {
            Text("Done")
                .fontWeight(.semibold)
                .padding([.top, .bottom], 7)
        }
    }

    private func navigationBarTrailingUI() -> some View {
        HStack(alignment: .center) {
            Button(action: {
                self.showAppSettingsView = true
            }) {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
                .sheet(isPresented: self.$showAppSettingsView) {
                    AppSettingsView()
                }

            Spacer()
                .frame(width: 20)

            Button(action: {
                print("Run")
            }) {
                Image(systemName: "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
            .frame(height: 20)
    }

    private func generateUI() -> some View {
        return Text("UI")
    }

    private func closeModalView() {
        withAnimation(.easeOut(duration: 0.2)) {
            self.modalOffset = 0
        }
    }

}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultPreview {
            EditorView(closeEditor: {})
        }
    }
}
