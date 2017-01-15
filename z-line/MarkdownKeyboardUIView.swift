//
//  MarkdownKeyboardUIView.swift
//  z-line
//
//  Created by Aaron Markey on 1/14/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit

class MarkdownKeyboardUIView: UIView {

    //MARK: Outlets
    @IBOutlet weak var backtickButton: MarkdownUIButton!
    @IBOutlet weak var hashButton: MarkdownUIButton!
    @IBOutlet weak var linkButton: MarkdownUIButton!
    @IBOutlet weak var imageButton: MarkdownUIButton!
    @IBOutlet weak var asteriskButton: MarkdownUIButton!
    @IBOutlet weak var greaterButton: MarkdownUIButton!
    
    weak var textView: UITextView?
    
    @IBAction func buttonPressed(_ sender: MarkdownUIButton) {
        if let range = textView?.selectedTextRange {
            textView?.replace(range, withText: sender.value)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setButtons(textView view: UITextView) {
        backtickButton.value = "`"
        hashButton.value = "#"
        linkButton.value = "[ ]( )"
        imageButton.value = "![ ]( )"
        asteriskButton.value = "*"
        greaterButton.value = ">"
        textView = view
    }
}

protocol MarkdownKeyboardUIViewDelegate: class {
    func didPressMarkdownButton(sender: MarkdownKeyboardUIView) -> String
}
