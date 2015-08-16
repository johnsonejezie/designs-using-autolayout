//
//  ActivityDetailsViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/11/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class PatientProfileViewController: UIViewController {
    
    
    @IBOutlet var navBar: UIBarButtonItem!
    var patient:Patient!
    @IBOutlet weak var imageView: UIImageView!
    

    @IBOutlet weak var contactLabel: UILabel!
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    @IBOutlet var firstNameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet var lastNameLabel: UILabel!
    
    @IBOutlet weak var generalPhysicianLabel: UILabel!
    @IBOutlet weak var addCareButton: UIButton!
    @IBOutlet weak var viewCaseNoteButton: UIButton!
    @IBOutlet weak var viewHistoryButton: UIButton!
    @IBOutlet weak var UpdatePatientButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.target = self.revealViewController()
        navBar.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        addCareButton.layer.cornerRadius = 4
        viewCaseNoteButton.layer.cornerRadius = 4
        viewHistoryButton.layer.cornerRadius = 4
        UpdatePatientButton.layer.cornerRadius = 4
    }
    
    override func viewDidAppear(animated: Bool) {
        firstNameLabel.text = patient.forename.uppercaseString
        lastNameLabel.text = patient.surname.uppercaseString
        contactLabel.text = patient.addressphone
        addressLabel.text = patient.address
        generalPhysicianLabel.text = patient.gp
        let image = UIImage(contentsOfFile: patient.image as! String)
        println(image)
//        imageView.image = image
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setScreeName("Patient Profile View")
    }
    
    override func viewDidLayoutSubviews() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.height/2
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }

    @IBAction func addCareActionButton() {
        self.trackEvent("UX", action: "Add care from patient view", label: "Add Care button", value: nil)
        
        self.performSegueWithIdentifier("AddCareActivity", sender: nil)
    }


    @IBAction func viewCaseNoteActionButton() {
        
        self.trackEvent("UX", action: "View Case Note", label: "View Case Button in Patient Profile", value: nil)
        
        self.performSegueWithIdentifier("viewCaseNote", sender: nil)
    }

    @IBAction func viewHistoryActionButton() {
        self.trackEvent("UX", action: "View Patient History", label: "view history button in patient profile", value: nil)
    }
    @IBAction func updatePatientActionButton() {
        
        self.trackEvent("UX", action: "Updating patient", label: "update patient button in patient profile view", value: nil)
    }
}

extension PatientProfileViewController {
    
    func setScreeName(name: String) {
        self.title = name
        self.sendScreenView(name)
    }
    
    func sendScreenView(screenName: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: self.title)
        let build = GAIDictionaryBuilder.createScreenView().set(screenName, forKey: kGAIScreenName).build() as NSDictionary
        
        tracker.send(build as [NSObject: AnyObject])
    }
    
    func trackEvent(category: String, action: String, label: String, value: NSNumber?) {
        let tracker = GAI.sharedInstance().defaultTracker
        let trackDictionary = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build()
        tracker.send(trackDictionary as [NSObject: AnyObject])
    }
    
}




