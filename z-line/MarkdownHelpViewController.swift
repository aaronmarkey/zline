//
//  MarkdownHelpViewController.swift
//  z-line
//
//  Created by Aaron Markey on 1/11/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit

class MarkdownHelpViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let body = getStringFromFile(name: "markdown-help", ext: "html")
        let css = generateCss(css: getStringFromFile(name: "foghorn-m", ext: "css")
            + getStringFromFile(name: "prism", ext: "css")
            + getStringFromFile(name: "markdown", ext: "css"))
        let js = generateJs(js: getStringFromFile(name: "prism", ext: "js"))
        let html = generateFullHtmlDocument(body: body, css: css, js: js)
        
        webView.backgroundColor = customColor(color: "gray-light")
        webView.loadHTMLString(html, baseURL: nil)
    }
}
