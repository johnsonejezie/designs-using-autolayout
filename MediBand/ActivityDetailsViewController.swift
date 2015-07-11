//
//  ActivityDetailsViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/11/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class ActivityDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var generalPhysicianTextField: UITextField!
    
    @IBOutlet weak var addCareButton: UIButton!
    @IBOutlet weak var viewCaseNoteButton: UIButton!
    @IBOutlet weak var viewHistoryButton: UIButton!
    @IBOutlet weak var UpdatePatientButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTextField.layer.cornerRadius = 5
        emailTextField.layer.cornerRadius = 5
        generalPhysicianTextField.layer.cornerRadius = 5
        addressTextField.layer.cornerRadius = 5
        
        addCareButton.layer.cornerRadius = 4
        viewCaseNoteButton.layer.cornerRadius = 4
        viewHistoryButton.layer.cornerRadius = 4
        UpdatePatientButton.layer.cornerRadius = 4

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }


}
