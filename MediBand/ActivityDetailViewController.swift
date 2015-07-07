//
//  ActivityDetailViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/7/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class ActivityDetailViewController: UIViewController {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var contactLabel: UITextField!
    
    @IBOutlet weak var emailAddressLabel: UITextField!
    
    @IBOutlet weak var addressLabel: UITextField!
    
    @IBOutlet weak var generalPhysicianLabel: UITextField!
    
    @IBOutlet weak var addCareButton: UIButton!
    
    @IBOutlet weak var viewCaseButton: UIButton!
    
    @IBOutlet weak var viewHistoryButton: UIButton!
    
    @IBOutlet weak var updatePatient: UIButton!
    
    @IBAction func addCareActionButton() {
    }
    
    @IBAction func viewCaseActionButton() {
    }
    
    @IBAction func viewHistoryActionButton() {
    }
    
    @IBAction func updatePatientActionButton() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCareButton.layer.cornerRadius = 4
        viewCaseButton.layer.cornerRadius = 4
        viewHistoryButton.layer.cornerRadius = 4
        updatePatient.layer.cornerRadius = 4

        // Do any additional setup after loading the view.
    }



}
