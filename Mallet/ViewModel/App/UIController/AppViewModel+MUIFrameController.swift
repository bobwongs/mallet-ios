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
        /*
        let x = CGFloat(args[1].float())
        let y = CGFloat(args[2].float())
        let width = CGFloat(args[3].float())
        let height = CGFloat(args[4].float())

        getUIData(args[0]).frameData.frame.wrappedValue =
            MUIRect(x: x, y: y, width: width, height: height)

        return .zero
        */
        fatalError()
    }

    func setPosition(args: [XyObj]) -> XyObj {
        /*
        let x = CGFloat(args[1].float())
        let y = CGFloat(args[2].float())

        let frame = getUIData(args[0]).frameData.frame
        frame.x.wrappedValue = x
        frame.y.wrappedValue = y

        return .zero
        */
        fatalError()
    }

    func setSize(args: [XyObj]) -> XyObj {
        /*
        let width = CGFloat(args[1].float())
        let height = CGFloat(args[2].float())

        let frame = getUIData(args[0]).frameData.frame
        frame.width.wrappedValue = width
        frame.height.wrappedValue = height

        return .zero
        */
        fatalError()
    }

    func setX(args: [XyObj]) -> XyObj {
        /*
        let x = CGFloat(args[1].float())

        let frame = getUIData(args[0]).frameData.frame
        frame.x.wrappedValue = x

        return .zero
        */
        fatalError()
    }

    func setY(args: [XyObj]) -> XyObj {
        /*
        let y = CGFloat(args[1].float())

        let frame = getUIData(args[0]).frameData.frame
        frame.y.wrappedValue = y

        return .zero
        */
        fatalError()
    }

    func setWidth(args: [XyObj]) -> XyObj {
        /*
        let width = CGFloat(args[1].float())

        let frame = getUIData(args[0]).frameData.frame
        frame.width.wrappedValue = width

        return .zero
        */
        fatalError()
    }

    func setHeight(args: [XyObj]) -> XyObj {
        /*
        let height = CGFloat(args[1].float())

        let frame = getUIData(args[0]).frameData.frame
        frame.height.wrappedValue = height

        return .zero
        */
        fatalError()
    }

    func getX(args: [XyObj]) -> XyObj {
        //XyObj(Double(getUIData(args[0]).frameData.frame.x.wrappedValue))
        fatalError()
    }

    func getY(args: [XyObj]) -> XyObj {
        //XyObj(Double(getUIData(args[0]).frameData.frame.y.wrappedValue))
        fatalError()
    }

    func getWidth(args: [XyObj]) -> XyObj {
        //XyObj(Double(getUIData(args[0]).frameData.frame.width.wrappedValue))
        fatalError()
    }

    func getHeight(args: [XyObj]) -> XyObj {
        //XyObj(Double(getUIData(args[0]).frameData.frame.height.wrappedValue))
        fatalError()
    }

    var muiFrameFuncs: [Xylo.Func] {
        [
            Xylo.Func(funcName: "setFrame", argNum: 2, setFrame),
            Xylo.Func(funcName: "setPosition", argNum: 2, setPosition),
            Xylo.Func(funcName: "setSize", argNum: 2, setSize),
            Xylo.Func(funcName: "setX", argNum: 2, setX),
            Xylo.Func(funcName: "setY", argNum: 2, setY),
            Xylo.Func(funcName: "setWidth", argNum: 2, setWidth),
            Xylo.Func(funcName: "setHeight", argNum: 2, setHeight),
            Xylo.Func(funcName: "getX", argNum: 1, getX),
            Xylo.Func(funcName: "getY", argNum: 1, getY),
            Xylo.Func(funcName: "getWidth", argNum: 1, getWidth),
            Xylo.Func(funcName: "getHeight", argNum: 1, getHeight),
        ]
    }
}

