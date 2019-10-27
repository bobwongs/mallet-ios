//
//  AppSettingsModalView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/20.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class AppSettingsModalView: UIViewController, UINavigationBarDelegate {

    var editorDelegate: EditorDelegate?

    @IBOutlet weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.delegate = self

        let navigationBarItems = UINavigationItem(title: "Settings")

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.closeModal(_:)))

        navigationBarItems.rightBarButtonItem = doneButton

        self.navigationBar.setItems([navigationBarItems], animated: false)

        guard let editorDelegate = self.editorDelegate else {
            fatalError()
        }

        let appSettingsController = AppSettingsController(editorDelegate: editorDelegate)

        let childNavigation = UINavigationController(rootViewController: appSettingsController)
        childNavigation.willMove(toParent: self)
        self.addChild(childNavigation)
        let frame = CGRect(x: 0, y: self.navigationBar.frame.height, width: self.view.frame.width, height: self.view.frame.height - self.navigationBar.frame.height)
        childNavigation.view.frame = frame
        self.view.addSubview(childNavigation.view)
        childNavigation.didMove(toParent: self)
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

    @objc func closeModal(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}
