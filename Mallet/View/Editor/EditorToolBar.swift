//
//  EditorToolBar.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/20.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorToolBar: View {

    @EnvironmentObject var editorViewModel: EditorViewModel

    @Binding var offset: CGFloat

    let height: CGFloat

    let toggleUIStyleEditor: () -> Void

    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    HStack {
                        HStack {
                            self.leadingContent()
                            Spacer()
                            self.centerContent()
                            Spacer()
                            self.trailingContent()
                        }
                            .frame(height: 23)
                            .padding([.leading, .trailing], 20)
                    }
                        .frame(height: self.height)

                    Color.white
                        .opacity(0.001)
                        .frame(height: geo.safeAreaInsets.bottom)
                        .gesture(DragGesture()
                                     .onChanged { _ in

                                     })

                }
                    .background(Blur(style: .systemThickMaterial).background(Color(.tertiarySystemBackground)))
                    .overlay(
                        VStack {
                            Rectangle()
                                .frame(height: 0.2)
                                .foregroundColor(Color(.systemGray4))
                            Spacer()
                        }
                    )
            }
                .offset(y: self.offset)
        }
    }

    private func leadingContent() -> some View {
        HStack {
            Button(action: {
                print("undo")
            }) {
                Image(systemName: "arrow.uturn.left.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            Spacer()
                .frame(width: 40)

            Button(action: {
                print("redo")
            }) {
                Image(systemName: "arrow.uturn.right.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }

    private func centerContent() -> some View {
        HStack {
            Button(action: {
                self.toggleUIStyleEditor()
            }) {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }

    private func trailingContent() -> some View {
        HStack {
            Button(action: {
                self.editorViewModel.deleteUI()
            }) {
                Image(systemName: "trash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            Spacer()
                .frame(width: 40)

            Button(action: {
                self.editorViewModel.duplicateUI()
            }) {
                Image(systemName: "plus.square.on.square")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}
