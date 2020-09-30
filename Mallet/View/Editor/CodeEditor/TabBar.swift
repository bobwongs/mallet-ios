//
//  TabBar.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/09/30.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct TabBar: View {

    let tabNames: [String]

    @Binding var selectedIdx: Int

    let onChange: (Int) -> ()

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(0..<tabNames.count, id: \.self) { idx in
                    Button(action: {
                        selectedIdx = idx
                        onChange(idx)
                    }) {
                        Text(tabNames[idx])
                            .padding(.horizontal, 10)
                            .foregroundColor(.primary)
                    }
                        .frame(height: 30)
                        .background(
                            Group {
                                if selectedIdx == idx {
                                    Color.gray.opacity(0.2)
                                } else {
                                    Color.gray.opacity(0.1)
                                }
                            }
                        )
                }
            }
        }
    }
}
