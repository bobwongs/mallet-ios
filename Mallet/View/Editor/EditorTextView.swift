//
//  TextView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/09.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorTextView: UIViewRepresentable {

    @Binding var backgroundData: MUIBackgroundData

    @Binding var textData: MUITextData

    class UIViewWithTextView: UIView {

        let textView: UITextView

        init(_ textView: UITextView) {
            self.textView = textView
            super.init(frame: CGRect())
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIViewWithTextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        if UITraitCollection.current.userInterfaceStyle == .light {
            textView.overrideUserInterfaceStyle = .light
        } else {
            textView.overrideUserInterfaceStyle = .dark
        }

        textView.becomeFirstResponder()

        let view = UIViewWithTextView(textView)
        view.backgroundColor = backgroundData.color.uiColor
        view.layer.cornerRadius = backgroundData.cornerRadius
        view.addSubview(textView)

        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                textView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                textView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
            ]
        )

        return view
    }

    func updateUIView(_ view: UIViewWithTextView, context: Context) {
        view.textView.text = textData.text
        view.textView.textAlignment = textData.alignment.toNSTextAlignment
        view.textView.textColor = textData.color.uiColor
        view.textView.font = view.textView.font?.withSize(textData.size)
    }
}

extension EditorTextView {
    final class Coordinator: NSObject, UITextViewDelegate {

        private var textView: EditorTextView

        init(_ textView: EditorTextView) {
            self.textView = textView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            self.textView.textData.text = textView.text
        }
    }
}
