//
//  TextEditorTextView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/07.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct TextEditorTextView: UIViewRepresentable {

    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.text = text
        textView.isScrollEnabled = true
        textView.font = .monospacedSystemFont(ofSize: 17, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.smartQuotesType = .no
        textView.smartDashesType = .no
        textView.delegate = context.coordinator

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

}

extension TextEditorTextView {

    final class Coordinator: NSObject, UITextViewDelegate {

        private var textView: TextEditorTextView

        init(_ textView: TextEditorTextView) {
            self.textView = textView
        }

        func textViewDidChange(_ textView: UITextView) {
            self.textView.text = textView.text
        }
    }

}