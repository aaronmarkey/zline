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
    var archivedNotes: Bool = false
    
    //MARK: Outlets
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet var longPressOnCellOutlet: UILongPressGestureRecognizer!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addNoteButtonOutlet: UIBarButtonItem!
    
    //MARK: Actions
    @IBAction func longPressOnCell(_ sender: AnyObject) {
        if(!archivedNotes) {
            let touchPoint = longPressOnCellOutlet.location(in: self.view)
            if let index = self.tableView.indexPathForRow(at: touchPoint) {
                if((index as NSIndexPath).row < self.tableView.visibleCells.count) {
                    if(sender.state == UIGestureRecognizerState.began) {
                        self.performSegue(withIdentifier: "toEditNoteFromNoteTable", sender: sender)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(self.navigationController?.restorationIdentifier == "archivedNotes") {
            archivedNotes = true
            addNoteButtonOutlet.isEnabled = false
            addNoteButtonOutlet.tintColor = .white
            self.title = "Archives"
        }
        
        if let sb = searchBar {
            if (sb.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                self.notes = getNotes(archived: archivedNotes)
                self.tableView.setContentOffset(CGPoint(x: 0.0, y: (self.tableView.tableHeaderView?.frame.size.height)!), animated: false)
            } else {
                notes = searchNotes(term: sb.text)
            }
        } else {
            notes = getNotes(archived: archivedNotes)
        }
        
        if(getNotes(archived: archivedNotes).isEmpty) {
            let nib = UINib(nibName: "EmptyTable", bundle: nil)
            let empty = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            self.view = empty
        } else if(notes.isEmpty) {
            createNothingFoundView()
            self.view = tableView
            tableView.reloadData()
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
        self.navigationController?.navigationBar.tintColor = customColor(color: "primary")
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions = [UITableViewRowAction]()
        
        if(self.navigationController?.restorationIdentifier == "archivedNotes") {
            actions.append(UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteNoteHandler))
            actions.append(UITableViewRowAction(style: .normal, title: "Unarchive", handler: archiveNoteHandler))
        } else {
//            actions.append(UITableViewRowAction(style: .normal, title: "Archive", handler: archiveNoteHandler))
            actions.append(UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteNoteHandler))

        }

        return actions
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func deleteNoteHandler(action: UITableViewRowAction, index: IndexPath) -> Void {
        deleteNote(note: notes[index.row])
        notes.remove(at: index.row)
        
        tableView.deleteRows(at: [index], with: .fade)
        
        if(getNotes(archived: archivedNotes).isEmpty) {
            let nib = UINib(nibName: "EmptyTable", bundle: nil)
            let empty = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            self.view = empty
        }
    }
    
    func archiveNoteHandler(action: UITableViewRowAction, index: IndexPath) -> Void {
        archiveFlipNote(note: notes[index.row])
        notes.remove(at: index.row)
        
        tableView.deleteRows(at: [index], with: .fade)
        
        if(getNotes(archived: archivedNotes).isEmpty) {
            let nib = UINib(nibName: "EmptyTable", bundle: nil)
            let empty = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            self.view = empty
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
                let note = notes[(index as NSIndexPath).row]
                destination.isNew = false
                destination.note = note
            }
        }
        
        if(segue.identifier == "toPreviewNote") {
            let destination = segue.destination as! NotePreviewViewController
            let index = tableView.indexPathForSelectedRow as IndexPath?
            let note = notes[(index! as NSIndexPath).row] as! NoteMO
            
            destination.rawString = note.content!
            destination.note = notes[(index! as NSIndexPath).row]
        }
    }
    
    
    //MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.trimmingCharacters(in: .whitespaces)
        notes = searchNotes(term: text)
        
        if(notes.isEmpty) {
            createNothingFoundView()
        } else {
            removeNothingFoundView(tableView: tableView)
        }
        
        tableView.reloadData()
    }
    
    func searchNotes(term: String?) -> [NSManagedObject] {
        if (!(term?.isEmpty)!) {
            var filterNotes = [NSManagedObject]()
            for note in getNotes(archived: archivedNotes) {
                let noteObject = note as! NoteMO
                if(noteObject.content!.lowercased().contains(term!.lowercased())) {
                    filterNotes.append(note)
                }
            }
            return filterNotes
        } else {
            return getNotes(archived: archivedNotes)
        }
    }
    
    func createNothingFoundView() {
        let noResults = UIView(frame: CGRect(x: 0.0, y: searchBar.frame.height, width: self.view.frame.width, height: 44.0))
        noResults.backgroundColor = .white
        noResults.tag = -1
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        noResults.addSubview(label)
        label.center = CGPoint(x: (label.superview?.frame.width)! / 2, y: (label.superview?.frame.height)! / 2)
        label.textAlignment = .center
        label.textColor = customColor(color: "gray-regular")
        label.text = "Nothing Found"
        
        tableView.addSubview(noResults)
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
        notes = getNotes(archived: archivedNotes)
        tableView.reloadData()
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        removeNothingFoundView(tableView: tableView)
    }
    
    func removeNothingFoundView(tableView view: UITableView) {
        view.subviews.forEach({ subview in
            if(subview.tag == -1) {
                subview.removeFromSuperview()
            }
        })
    }

}
