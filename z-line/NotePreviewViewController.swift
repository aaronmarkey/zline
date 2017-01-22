//
//  NotePreviewViewController.swift
//  z-line
//
//  Created by Aaron Markey on 1/11/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit
import CoreData
import Down

class NotePreviewViewController: UIViewController, UIWebViewDelegate {

    //MARK: Properties
    var rawString: String = ""
    var note: NSManagedObject = NSManagedObject()
    
    //MARK: Outlets
    @IBOutlet weak var webView: UIWebView!
    
    //MARK: Actions
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        displayShareSheet(information: rawString, viewController: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Preview"
        webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let down = Down(markdownString: rawString)
        let html = try! down.toHTML()
        let css = generateCss(css: getStringFromFile(name: "foghorn-m", ext: "css")) + generateCss(css: getStringFromFile(name: "prism", ext: "css"))
        let js = generateJs(js: getStringFromFile(name: "prism", ext: "js"))
        let fullHtml = generateFullHtmlDocument(body: html, css: css, js: js)
        
        webView.backgroundColor = .white
        webView.loadHTMLString(fullHtml, baseURL: nil)
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toEditNote") {
            let destination = segue.destination as! NoteTextViewController
            
            destination.title = "Edit"
            destination.existingText = rawString
            destination.isNew = false
            destination.note = note
            
        }
    }
 
    
    //MARK: UIWebViewDelegate Function
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            return false
        }
        return true
    }

}
