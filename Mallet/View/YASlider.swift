//
//  YASlider.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/08.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct YASlider: UIViewRepresentable {

    @Binding private var value: Float

    private let bounds: ClosedRange<Float>

    private let step: Float?

    let onEditingStarted: () -> Void

    let onEditingChanged: () -> Void

    let onEditingEnded: () -> Void

    init(value: Binding<Float>, in bounds: ClosedRange<Float>, step: Float? = nil,
         onEditingStarted: @escaping () -> Void = {},
         onEditingChanged: @escaping () -> Void = {},
         onEditingEnded: @escaping () -> Void = {}) {
        self._value = value
        self.bounds = bounds
        self.step = step
        self.onEditingStarted = onEditingStarted
        self.onEditingChanged = onEditingChanged
        self.onEditingEnded = onEditingEnded
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = bounds.lowerBound
        slider.maximumValue = bounds.upperBound
        slider.addTarget(context.coordinator, action: #selector(context.coordinator.onStarted(_:)), for: .touchDown)
        slider.addTarget(context.coordinator, action: #selector(context.coordinator.onChanged(_:)), for: .valueChanged)
        slider.addTarget(context.coordinator, action: #selector(context.coordinator.onEnded(_:)), for: .touchUpInside)
        slider.addTarget(context.coordinator, action: #selector(context.coordinator.onEnded(_:)), for: .touchUpOutside)
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.setValue(value, animated: false)
    }

    func setValue(_ value: Float) {
        if let step = step {
            self.value = round(value / step) * step
        } else {
            self.value = value
        }
    }

}

extension YASlider {

    final class Coordinator {

        private var slider: YASlider

        init(_ slider: YASlider) {
            self.slider = slider
        }

        @objc func onStarted(_ sender: UISlider) {
            slider.setValue(sender.value)
            slider.onEditingStarted()
        }

        @objc func onChanged(_ sender: UISlider) {
            slider.setValue(sender.value)
            slider.onEditingChanged()
        }

        @objc func onEnded(_ sender: UISlider) {
            slider.setValue(sender.value)
            slider.onEditingEnded()
        }

    }

}


