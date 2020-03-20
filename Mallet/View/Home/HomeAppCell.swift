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

    let deleteApp: () -> Void

    var body: some View {
        HStack {
            appIcon()
                .padding(.trailing, 20)
            appInfo()
        }
            .padding(.vertical, 10)
            .onTapGesture {
                self.runApp()
            }
            .contextMenu {
                self.appCellContextMenu()
            }
    }

    private func appIcon() -> some View {
        Image(systemName: "sparkles")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(15)
            .frame(width: 60, height: 60)
            .background(Color.orange)
            .cornerRadius(15)
    }

    private func appInfo() -> some View {
        HStack {
            Text("\(self.appName) \(self.appID)")
                .foregroundColor(Color(.label))
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Rectangle()
                .frame(width: 3)
                .padding(.vertical, 5)
                .foregroundColor(Color(.systemFill))
            VStack {
                Image(systemName: "gear")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .padding(.horizontal, 10)
                    .foregroundColor(.blue)
            }
                .onTapGesture {
                    self.openEditor()
                }
        }
    }

    private func appCellContextMenu() -> some View {
        Group {
            Button(action: {
                self.deleteApp()
            }) {
                HStack {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            }
        }
    }
}
