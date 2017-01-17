//
//  NoteTableViewController.swift
//  z-line
//
//  Created by Aaron Markey on 1/11/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController, UISearchBarDelegate {

    //MARK: Properties
    var notes: [NSManagedObject] = []
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet var longPressOnCellOutlet: UILongPressGestureRecognizer!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: Actions
    @IBAction func longPressOnCell(_ sender: AnyObject) {
        if(sender.state == UIGestureRecognizerState.began) {
            self.performSegue(withIdentifier: "toEditNoteFromNoteTable", sender: sender)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notes = getNotes()
        
        if(notes.isEmpty) {
            let nib = UINib(nibName: "EmptyTable", bundle: nil)
            let empty = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            self.view = empty
        } else {
            self.view = tableView
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.searchBarStyle = .minimal
        tableView.setContentOffset(CGPoint(x: 0.0, y: (self.tableView.tableHeaderView?.frame.size.height)!), animated: false)
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
        cell.dateOutlet.text = formatDate(date: note.updated_at!)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = customColor(color: "primary", alpha: 0.3)
        cell.selectedBackgroundView = bgColorView
        
        cell.configurePreview(content: note.content!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(notes: notes, index: indexPath.row)
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if(getNotes().isEmpty) {
                let nib = UINib(nibName: "EmptyTable", bundle: nil)
                let empty = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
                self.view = empty
            }
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
    
    
    //MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let allNotes = getNotes()
        var filterNotes: [NSManagedObject] = []
        let text = searchText.trimmingCharacters(in: .whitespaces)
        
        if(!text.isEmpty) {
            for note in allNotes {
                let noteObject = note as! NoteMO
                if(noteObject.content!.lowercased().contains(text.lowercased())) {
                    filterNotes.append(note)
                }
            }
            notes = filterNotes
        } else {
            notes = allNotes
        }

        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        notes = getNotes()
        tableView.reloadData()
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }

}
