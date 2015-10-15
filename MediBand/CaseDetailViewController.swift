//
//  CaseDetailViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 9/14/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class CaseDetailViewController: UIViewController {

    
    var tap:UITapGestureRecognizer!
    var caseNoteDetails = ""
    
    @IBOutlet weak var addCaseNote: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCaseNote.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 4
        noteTextView.layer.cornerRadius = 5
        
        noteTextView.text = caseNoteDetails
        
        tap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        UINavigationBar.appearance().barTintColor = sharedDataSingleton.theme
        addCaseNote.backgroundColor = sharedDataSingleton.theme
        cancelButton.backgroundColor = sharedDataSingleton.theme
    }
    
    func handleSingleTap(sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @IBAction func cancel() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }

}
