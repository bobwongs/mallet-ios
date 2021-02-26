//
//  MUIRectType.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2021/02/24.
//  Copyright (c) 2021 Katsu Matsuda. All rights reserved.
//

import Foundation

enum MUIRectType {

    case grid(MUIRectInGrid)

    case free(MUIRect)

}

extension MUIRectType: Equatable {
    public static func ==(lhs: MUIRectType, rhs: MUIRectType) -> Bool {
        switch (lhs, rhs) {
        case (let .grid(l), let .grid(r)):
            return l == r
        case (let .free(l), let .free(r)):
            return l == r
        default:
            return false
        }
    }
}

extension MUIRectType: Codable {
    enum CodingKeys: String, CodingKey {
        case grid, free
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let grid = try container.decodeIfPresent(MUIRectInGrid.self, forKey: .grid) {
            self = .grid(grid)
        } else if let free = try container.decodeIfPresent(MUIRect.self, forKey: .free) {
            self = .free(free)
        } else {
            self = .free(.zero)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .grid(let value):
            try container.encode(value, forKey: .grid)
        case .free(let value):
            try container.encode(value, forKey: .free)
        }
    }
}
