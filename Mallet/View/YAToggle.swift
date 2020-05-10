//
//  YAToggle.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/10.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct YAToggle: UIViewRepresentable {

    @Binding fileprivate var isOn: Bool

    fileprivate let onChanged: () -> Void

    init(isOn: Binding<Bool>, onChanged: @escaping () -> Void) {
        self._isOn = isOn
        self.onChanged = onChanged
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UISwitch {
        let view = UISwitch()
        view.isOn = isOn
        view.addTarget(context.coordinator, action: #selector(context.coordinator.onTapped(_:)), for: .valueChanged)
        return view
    }

    func updateUIView(_ uiView: UISwitch, context: Context) {
        uiView.isOn = isOn
    }
}

extension YAToggle {

    final class Coordinator {

        private var toggle: YAToggle

        init(_ toggle: YAToggle) {
            self.toggle = toggle
        }

        @objc func onTapped(_ sender: UISwitch) {
            if sender.isOn {
                toggle.isOn = true
            } else {
                toggle.isOn = false
            }
            toggle.onChanged()
        }

    }

}