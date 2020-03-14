//
//  TextStyleEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct TextStyleEditorView: View {

    @Binding var textData: MUITextData

    var body: some View {
        Group {
            if textData.enabled {
                UIStyleEditorSectionView(title: "Text") {
                    HStack {
                        Text("Text")
                        TextField("Text", text: self.$textData.text)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Color")

                        Spacer()

                        Rectangle()
                            .background(self.textData.color.toColor)
                            .frame(width: 30)
                            .cornerRadius(5)
                    }

                    HStack {
                        Text("Size")
                        NumberInputView(value: self.$textData.size, range: 0.1...1000)
                    }

                    HStack {
                        Text("Alignment")

                        Spacer()

                        HStack(spacing: 5) {
                            Group {
                                Image(systemName: "text.alignleft")
                                    .onTapGesture {
                                        self.textData.alignment = .leading
                                    }
                                    .padding(10)
                                    .background(
                                        Group {
                                            if self.textData.alignment == .leading {
                                                Color.blue
                                            } else {
                                                Color(.tertiarySystemFill)
                                            }
                                        }
                                    )

                                Image(systemName: "text.aligncenter")
                                    .onTapGesture {
                                        self.textData.alignment = .center
                                    }
                                    .padding(10)
                                    .background(
                                        Group {
                                            if self.textData.alignment == .center {
                                                Color.blue
                                            } else {
                                                Color(.tertiarySystemFill)
                                            }
                                        }
                                    )

                                Image(systemName: "text.alignright")
                                    .onTapGesture {
                                        self.textData.alignment = .trailing
                                    }
                                    .padding(10)
                                    .background(
                                        Group {
                                            if self.textData.alignment == .trailing {
                                                Color.blue
                                            } else {
                                                Color(.tertiarySystemFill)
                                            }
                                        }
                                    )
                            }
                                .cornerRadius(5)
                        }
                    }
                }
            }
        }
    }
}
