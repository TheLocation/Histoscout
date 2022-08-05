//
//  Home_Web.swift
//  Histoscout
//
//  Created by Matteo Postorino on 05/08/22.
//

import UIKit
import WebKit

class Home_Web: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://www.wikipedia.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}

