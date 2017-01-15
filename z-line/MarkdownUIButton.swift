//
//  MarkdownUIButton.swift
//  z-line
//
//  Created by Aaron Markey on 1/14/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit

class MarkdownUIButton: UIButton {

    //MARK: Properties
    var value: String
    
    required init?(coder aDecoder: NSCoder) {
        value = ""
        super.init(coder: aDecoder)
    }
    
}
