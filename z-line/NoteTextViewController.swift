//
//  NoteTextViewController.swift
//  z-line
//
//  Created by Aaron Markey on 1/11/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit
import CoreData

class NoteTextViewController: UIViewController, UITextViewDelegate {

    //MARK: Properties
    @IBOutlet weak var textView: UITextView!
    
    
    var isNew: Bool!
    var existingText: String = ""
    var notes: [NSManagedObject] = []
    var index: Int = 0
    var viewControllers: [UIViewController] = []
    
    //MARK: Actions
    @IBAction func cancelToNoteTableViewController(segue: UIStoryboardSegue) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(isNew == false) {
            textView.text = existingText
            textView.delegate = self
            viewControllers = (self.navigationController?.viewControllers)!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(!textView.text.isEmpty) {
            if(isNew == true) {
                storeNote(content: textView.text, date: NSDate())
            } else {
                updateNote(content: textView.text, date: NSDate(), notes: notes, index: index)
                if let parent = self.parent?.childViewControllers.last as? NotePreviewViewController {
                    parent.rawString = textView.text
                }
            }
        } else {
            deleteNote(notes: notes, index: index)
            let table = self.storyboard?.instantiateViewController(withIdentifier: "NoteTable") as! NoteTableViewController
            self.navigationController?.viewControllers.removeAll()
            self.navigationController?.pushViewController(table, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toMarkdownHelp") {
            textView.resignFirstResponder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if(textView.text.isEmpty) {
            let table = self.storyboard?.instantiateViewController(withIdentifier: "NoteTable") as! NoteTableViewController
            self.navigationController?.viewControllers.remove(at: (self.navigationController?.viewControllers.count)! - 2)
            self.navigationController?.viewControllers = [table, self]
        } else {
            self.navigationController?.viewControllers = viewControllers
        }
    }
 
}
