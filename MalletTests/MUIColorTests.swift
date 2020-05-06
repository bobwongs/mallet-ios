//
//  MUIColorTests.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/05.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import XCTest
@testable import Mallet

class MUIColorTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testHex2Color() {
        hex2Color(hex: "FF0000", ans: MUIColor(r: 255, g: 0, b: 0))
        hex2Color(hex: "00FF00", ans: MUIColor(r: 0, g: 255, b: 0))
        hex2Color(hex: "0000FF", ans: MUIColor(r: 0, g: 0, b: 255))
        hex2Color(hex: "FF00FF", ans: MUIColor(r: 255, g: 0, b: 255))
        hex2Color(hex: "FFFFFF", ans: MUIColor(r: 255, g: 255, b: 255))
        hex2Color(hex: "000000", ans: MUIColor(r: 0, g: 0, b: 0))

        // Random
        hex2Color(hex: "1893d6", ans: MUIColor(r: 24, g: 147, b: 214))
        hex2Color(hex: "b382ba", ans: MUIColor(r: 179, g: 130, b: 186))
        hex2Color(hex: "453e04", ans: MUIColor(r: 69, g: 62, b: 4))
        hex2Color(hex: "789aff", ans: MUIColor(r: 120, g: 154, b: 255))

        // Alpha
        hex2Color(hex: "FF000000", ans: MUIColor(r: 0, g: 0, b: 0, a: 255))
        hex2Color(hex: "00000000", ans: MUIColor(r: 0, g: 0, b: 0, a: 0))
        hex2Color(hex: "61929c24", ans: MUIColor(r: 146, g: 156, b: 36, a: 97))
        hex2Color(hex: "57e6958c", ans: MUIColor(r: 230, g: 149, b: 140, a: 87))
    }

    func hex2Color(hex: String, ans: MUIColor) {
        XCTAssertEqual(MUIColor(hex), ans)
    }

}
