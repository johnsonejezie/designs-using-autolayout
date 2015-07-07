//
//  AddStaffViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/7/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class AddStaffViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var staffImageView: UIImageView!
    
    @IBOutlet weak var editPicButton: UIButton!
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var mobileTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var staffIDTextField: UITextField!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    @IBAction func editButtonAction(sender: AnyObject) {
    }

    @IBAction func saveButtonAction(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        staffImageView.layer.masksToBounds = false
        staffImageView.layer.cornerRadius = staffImageView.frame.size.width / 2
        staffImageView.clipsToBounds = true
        
                
        firstNameTextField.layer.cornerRadius = 5
        
        lastNameTextField.layer.cornerRadius = 5
        emailAddressTextField.layer.cornerRadius = 5
        mobileTextField.layer.cornerRadius = 5
        staffIDTextField.layer.cornerRadius = 5
        
        saveButton.layer.cornerRadius = 4

        // Do any additional setup after loading the view.
    }



}
