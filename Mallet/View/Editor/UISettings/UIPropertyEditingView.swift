//
//  UIPropertyEditingView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/03.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct UIPropertyEditingView: View {

    @Binding var uiData: MUI

    var body: some View {
        Text(uiData.uiName)
    }

}
