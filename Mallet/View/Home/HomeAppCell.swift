//
//  HomeAppCell.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/19.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct HomeAppCell: View {

    var appID: Int

    var appName: String

    let runApp: () -> Void

    let openEditor: () -> Void

    var body: some View {
        Button(action: {
            self.runApp()
        }) {
            VStack {
                HStack {
                    Text(self.appName)
                        .foregroundColor(Color(UIColor.label))
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.openEditor()
                    }) {
                        Image(systemName: "pencil")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                        .frame(width: 25, height: 25)
                }

            }
                .frame(maxWidth: .infinity)
                .padding(15)
                .background(Color(UIColor.systemFill))
                .cornerRadius(10)
        }
    }

    func moveToEditor() {

    }
}
