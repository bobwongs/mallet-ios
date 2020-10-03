//
//  TextAlignmentInputCell.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/15.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct TextAlignmentInputCell: View {

    @Binding private var alignment: MUITextAlignment

    private let title: String

    init(alignment: Binding<MUITextAlignment>, title: String) {
        self._alignment = alignment

        self.title = title
    }

    var body: some View {
        ListCell {
            HStack {
                Text(title)

                Spacer()

                Picker(selection: self.$alignment, label: Text("Label")) {
                    Image(systemName: "text.alignleft").tag(MUITextAlignment.leading)
                    Image(systemName: "text.aligncenter").tag(MUITextAlignment.center)
                    Image(systemName: "text.alignright").tag(MUITextAlignment.trailing)
                }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: 200)
            }
        }
    }
}
