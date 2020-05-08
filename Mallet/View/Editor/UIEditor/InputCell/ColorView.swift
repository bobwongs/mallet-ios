//
//  ColorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/07.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ColorView: View {

    @Binding var color: MUIColor

    var body: some View {
        let cornerRadius: CGFloat = 5

        return RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(color.color)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .background(
                background()
                    .cornerRadius(cornerRadius)
            )
    }

    private func background() -> some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                ForEach(0..<4) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<4) { col in
                            self.pixel(row + col)
                                .frame(width: geo.size.width / 4, height: geo.size.height / 4)
                        }
                    }
                }
            }
        }
    }

    private func pixel(_ dis: Int) -> some View {
        Group {
            if dis % 2 == 0 {
                Color.gray
            } else {
                Color(.systemBackground)
            }
        }
    }

}
