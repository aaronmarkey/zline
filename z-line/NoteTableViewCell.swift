//
//  NoteTableViewCell.swift
//  z-line
//
//  Created by Aaron Markey on 1/11/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var dateOutlet: UILabel!
    
    //MARK: Properties
    var height: CGFloat? = nil
    var element: String = ""
    var html: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurePreview(content: String) {
        var markdown = Markdown()
        let fullHtml = markdown.transform(content)
        let css = generateCss(css: getStringFromFile(name: "modest-m", ext: "css")) + generateCss(css: getStringFromFile(name: "table-cell", ext: "css"))
        let html = generateFullHtmlDocument(body: fullHtml, css: css)
        
        webView.loadHTMLString(html, baseURL: nil)
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.isUserInteractionEnabled = false
    }
}
