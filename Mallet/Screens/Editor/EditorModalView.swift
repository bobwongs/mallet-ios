//
//  EditorModalView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/01.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorModalView: View {

    @State var initialDragAmount: CGFloat = 250

    @State var dragAmount: CGFloat = 250

    private let uiTableModalHeight: CGFloat = 300

    private let uiTableModalMaxVisibleHeight: CGFloat = 250

    private let uiTableModalMinVisibleHeight: CGFloat = 50

    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                VStack {
                    VStack {
                        Color.clear
                    }
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 2)
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
}

struct EditorModalView_Previews: PreviewProvider {
    static var previews: some View {
        EditorModalView()
    }
}
