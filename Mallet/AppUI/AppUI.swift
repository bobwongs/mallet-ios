//
//  AppUI.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/05/06.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

public class AppUILabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.text = "Text"
        self.textColor = UIColor.black

        self.sizeToFit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class AppUIButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.backgroundColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
        self.setTitle("Button", for: .normal)
        self.titleLabel?.font = self.titleLabel?.font.withSize(17)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1), for: .highlighted)
        self.layer.cornerRadius = 7

        self.sizeToFit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public class AppUISwitch: UISwitch {

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class AppSampleUISwitch: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        let wall = UIView(frame: self.frame)
        self.addSubview(wall)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class AppSampleUIButton: AppUIButton {
    var testDelegate: testDelegate?

    var localTouchPosition: CGPoint?

    var isOnUIList: Bool?

    override init(frame: CGRect) {
        super.init(frame: frame)

        //testDelegate?.test(button: self)

        let wall = UIView(frame: self.frame)
        self.addSubview(wall)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOnUIList ?? false {
            testDelegate?.test(button: self)
            isOnUIList = false
        }

        super.touchesBegan(touches, with: event)
        let touch = touches.first
        let selfPos = self.frame.origin
        let touchPos = touch?.location(in: self.superview)
        self.localTouchPosition = CGPoint(x: touchPos!.x - selfPos.x, y: touchPos!.y - selfPos.y)
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        let touch = touches.first
        guard  let location = touch?.location(in: self.superview), let localTouchPosition = self.localTouchPosition else {
            return
        }

        self.frame.origin = CGPoint(x: location.x - localTouchPosition.x, y: location.y - localTouchPosition.y)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.localTouchPosition = nil
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.localTouchPosition = nil
    }
    */
}

protocol testDelegate: class {
    func test(button: AppUIButton)
}