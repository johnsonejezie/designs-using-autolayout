//
//  HomeViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 9/17/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import Haneke

class HomeViewController: UIViewController  {
    

    @IBOutlet var myTaskBtn: UIButton!
    
    
    @IBOutlet var staffBtn: UIButton!
    @IBOutlet var myPatientsBtn: UIButton!
    
    @IBOutlet var newPatientBtn: UIButton!
    
    
    @IBOutlet var myProfileBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTaskBtn.backgroundColor = UIColor(red: 0.71, green: 0.07, blue: 0.01, alpha: 1)
        myPatientsBtn.backgroundColor = UIColor(red: 0.01, green: 0.04, blue: 0.21, alpha: 1)
        newPatientBtn.backgroundColor = UIColor(red: 0.01, green: 0.38, blue: 0.01, alpha: 1)
        myProfileBtn.backgroundColor = UIColor(red: 0.14, green: 0.07, blue: 0.69, alpha: 1)
        staffBtn.backgroundColor = UIColor(red: 0.42, green: 0.78, blue: 0.78, alpha: 1)
        
        myTaskBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        myPatientsBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        newPatientBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        myProfileBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        staffBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func myTask() {
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("TaskViewController")
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    @IBAction func myPatients() {
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("PatientsViewController")
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    
    
    @IBAction func myProfile() {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("StaffProfileViewController") as! StaffProfileViewController
            viewController.isMyProfile = true
            self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func newPatients() {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("BarcodeViewController")
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    
    
    @IBAction func staff() {
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("StaffViewController")
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
}
