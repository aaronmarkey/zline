//
//  Shortcuts.swift
//  z-line
//
//  Created by Aaron Markey on 1/16/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit

enum Shortcut: String {
    case newNote = "newnote"
}

func handleShortcut(shortcutItem: UIApplicationShortcutItem, window: UIWindow) -> Bool {
    var handled = false
    let type = shortcutItem.type.components(separatedBy: ".").last!
    if let shortcutType = Shortcut.init(rawValue: type) {
        switch shortcutType {
        case .newNote:
            let nav = window.rootViewController as! UINavigationController
            let noteView = nav.storyboard!.instantiateViewController(withIdentifier: "NoteTextView") as! NoteTextViewController
            noteView.isNew = true
            nav.pushViewController(noteView, animated: true)
            handled = true
        }
    }
    
    return handled
}
