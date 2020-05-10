//
//  ActivityView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/10.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

class ActivityView {

    static func show(items: [Any], applicationActivities: [UIActivity]? = nil) {
        let activity = UIActivityViewController(activityItems: items, applicationActivities: applicationActivities)
        let topViewController = UIApplication.topViewController()
        topViewController?.present(activity, animated: true)
    }

}
