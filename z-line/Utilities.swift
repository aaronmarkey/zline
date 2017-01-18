//
//  Utilities.swift
//  z-line
//
//  Created by Aaron Markey on 1/11/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit

func customColor(color value: String, alpha opacity: CGFloat = 1.0) -> UIColor {
    let colors: [String:[CGFloat]] = [
        "primary": [CGFloat(153.0/255), CGFloat(102.0/255), CGFloat(51.0/255), opacity],
        "gray-light": [CGFloat(245.0/255), CGFloat(245.0/255), CGFloat(245.0/255), opacity],
        "gray-regular": [CGFloat(77.0/255), CGFloat(77.0/255), CGFloat(77.0/255), opacity]
    ]
    
    if let color = colors[value] {
        return UIColor(red: color[0], green: color[1], blue: color[2], alpha: color[3])
    } else {
        let color = colors["primary"]!
        return UIColor(red: color[0], green: color[1], blue: color[2], alpha: color[3])
    }
}

func formatDate(date: NSDate) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    
    return formatter.string(from: date as Date)
}

func getStringFromFile(name: String, ext: String) -> String {
    if let file = Bundle.main.path(forResource: name, ofType: ext) {
        do {
            let string = try String(contentsOfFile: file)
            return string
        } catch {
            print("Could not load CSS")
            return ""
        }
    } else {
        print("Could not find file")
        return ""
    }
}

func generateCss(css: String) -> String {
    return "<style>" + css + "</style>"
}

func generateFullHtmlDocument(body: String, css: String) -> String {
    return
        "<html>" +
            "<head>" +
                css +
            "</head>" +
            "<body>" +
                body +
            "</body>" +
        "</html>"
}

func displayShareSheet(information: String, viewController: UIViewController) {
    let shareView = UIActivityViewController(activityItems: [information as NSString], applicationActivities: nil)
    viewController.present(shareView, animated: true, completion: {})
}
