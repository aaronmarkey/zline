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
    case lastNote = "lastnote"
}

func handleShortcut(shortcutItem: UIApplicationShortcutItem, window: UIWindow) -> Bool {
    var handled = false
    let type = shortcutItem.type.components(separatedBy: ".").last!
    
//    let tab = window.rootViewController as! UITabBarController
//    tab.selectedIndex = 0
    let nav = window.rootViewController as! UINavigationController
    
    let noteView = nav.storyboard!.instantiateViewController(withIdentifier: "NoteTextView") as! NoteTextViewController
    
    if let shortcutType = Shortcut.init(rawValue: type) {
        switch shortcutType {
        case .newNote:
            noteView.isNew = true
            noteView.title = "New"
        case .lastNote:
            noteView.isNew = false
            noteView.title = "Edit"
            noteView.note = getLatestUpToDateNote()!
        }
        
        nav.popToRootViewController(animated: false)
        nav.pushViewController(noteView, animated: false)
        handled = true
    }
    
    return handled
}
