//
//  TodayViewController.swift
//  MalletWidget
//
//  Created by Katsu Matsuda on 2020/03/16.
//  Copyright © 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.text = "Mallet Widget"
        view.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        )
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }
}
