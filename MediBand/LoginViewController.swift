//
//  LoginViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/14/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var userNameTextfield: UITextField!
    

    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextfield.layer.cornerRadius = 5
        passwordTextfield.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 4

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


    @IBAction func loginActionButton() {
        
        self.performSegueWithIdentifier("showActivities", sender: nil)
        
    }
    
    
    @IBAction func forgotPasswordActionButton() {
    }
    
    

}
