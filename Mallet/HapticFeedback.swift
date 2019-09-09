//
//  HapticFeedback.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/09.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class HapticFeedback {
    private static let impactFeedbackGeneratorLight: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()

    private static let impactFeedbackGeneratorMedium: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        return generator
    }()

    private static let impactFeedbackGeneratorHeavy: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        return generator
    }()

    private static let selectionFeedbackGenerator: UISelectionFeedbackGenerator = {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        return generator
    }()

    static func selectionFeedback() {
        HapticFeedback.selectionFeedbackGenerator.selectionChanged()
    }

    static func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        switch style {
        case .light:
            impactFeedbackGeneratorLight.impactOccurred()

        case .medium:
            impactFeedbackGeneratorMedium.impactOccurred()

        case .heavy:
            impactFeedbackGeneratorHeavy.impactOccurred()

        default:
            return
        }
    }

    static func blockFeedback() {
        impactFeedback(style: .light)
    }
}
