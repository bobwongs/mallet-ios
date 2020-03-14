//
//  FractionalNumberFormatter.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

class FractionalNumberFormatter: NumberFormatter {

    override init() {
        super.init()
    }

    init(_ range: ClosedRange<Float>, minimumFractionDigits: Int, maximumFractionDigits: Int) {
        super.init()
        self.minimum = NSNumber(value: range.lowerBound)
        self.maximum = NSNumber(value: range.upperBound)
        self.minimumFractionDigits = minimumFractionDigits
        self.maximumFractionDigits = maximumFractionDigits
    }

    init(_ range: ClosedRange<Double>, minimumFractionDigits: Int, maximumFractionDigits: Int) {
        super.init()
        self.minimum = NSNumber(value: range.lowerBound)
        self.maximum = NSNumber(value: range.upperBound)
        self.minimumFractionDigits = minimumFractionDigits
        self.maximumFractionDigits = maximumFractionDigits
    }

    init(_ range: ClosedRange<Int>, minimumFractionDigits: Int, maximumFractionDigits: Int) {
        super.init()
        self.minimum = NSNumber(value: range.lowerBound)
        self.maximum = NSNumber(value: range.upperBound)
        self.minimumFractionDigits = minimumFractionDigits
        self.maximumFractionDigits = maximumFractionDigits
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}