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

    let openCodeEditor: () -> Void

    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    HStack {
                        HStack {
                            leadingContent()
                            Spacer()
                            centerContent()
                            Spacer()
                            trailingContent()
                        }
                            .frame(height: 23)
                            .padding([.leading, .trailing], 10)
                    }
                        .frame(height: height)

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
                .offset(y: offset)
                .edgesIgnoringSafeArea(.bottom)
        }
    }

    private func leadingContent() -> some View {
        HStack(spacing: 0) {
            Button(action: {
                print("undo")
            }) {
                Image(systemName: "arrow.uturn.left.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 12)
            }

            Button(action: {
                print("redo")
            }) {
                Image(systemName: "arrow.uturn.right.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 12)
            }
        }
    }

    private func centerContent() -> some View {
        HStack(spacing: 0) {
            Button(action: {
                toggleUIStyleEditor()
            }) {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 12)
            }

            Button(action: {
                openCodeEditor()
            }) {
                Image(systemName: "chevron.left.slash.chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 12)
            }
        }
    }

    private func trailingContent() -> some View {
        HStack(spacing: 0) {
            Button(action: {
                editorViewModel.deleteUI()
            }) {
                Image(systemName: "trash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 12)
            }

            Button(action: {
                editorViewModel.duplicateUI()
            }) {
                Image(systemName: "plus.square.on.square")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 12)
            }
        }
    }

}
