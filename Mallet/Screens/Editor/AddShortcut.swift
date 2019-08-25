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

    static func showShortcutScreen(deepLink: String) {

        /*
        guard let deepLinkURL = URL(string: deepLink) else {
            return
        }
        */

        guard let shortcutURL = URL(string: "http://localhost:8123/shortcut") else {
            return
        }

        let html = generateHTML(icon: "", title: "TestApp", data: "")

        print(html)

        guard let base64 = html.data(using: .utf8)?.base64EncodedString() else {
            return
        }

        localServer["/shortcut"] = { request in
            return .movedPermanently("data:text/html;base64,\(base64)")
        }

        do {
            try localServer.start(8123)
        } catch {
            print("Error")
        }
        UIApplication.shared.open(shortcutURL)
    }

    static func generateHTML(icon: String, title: String, data: String) -> String {
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
                   <a id="redirect" href="mallet-shortcut://"></a>
                   <script type="text/javascript">
                     if(navigator.standalone){
                         var e = document.getElementById("redirect");
                         var v = document.createEvent("MouseEvents");
                         v.initEvent("click",true,true);
                         e.dispatchEvent(v);
                     }
                     else{
                         alert("Add to home");
                     }
                   </script>
                 </body>
               </html>
               """
    }

}
