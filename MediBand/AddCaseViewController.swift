//
//  CaseDetailViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/11/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

protocol addCaseControllerDelegate: class {
    func addCaseController(controller: AddCaseViewController,
        filledInDetails details: String)
}

class AddCaseViewController: UIViewController {
    
    
    var tap:UITapGestureRecognizer!
    
    @IBOutlet weak var addCaseNote: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    weak var delegate: addCaseControllerDelegate!
    
    
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var noteTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addCaseNote.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 4
        okButton.layer.cornerRadius = 4
        noteTextView.layer.cornerRadius = 5
        
        tap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    
    func handleSingleTap(sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }


    @IBAction func addCaseNoteButton() {
        
        println("add case note clicked")
    }
    
    
    
    @IBAction func okayButtonAction() {
        delegate?.addCaseController(self, filledInDetails: self.noteTextView.text)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        println("ok button clicked")
    }
    
    
    @IBAction func cancel() {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height/2
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height/2
        }
    }
    
    

}
