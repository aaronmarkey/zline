//
//  Utilities.swift
//  z-line
//
//  Created by Aaron Markey on 1/11/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit

func customColor(color value: String) -> UIColor {
    let colors: [String: [CGFloat]] = [
        "primary": [153/255, 102/255, 51/255, 1.0/1.0]
    ]
    
    if let color = colors[value] {
        return UIColor.init(red: color[0], green: color[1], blue: color[2], alpha: color[3])
    } else {
        let color = colors["primary"]!
        return UIColor.init(red: color[0], green: color[1], blue: color[2], alpha: color[3])
    }
}
