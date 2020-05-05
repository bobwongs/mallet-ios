//
//  AppViewModel+MUIFrameController.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/05.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import XyloSwift

extension AppViewModel: MUIFrameController {

    func setFrame(args: [XyObj]) -> XyObj {
        let x = CGFloat(args[1].float())
        let y = CGFloat(args[2].float())
        let width = CGFloat(args[3].float())
        let height = CGFloat(args[4].float())

        getUIData(args[0]).frameData.frame.wrappedValue =
            MUIRect(x: x, y: y, width: width, height: height)

        return .zero
    }

    func setPosition(args: [XyObj]) -> XyObj {
        let x = CGFloat(args[1].float())
        let y = CGFloat(args[2].float())

        let frame = getUIData(args[0]).frameData.frame
        frame.x.wrappedValue = x
        frame.y.wrappedValue = y

        return .zero
    }

    func setSize(args: [XyObj]) -> XyObj {
        let width = CGFloat(args[1].float())
        let height = CGFloat(args[2].float())

        let frame = getUIData(args[0]).frameData.frame
        frame.width.wrappedValue = width
        frame.height.wrappedValue = height

        return .zero
    }

    func setX(args: [XyObj]) -> XyObj {
        let x = CGFloat(args[1].float())

        let frame = getUIData(args[0]).frameData.frame
        frame.x.wrappedValue = x

        return .zero
    }

    func setY(args: [XyObj]) -> XyObj {
        let y = CGFloat(args[1].float())

        let frame = getUIData(args[0]).frameData.frame
        frame.y.wrappedValue = y

        return .zero
    }

    func setWidth(args: [XyObj]) -> XyObj {
        let width = CGFloat(args[1].float())

        let frame = getUIData(args[0]).frameData.frame
        frame.width.wrappedValue = width

        return .zero
    }

    func setHeight(args: [XyObj]) -> XyObj {
        let height = CGFloat(args[1].float())

        let frame = getUIData(args[0]).frameData.frame
        frame.height.wrappedValue = height

        return .zero
    }

    func getX(args: [XyObj]) -> XyObj {
        XyObj(Double(getUIData(args[0]).frameData.frame.x.wrappedValue))
    }

    func getY(args: [XyObj]) -> XyObj {
        XyObj(Double(getUIData(args[0]).frameData.frame.y.wrappedValue))
    }

    func getWidth(args: [XyObj]) -> XyObj {
        XyObj(Double(getUIData(args[0]).frameData.frame.width.wrappedValue))
    }

    func getHeight(args: [XyObj]) -> XyObj {
        XyObj(Double(getUIData(args[0]).frameData.frame.height.wrappedValue))
    }

}

