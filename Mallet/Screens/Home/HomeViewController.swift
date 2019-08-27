//
//  ViewController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let appStackView = UIStackView()

    var appList: [(Int, String)]!

    override func viewDidLoad() {
        super.viewDidLoad()

        appList = StorageManager.getAppList()

        initScrollView()
        initAppStackView()
    }

    func initScrollView() {
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 3000)

        scrollView.addSubview(appStackView)

        appStackView.translatesAutoresizingMaskIntoConstraints = false
        appStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        appStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        appStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        appStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        appStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true

        appStackView.axis = .vertical
        appStackView.alignment = .center
        appStackView.spacing = 15
    }

    func initAppStackView() {
        appList = StorageManager.getAppList()

        for view in appStackView.arrangedSubviews {
            view.removeFromSuperview()
        }

        for (appID, appName) in self.appList {

            let appCard = AppCard(appName: appName, appID: appID, homeViewController: self)
            appStackView.addArrangedSubview(appCard)

            appCard.translatesAutoresizingMaskIntoConstraints = false
            appCard.leftAnchor.constraint(equalTo: appStackView.leftAnchor, constant: 20).isActive = true
            appCard.rightAnchor.constraint(equalTo: appStackView.rightAnchor, constant: -20).isActive = true
        }
    }

    func edit(appID: Int) {
        let storyboard = UIStoryboard(name: "UIEditor", bundle: nil)
        guard let uiEditorController = storyboard.instantiateInitialViewController() as? UIEditorController else {
            fatalError()
        }

        let appData = StorageManager.getApp(appID: appID)

        uiEditorController.appData = appData

        navigationController?.pushViewController(uiEditorController, animated: true)
    }

    func run(appID: Int) {
        let appData = StorageManager.getApp(appID: appID)

        //TODO:
    }

    @IBAction func addAppButton(_ sender: Any) {
        let appData = StorageManager.createNewApp()

        initAppStackView()

        print(appData.appID)

        edit(appID: appData.appID)
    }

    @IBAction func removeAllButton(_ sender: Any) {
        StorageManager.removeAll()

        initAppStackView()
    }
}

