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
    
    @IBOutlet var navBar: UIBarButtonItem!

    @IBOutlet var myTaskBtn: UIButton!
    
    
    @IBOutlet var staffBtn: UIButton!
    @IBOutlet var myPatientsBtn: UIButton!
    
    @IBOutlet var newPatientBtn: UIButton!
    
    
    @IBOutlet var myProfileBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if sharedDataSingleton.user.isAdmin == true {
            staffBtn.hidden = false
        }
        
        if self.revealViewController() != nil {
            navBar.target = self.revealViewController()
            navBar.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        myTaskBtn.backgroundColor = UIColor(red: 206/255, green: 73/255, blue: 54/255, alpha: 1)
        myPatientsBtn.backgroundColor = UIColor(red: 0.00, green: 51/255, blue: 102/255, alpha: 1)
        newPatientBtn.backgroundColor = UIColor(red: 51/255, green: 152/255, blue: 0.00, alpha: 1)
        myProfileBtn.backgroundColor = UIColor(red: 102/255, green: 0.00, blue: 204/255, alpha: 1)
        staffBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
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
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! StaffProfileViewController
            viewController.isMyProfile = true
            self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func newPatients() {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("BarcodeViewController")
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    
    
    @IBAction func staff() {
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("StaffViewController") as! StaffTableViewController
        viewController.sideMenuRequired = false
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
