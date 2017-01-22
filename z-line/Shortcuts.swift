//
//  Shortcuts.swift
//  z-line
//
//  Created by Aaron Markey on 1/16/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit
import CoreData

enum Shortcut: String {
    case newNote = "newnote"
    case lastNote = "lastnote"
}

func handleShortcut(shortcutItem: UIApplicationShortcutItem, window: UIWindow) -> Bool {
    var handled = false
    let type = shortcutItem.type.components(separatedBy: ".").last!
    
    let nav = window.rootViewController as! UINavigationController
    let noteView = nav.storyboard!.instantiateViewController(withIdentifier: "NoteTextView") as! NoteTextViewController
    
    if let shortcutType = Shortcut.init(rawValue: type) {
        switch shortcutType {
        case .newNote:
            noteView.isNew = true
            noteView.title = "New"
        case .lastNote:
            noteView.isNew = false
            noteView.title = "Preview"
            noteView.note = getLatestUpToDateNote()
            
        }
        
        nav.pushViewController(noteView, animated: true)
        handled = true
    }
    
    return handled
}
