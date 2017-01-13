//
//  NoteManagement.swift
//  z-line
//
//  Created by Aaron Markey on 1/13/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit
import CoreData

func getDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

func getContext(_ appDelegate: AppDelegate) -> NSManagedObjectContext {
    return appDelegate.persistentContainer.viewContext
}

func getNotes() -> [NSManagedObject] {
    let context = getContext(getDelegate())
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
    let context = getContext(getDelegate())
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

func updateNote(content: String, date: NSDate, notes: [NSManagedObject], index: Int) {
    if(content.isEmpty) {
        deleteNote(notes: notes, index: index)
    } else {
        let context = getContext(getDelegate())
        notes[index].setValue(content, forKey: "content")
        notes[index].setValue(date, forKey: "updated_at")
        
        do {
            try context.save()
        } catch _ as NSError {
            print("Cannot update existing note.")
        }
    }
    
}

func deleteNote(notes: [NSManagedObject], index: Int) {
    let delegate = getDelegate()
    let context = getContext(delegate)
    
    context.delete(notes[index])
    delegate.saveContext()
//    do {
//        try context.save()
//    } catch _ as NSError {
//        print("Cannot delete note.")
//    }
}
