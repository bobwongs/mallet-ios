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

    @State private var showingUIStyleEditorView = false

    @State private var showingAppSettingsView = false

    @State private var appViewOffset = CGPoint.zero

    @State private var appViewScale: CGFloat = 0.8

    @State private var modalOffset: CGFloat = 0

    @State private var selectedUIType: MUIType = .space

    @State private var selectedUIFrame = CGRect.zero

    @State private var editorOffset: CGFloat = 0

    private var spacerHeightAboveUIStyleEditor: CGFloat {
        UIScreen.main.bounds.height - min(UIScreen.main.bounds.height * 0.7, 500)
    }

    @State private var safeAreaTopInset: CGFloat = 0

    private let modalControlBarHeight: CGFloat = 30

    private let toolBarHeight: CGFloat = 40

    private let appViewPadding: CGFloat = 700

    private let scrollViewInvisibleHeight: CGFloat = 50


    let closeEditor: () -> Void

    var body: some View {
        ZStack {
            Color.gray

            GeometryReader { screenGeo in
                VStack(spacing: 0) {
                    self.appView(screenGeo: screenGeo)

                    Spacer()
                        .frame(height: screenGeo.safeAreaInsets.bottom + self.toolBarHeight + self.modalControlBarHeight - self.scrollViewInvisibleHeight)
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

                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: self.spacerHeightAboveUIStyleEditor)

                        if self.showingUIStyleEditorView {
                            UIStyleEditorView(
                                bottomInset: self.toolBarHeight + geo.safeAreaInsets.bottom,
                                closeEditor: { self.closeUIStyleEditor() })
                                .environmentObject(self.editorViewModel)
                                .transition(.move(edge: .bottom))
                        }
                    }
                        .edgesIgnoringSafeArea(.top)
                        .onAppear {
                            self.safeAreaTopInset = geo.safeAreaInsets.top
                        }

                    EditorToolBar(offset: self.$modalOffset,
                                  height: self.toolBarHeight,
                                  toggleUIStyleEditor: { self.toggleUIStyleEditor() }
                    )
                        .environmentObject(self.editorViewModel)

                    if self.selectedUIType != .space {
                        UISelectionView.generateUI(type: self.selectedUIType)
                            .environmentObject(self.editorViewModel)
                            .frame(width: self.selectedUIFrame.width, height: self.selectedUIFrame.height)
                            .background(MUI.defaultValue(type: self.selectedUIType).backgroundData.color.color)
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
            .navigationBarTitle("\(editorViewModel.appName)", displayMode: .inline)
            .navigationBarItems(leading: navigationBarLeadingUI(), trailing: navigationBarTrailingUI())
            .onDisappear {
                self.editorViewModel.saveApp()
            }
    }

    private func appView(screenGeo: GeometryProxy) -> some View {

        let scrollViewVisibleHeight = screenGeo.size.height + screenGeo.safeAreaInsets.top - screenGeo.safeAreaInsets.bottom - self.toolBarHeight - modalControlBarHeight

        let editorOffset = max(self.editorOffset, -(scrollViewVisibleHeight - self.spacerHeightAboveUIStyleEditor))

        return GeometryReader { geo in
            EditorAppScrollView(scale: self.$appViewScale,
                                offset: self.$appViewOffset,
                                scrollViewSize: geo.size,
                                contentSize: CGSize(width: screenGeo.size.width, height: screenGeo.size.height),
                                contentPadding: self.appViewPadding,
                                maxInsets: UIEdgeInsets(top: 20 + geo.safeAreaInsets.top, left: 20, bottom: 20 + self.scrollViewInvisibleHeight, right: 20),
                                initialOffset: CGPoint(x: 0, y: 0)
            ) {
                EditorAppView(appViewScale: self.$appViewScale)
                    .environmentObject(self.editorViewModel)
                    .edgesIgnoringSafeArea(.all)
                    .padding(self.appViewPadding)
            }
        }
            .offset(y: editorOffset)
            .edgesIgnoringSafeArea(.all)
    }

    private func navigationBarLeadingUI() -> some View {
        Button(action: {
            self.editorViewModel.saveApp()
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
                self.showingAppSettingsView = true
            }) {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
                .sheet(isPresented: $showingAppSettingsView) {
                    AppSettingsView()
                        .environmentObject(self.editorViewModel)
                }

            Spacer()
                .frame(width: 20)

            Button(action: {
                self.editorViewModel.runApp()
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

    private func toggleUIStyleEditor() {

        let newEditorOffset: CGFloat

        if showingUIStyleEditorView {
            newEditorOffset = 0
        } else {
            if let selectedUIGlobalFrame = editorViewModel.selectedUIGlobalFrame {
                if spacerHeightAboveUIStyleEditor - safeAreaTopInset > selectedUIGlobalFrame.height {
                    let maxY = spacerHeightAboveUIStyleEditor - 10
                    newEditorOffset = min(0, maxY - selectedUIGlobalFrame.maxY)
                } else {
                    let centerY = (spacerHeightAboveUIStyleEditor + safeAreaTopInset) / 2
                    newEditorOffset = min(0, centerY - selectedUIGlobalFrame.midY)
                }
            } else {
                newEditorOffset = 0
            }
        }

        withAnimation(.spring(response: 0.45, dampingFraction: 1)) {
            editorOffset = newEditorOffset
            showingUIStyleEditorView.toggle()
        }

    }

    private func closeUIStyleEditor() {
        withAnimation(.spring(response: 0.45, dampingFraction: 1)) {
            editorOffset = 0
            showingUIStyleEditorView = false
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
