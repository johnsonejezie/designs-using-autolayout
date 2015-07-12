//
//  CaseDetailViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/11/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class CaseDetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var addCaseNote: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var noteTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addCaseNote.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 4
        okButton.layer.cornerRadius = 4
        noteTextView.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }


    @IBAction func addCaseNoteButton() {
        
        println("add case note clicked")
    }
    
    
    
    @IBAction func okayButtonAction() {
        
        println("ok button clicked")
    }
    
    
    @IBAction func cancel() {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

}
