//
//  AppUIController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/01.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

@objcMembers
class AppUIController: NSObject {
    static func SetUIText(id: Int, text: String) {
        DispatchQueue.main.async {
            guard let appRunner = AppRunner.topViewController() as? AppRunner else {
                return
            }

            if let uiData = appRunner.appUI[id]?.getUIData() {

                switch uiData.uiType {
                case .Label:
                    uiData.labelData?.text = text
                    print(text)

                case .Button:
                    uiData.buttonData?.text = text

                default:
                    //TODO:
                    break
                }

                appRunner.appUI[id]?.reloadUI()
            }
        }
    }
}
