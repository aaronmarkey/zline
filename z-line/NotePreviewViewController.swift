//
//  NotePreviewViewController.swift
//  z-line
//
//  Created by Aaron Markey on 1/11/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit
import CoreData

class NotePreviewViewController: UIViewController, UIWebViewDelegate {

    //MARK: Properties
    var rawString: String = ""
    var notes: [NSManagedObject] = []
    var index: Int = 0
    
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Preview"
        webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var markdown = Markdown()
        let html: String = markdown.transform(rawString)
        
        //MARK: TODO - Figure out how CSS will be applied to note
        let style="<style>img{ width: 100%; height: auto; }</style>"
        
        webView.backgroundColor = .white
        webView.loadHTMLString(style + html, baseURL: nil)
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toEditNote") {
            let destination = segue.destination as! NoteTextViewController
            
            destination.title = "Edit"
            destination.existingText = rawString
            destination.isNew = false
            destination.index = index
            destination.notes = notes
            
        }
    }
 
    
    //MARK: UIWwebViewDelegate Function
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            return false
        }
        return true
    }

}
