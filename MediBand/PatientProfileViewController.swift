//
//  ActivityDetailsViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/11/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class PatientProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    

    @IBOutlet weak var contactLabel: UILabel!
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    @IBOutlet weak var generalPhysicianLabel: UILabel!
    @IBOutlet weak var addCareButton: UIButton!
    @IBOutlet weak var viewCaseNoteButton: UIButton!
    @IBOutlet weak var viewHistoryButton: UIButton!
    @IBOutlet weak var UpdatePatientButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        addCareButton.layer.cornerRadius = 4
        viewCaseNoteButton.layer.cornerRadius = 4
        viewHistoryButton.layer.cornerRadius = 4
        UpdatePatientButton.layer.cornerRadius = 4
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.height/2
    }
    


    @IBAction func addCareActionButton() {
        
        self.performSegueWithIdentifier("AddCareActivity", sender: nil)
    }


    @IBAction func viewCaseNoteActionButton() {
        
        self.performSegueWithIdentifier("viewCaseNote", sender: nil)
    }

    @IBAction func viewHistoryActionButton() {
    }
    @IBAction func updatePatientActionButton() {
    }
}
