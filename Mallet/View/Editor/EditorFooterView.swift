//
//  EditorFooterView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/01.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorFooterView: View {

    @EnvironmentObject var editorViewModel: EditorViewModel

    @Binding var appViewScale: CGFloat

    @Binding var appViewOffset: CGPoint

    let editorGeo: GeometryProxy

    @State private var modalViewOffset: CGFloat = 0

    @State private var modalViewCurrentOffset: CGFloat = 0

    @State private var dragGestureCurrentTranslationHeight: CGFloat = 0

    @State private var dragGestureDiffHeight: CGFloat = 0

    @State private var selectedUIType: MUIType = .space

    @State private var selectedUIFrame = CGRect.zero

    @State private var showingFooter = true

    private var footerViewOffset: Binding<CGFloat> {
        Binding(
            get: { self.modalViewMaxOffset - self.modalViewOffset },
            set: { _ in }
        )
    }

    private var modalViewHeight: CGFloat {
        300
    }

    private var modalViewMinVisibleHeight: CGFloat {
        30
    }

    private var modalViewMaxOffset: CGFloat {
        modalViewHeight - (modalViewMinVisibleHeight + footerViewHeight)
    }

    private var modalViewMinOffset: CGFloat {
        20
    }

    private var footerViewHeight: CGFloat {
        40
    }

    private var controlBarHeight: CGFloat {
        30
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Spacer()
                    self.modal(geo: geo)
                        .transition(.move(edge: .bottom))
                }

                EditorToolBar(offset: self.footerViewOffset, height: self.footerViewHeight)
                    .environmentObject(self.editorViewModel)

                if self.selectedUIType != .space {
                    UISelectionView.generateUI(type: self.selectedUIType)
                        .environmentObject(self.editorViewModel)
                        .scaleEffect(self.appViewScale)
                        .frame(width: self.selectedUIFrame.width, height: self.selectedUIFrame.height)
                        .position(x: self.selectedUIFrame.midX - geo.frame(in: .global).origin.x,
                                  y: self.selectedUIFrame.midY - geo.frame(in: .global).origin.y)
                }
            }
        }
    }

    private func modal(geo: GeometryProxy) -> some View {
        VStack {
            VStack {
                VStack {
                    Rectangle()
                        .frame(width: 40, height: 4)
                        .cornerRadius(2)
                        .foregroundColor(Color(.systemGray3))
                }
                    .frame(height: self.controlBarHeight)

                UISelectionView(editorGeo: self.editorGeo,
                                closeModalView: { self.closeModalView() },
                                selectedUIType: self.$selectedUIType,
                                selectedUIFrame: self.$selectedUIFrame,
                                appViewScale: self.$appViewScale,
                                appViewOffset: self.$appViewOffset
                )
            }
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.opaqueSeparator), lineWidth: 0.2)
                )
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                             .onChanged({ value in
                                 self.dragGestureDiffHeight = value.translation.height - self.dragGestureCurrentTranslationHeight
                                 self.dragGestureCurrentTranslationHeight = value.translation.height

                                 self.modalViewOffset =
                                     max(self.modalViewMinOffset,
                                         min(self.modalViewMaxOffset, self.modalViewCurrentOffset + value.translation.height))
                             })
                             .onEnded({ value in
                                 self.modalViewCurrentOffset = self.modalViewOffset

                                 if abs(self.dragGestureDiffHeight) < 2 {
                                     if self.modalViewOffset < (self.modalViewMaxOffset + self.modalViewMinOffset) / 2 {
                                         self.openModalView()
                                     } else {
                                         self.closeModalView()
                                     }
                                     return
                                 }

                                 if self.dragGestureDiffHeight < 0 {
                                     self.openModalView()
                                 } else {
                                     self.closeModalView()
                                 }
                             })
                )
        }
            .onAppear {
                self.modalViewOffset = self.modalViewMaxOffset
                self.modalViewCurrentOffset = self.modalViewOffset
            }
            .frame(height: self.modalViewHeight + geo.safeAreaInsets.bottom)
            .offset(x: 0, y: self.modalViewOffset)
            .edgesIgnoringSafeArea(.bottom)
    }

    private func openModalView() {
        withAnimation(.easeOut(duration: 0.2)) {
            modalViewOffset = modalViewMinOffset
        }

        modalViewCurrentOffset = modalViewOffset
    }

    private func closeModalView() {
        withAnimation(.easeOut(duration: 0.2)) {
            modalViewOffset = modalViewMaxOffset
        }

        modalViewCurrentOffset = modalViewOffset
    }

    private func showFooter() {
        withAnimation {
            showingFooter = true
        }
    }

    private func hideFooter() {
        showingFooter = false
    }
}

/*
struct EditorModalView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditorModalView()
                .colorScheme(.light)

            EditorModalView()
                .colorScheme(.dark)
        }
    }
}
*/
