//
//  NoteManagement.swift
//  z-line
//
//  Created by Aaron Markey on 1/13/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit
import CoreData


func getContext() -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
}

func getNotes() -> [NSManagedObject] {
    let context = getContext()
    let request = NSFetchRequest<NSManagedObject>(entityName: "Note")
    
    do {
        let notes = try context.fetch(request)
        return notes
    } catch _ as NSError {
        print("Cannote load notes.")
        return [NSManagedObject]()
    }
}

func storeNote(content: String, date: NSDate) {
    let context = getContext()
    let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)!
    let store = NSManagedObject(entity: entity, insertInto: context)
    
    store.setValue(content, forKey: "content")
    store.setValue(date, forKey: "created_at")
    store.setValue(date, forKey: "updated_at")
    
    do {
        try context.save()
    } catch _ as NSError {
        print("Cannot save new note.")
    }
}
