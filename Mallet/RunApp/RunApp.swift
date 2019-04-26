//
//  RunApp.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/22.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class RunApp: UIViewController {
    @IBOutlet weak var appView: UIView!

    public var codeStr = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let objcpp = ObjCpp()

        print(codeStr)
        let json = objcpp.convertCode(toJson: codeStr)
        print(json!)

        objcpp.runCode(json)

        generateAppScreen()
    }

    private func generateAppScreen() {
        let uiData = ScreenDataController().generateRandomUIData()

        let stackView = ScreenGenerator().generateScreen(inputUIData: uiData)

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: appView.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: appView.rightAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: appView.topAnchor, constant: 30).isActive = true
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
