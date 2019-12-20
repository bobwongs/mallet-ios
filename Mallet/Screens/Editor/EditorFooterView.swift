//
//  EditorFooterView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/20.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorFooterView: View {
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                    }
                        .frame(height: 40)
                    HStack {
                        Spacer()
                    }
                        .frame(height: geo.safeAreaInsets.bottom)

                }
                    .background(Color(.tertiarySystemBackground))
                    .overlay(
                        VStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color(.systemGray4))
                            Spacer()
                        }
                    )
            }
        }
    }
}

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
