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
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var isNew: Bool! = false
    var note: NSManagedObject = NSManagedObject()
    var viewControllers: [UIViewController] = []
    var nextView: String = ""

    
    //MARK: Actions
    @IBAction func cancelToNoteTableViewController(segue: UIStoryboardSegue) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(isNew == false) {
            textView.text = (note as! NoteMO).content
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
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShowHandle(note:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillHideHandle), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        let nib = UINib(nibName: "MarkdownKeyboard", bundle: nil)
        let markdownKeyboardView = nib.instantiate(withOwner: self, options: nil)[0] as! MarkdownKeyboardUIView
        markdownKeyboardView.setButtons(textView: textView)
        
        
        textView.inputAccessoryView = markdownKeyboardView
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(isNew == true) {
            if(!textView.text.isEmpty && nextView.isEmpty) {
                    storeNote(content: textView.text, date: NSDate())
                }
        } else {
            if(!textView.text.isEmpty) {
                if(textView.text != (note as! NoteMO).content) {
                    updateNote(content: textView.text, date: NSDate(), note: note)
                    if let parent = self.parent?.childViewControllers.last as? NotePreviewViewController {
                        parent.rawString = textView.text
                    }
                }
            } else {
                deleteNote(note: note)
                let table = self.storyboard?.instantiateViewController(withIdentifier: "NoteTable") as! NoteTableViewController
                self.navigationController?.viewControllers.removeAll()
                self.navigationController?.pushViewController(table, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toMarkdownHelp") {
            textView.resignFirstResponder()
            nextView = segue.identifier!
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        nextView = ""
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
    
    func keyboardWillShowHandle(note:NSNotification) {
        guard let keyboardRect = note.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboard = keyboardRect.cgRectValue
        textViewBottomConstraint.constant = keyboard.height
        view.layoutIfNeeded()
    }
    
    func keyboardWillHideHandle() {
        textViewBottomConstraint.constant = 0
        view.layoutIfNeeded()
    }
}
