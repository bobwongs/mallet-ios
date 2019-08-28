//
//  AddShortcut.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/23.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit
import Swifter
import SafariServices

class AddShortcut {

    static let localServer = HttpServer()

    static func showShortcutScreen(appID: Int) {

        let urlStr = "mallet-shortcut://run/\(appID)"

        guard let shortcutURL = URL(string: "http://localhost:52133/shortcut") else {
            return
        }

        let html = generateHTML(icon: "", title: "TestApp", url: urlStr)

        print(html)

        guard let base64 = html.data(using: .utf8)?.base64EncodedString() else {
            return
        }

        localServer["/shortcut"] = { request in
            return .movedPermanently("data:text/html;base64,\(base64)")
        }

        do {
            try localServer.start(52133)
        } catch {
            print("Error")
        }
        UIApplication.shared.open(shortcutURL)
    }

    static func generateHTML(icon: String, title: String, url: String) -> String {
        return """
               <html>
                 <head>
                   <meta name="apple-mobile-web-app-capable" content="yes" />
                   <meta name="apple-mobile-web-app-status-bar-style" content="white" />
                   <title>
                     \(title)
                   </title>
                 </head>
                 <body>
                   <a id="redirect" href="\(url)"></a>
                   <h1>//TODO:</h1>
                   <script type="text/javascript">
                     if(navigator.standalone){
                         var e = document.getElementById("redirect");
                         var v = document.createEvent("MouseEvents");
                         v.initEvent("click",true,true);
                         e.dispatchEvent(v);
                     }
                     else{
                     }
                   </script>
                 </body>
               </html>
               """
    }

}
