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

    @State private var showingCodeEditorView = false

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
                .ignoresSafeArea(edges: .bottom)

            GeometryReader { appScreenGeo in
                VStack(spacing: 0) {
                    appView(appScreenGeo: appScreenGeo)
                    Spacer()
                        .frame(height: appScreenGeo.safeAreaInsets.bottom + toolBarHeight + modalControlBarHeight - scrollViewInvisibleHeight)
                }
                    .ignoresSafeArea(edges: .all)
            }
                .ignoresSafeArea(.keyboard)

            GeometryReader { geo in
                ZStack {
                    SemiModalView(height: 200,
                                  minHeight: toolBarHeight,
                                  controlBarHeight: modalControlBarHeight,
                                  offset: self.$modalOffset) {
                        UISelectionView(editorGeo: geo,
                                        closeModalView: closeModalView,
                                        addUI: editorViewModel.addUI,
                                        selectedUIType: self.$selectedUIType,
                                        selectedUIFrame: self.$selectedUIFrame,
                                        appViewScale: self.$appViewScale,
                                        appViewOffset: self.$appViewOffset
                        )
                    }

                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: spacerHeightAboveUIStyleEditor)

                        if showingUIStyleEditorView {
                            UIStyleEditorView(
                                bottomInset: toolBarHeight + geo.safeAreaInsets.bottom,
                                closeEditor: { closeUIStyleEditor() })
                                .environmentObject(editorViewModel)
                                .transition(.move(edge: .bottom))
                        }
                    }
                        .ignoresSafeArea(.all, edges: .all)
                        .onAppear {
                            self.safeAreaTopInset = geo.safeAreaInsets.top
                        }

                    EditorToolBar(offset: self.$modalOffset,
                                  height: toolBarHeight,
                                  toggleUIStyleEditor: toggleUIStyleEditor,
                                  openCodeEditor: openCodeEditor,
                                  deleteUI: editorViewModel.deleteUI,
                                  duplicateUI: editorViewModel.duplicateUI
                    )
                        .equatable()

                    if selectedUIType != .space {
                        UISelectionView.generateUI(type: selectedUIType)
                            .overlay(
                                GeometryReader { geo in
                                    Spacer()
                                        .onChange(of: geo.frame(in: .global)) { frame in
                                            editorViewModel.selectUI(id: MUI.none.uiID)
                                            editorViewModel.setSelectedUIGlobalFrame(geo.frame(in: .global))
                                        }
                                }
                            )
                            .environmentObject(editorViewModel)
                            .frame(width: selectedUIFrame.width, height: selectedUIFrame.height)
                            .background(MUI.defaultValue(type: selectedUIType).backgroundData.color.color)
                            .cornerRadius(MUI.defaultValue(type: selectedUIType).backgroundData.cornerRadius)
                            .scaleEffect(appViewScale)
                            .position(x: selectedUIFrame.midX - geo.frame(in: .global).origin.x,
                                      y: selectedUIFrame.midY - geo.frame(in: .global).origin.y)
                    }
                }
            }
                .ignoresSafeArea(.keyboard)
        }
            .sheet(isPresented: $showingCodeEditorView) {
                CodeEditorView(uiData: editorViewModel.getSelectedUIData())
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("\(editorViewModel.appName)", displayMode: .inline)
            .navigationBarItems(leading: navigationBarLeadingUI(), trailing: navigationBarTrailingUI())
            .onDisappear {
                editorViewModel.saveApp()
            }
    }

    private func appView(appScreenGeo: GeometryProxy) -> some View {

        let scrollViewVisibleHeight = appScreenGeo.size.height + appScreenGeo.safeAreaInsets.top - appScreenGeo.safeAreaInsets.bottom - toolBarHeight - modalControlBarHeight

        let editorOffset = max(self.editorOffset, -(scrollViewVisibleHeight - spacerHeightAboveUIStyleEditor))

        return GeometryReader { geo in
            EditorAppScrollView(scale: self.$appViewScale,
                                offset: self.$appViewOffset,
                                scrollViewSize: geo.size,
                                contentSize: appScreenGeo.size,
                                contentPadding: appViewPadding,
                                maxInsets: UIEdgeInsets(top: 20 + appScreenGeo.safeAreaInsets.top, left: 20, bottom: 20 + scrollViewInvisibleHeight, right: 20),
                                initialOffset: CGPoint(x: 0, y: 0)
            ) {
                EditorAppView(appViewScale: self.$appViewScale)
                    .frame(width: appScreenGeo.size.width, height: appScreenGeo.size.height)
                    .environmentObject(editorViewModel)
                    .padding(appViewPadding)
            }
        }
            .offset(y: editorOffset)
    }

    private func navigationBarLeadingUI() -> some View {
        Button(action: {
            editorViewModel.saveApp()
            closeEditor()
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
                        .environmentObject(editorViewModel)
                }

            Spacer()
                .frame(width: 20)

            Button(action: {
                editorViewModel.runApp()
            }) {
                Image(systemName: "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
            .frame(height: 20)
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

    private func openCodeEditor() {
        showingCodeEditorView = true
    }

}
