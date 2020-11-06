//
//  Screen.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/11/06.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

struct Screen: Codable {

    let gridW: Int

    let gridH: Int

    static var zero: Screen {
        Screen(gridW: 5, gridH: 10)
    }

}
