//
//  UpdatePatientViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/7/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class UpdatePatientViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var mobileTextField: UITextField!
    

    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var staffIDTextField: UITextField!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveActionButton(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.layer.cornerRadius = 5
        
        lastNameTextField.layer.cornerRadius = 5
        emailAddressTextField.layer.cornerRadius = 5
        mobileTextField.layer.cornerRadius = 5
        staffIDTextField.layer.cornerRadius = 5
        
        saveButton.layer.cornerRadius = 4

        // Do any additional setup after loading the view.
    }


}
