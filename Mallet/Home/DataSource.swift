//
//  DataSource.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

struct AppInfo {
    let title: String
    let code: [String]
    let ui: String
}

struct AppInfoDataSource {
    let appInfo = [
        AppInfo(title: "計算", code: ["var a : Int\na = 1 + 1\nSetUIText(1,a)", ""], ui: "[[{\"value\":0,\"text\":\"Button\",\"uiID\":0}],[{\"value\":0,\"text\":\"Text\",\"uiID\":1}]]"),
        AppInfo(title: "繰り返し", code: ["var a : Int\nvar b : Int\nvar c : Int\na = 1\nb = 1\nc = 0\nrepeat(10)\n{\n    c = a\n    a = a + b\n    b = c\n}\nSetUIText(1,b)", ""], ui: "[[{\"value\":0,\"text\":\"Button\",\"uiID\":0}],[{\"value\":0,\"text\":\"Text\",\"uiID\":1}]]"),
        AppInfo(title: "条件分岐", code: ["var a : Int\nvar b : Int\na = 1\nb = a == 1\nif(b)\n{\n    SetUIText(1,\"aは1\")\n}\nb = a != 1\nif(b)\n{\n    SetUIText(1,\"aは1ではない\")\n}", ""], ui: "[[{\"value\":0,\"text\":\"Button\",\"uiID\":0}],[{\"value\":0,\"text\":\"Text\",\"uiID\":1}]]"),
        AppInfo(title: "高負荷な処理", code: ["var a : Int\na = 0\nrepeat(100000000)\n{\n    a = a + 1\n}\nSetUIText(1,a)", ""], ui: "[[{\"value\":0,\"text\":\"Button\",\"uiID\":0}],[{\"value\":0,\"text\":\"Text\",\"uiID\":1}]]"),
        AppInfo(title: "フィボナッチ数列", code: ["var c : Int\nc = a + b\nb = a\na = c\nSetUIText(1,c)", ""], ui: "[[{\"value\":0,\"text\":\"Button\",\"uiID\":0}],[{\"value\":0,\"text\":\"Text\",\"uiID\":1}]]"),
        AppInfo(title: "文字列グローバル変数", code: ["globStr = \"Global String\"\nSetUIText(1,globStr)", ""], ui: "[[{\"value\":0,\"text\":\"Button\",\"uiID\":0}],[{\"value\":0,\"text\":\"Text\",\"uiID\":1}]]")
    ]
}
