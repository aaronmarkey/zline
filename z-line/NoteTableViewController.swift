//
//  NoteTableViewController.swift
//  z-line
//
//  Created by Aaron Markey on 1/11/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController {

    //MARK: Properties
    var notes: [NSManagedObject] = []
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet var longPressOnCellOutlet: UILongPressGestureRecognizer!
    
    //MARK: Actions
    @IBAction func longPressOnCell(_ sender: AnyObject) {
        if(sender.state == UIGestureRecognizerState.began) {
            self.performSegue(withIdentifier: "toEditNoteFromNoteTable", sender: sender)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notes = getNotes()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteTableCell", for: indexPath) as! NoteTableViewCell
        let note = notes[(indexPath as NSIndexPath).row] as! NoteMO
        cell.contentOutlet.text = note.content
        cell.dateOutlet.text = formatDate(date: note.updated_at!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(notes: notes, index: indexPath.row)
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toNewNote") {
            segue.destination.title = "New"
            let destination = segue.destination as! NoteTextViewController
            destination.isNew = true
        }
        
        if(segue.identifier == "toEditNoteFromNoteTable") {
            segue.destination.title = "Edit"
            let destination = segue.destination as! NoteTextViewController
            let touchPoint = longPressOnCellOutlet.location(in: self.view)
            if let index = tableView.indexPathForRow(at: touchPoint) {
                let note = notes[(index as NSIndexPath).row] as! NoteMO
                destination.isNew = false
                destination.index = (index as NSIndexPath).row
                destination.existingText = note.content!
                destination.notes = notes
            }
        }
        
        if(segue.identifier == "toPreviewNote") {
            let destination = segue.destination as! NotePreviewViewController
            let index = tableView.indexPathForSelectedRow as IndexPath?
            let note = notes[(index! as NSIndexPath).row] as! NoteMO
            
            destination.rawString = note.content!
            destination.index = (index! as NSIndexPath).row
            destination.notes = notes
        }
    }
    

}
