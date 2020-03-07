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

    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    HStack {
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

                            Spacer()

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
                            .frame(height: 20)
                            .padding(20)
                    }
                        .frame(height: self.height)

                    Color.white
                        .opacity(0.001)
                        .frame(height: geo.safeAreaInsets.bottom)
                        .gesture(DragGesture()
                                     .onChanged { _ in

                                     })

                }
                    .background(Color(.tertiarySystemBackground))
                    .overlay(
                        VStack {
                            Rectangle()
                                .frame(height: 0.2)
                                .foregroundColor(Color(.systemGray4))
                            Spacer()
                        }
                    )
                    .transition(.move(edge: .bottom))
            }
                .offset(y: self.offset)
        }
    }
}

/*
struct EditorFooterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditorFooterView()
                .edgesIgnoringSafeArea(.bottom)
                .colorScheme(.light)

            EditorFooterView()
                .edgesIgnoringSafeArea(.bottom)
                .colorScheme(.dark)
        }
    }
}
*/
