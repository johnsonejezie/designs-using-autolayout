//
//  StaffProfileViewController.swift
//  MediBand
//
//  Created by Kehinde Shittu on 7/7/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class StaffProfileViewController: UIViewController {
    
    
    @IBOutlet weak var staffImageView: UIImageView!
    @IBOutlet weak var staffNameLabel: UILabel!
    @IBOutlet weak var staffIDLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var generlPracticeLabel: UILabel!
    @IBOutlet weak var generalPractitionerIDLabel: UILabel!

    var staff = Staff()
    var isMyProfile:Bool?
    
    
    @IBOutlet var navBar: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            navBar.target = self.revealViewController()
            navBar.action = Selector("revealToggle:")
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        if isMyProfile == true {
            sharedDataSingleton.isEditingProfile = true
//            self.navigationController!.navigationBar.hidden = true
            if sharedDataSingleton.user.isAdmin == true {
               self.updateStaffButton.setTitle("Update Profile", forState: UIControlState.Normal)
            }else {
                
               self.updateStaffButton.hidden == true
            }
            staffNameLabel.text = sharedDataSingleton.user.firstName + " " + sharedDataSingleton.user.surname
            staffIDLabel.text = sharedDataSingleton.user.memberid
            specialityLabel.text = sharedDataSingleton.user.speciality
            generalPractitionerIDLabel.text = sharedDataSingleton.user.general_practitioner_id
            generlPracticeLabel.text = sharedDataSingleton.user.email
        }else {
            sharedDataSingleton.selectedStaff = staff
            self.navigationItem.setLeftBarButtonItem(nil, animated: true)
            staffIDLabel.text = staff.id
            staffNameLabel.text = "\(staff.firstname) \(staff.surname)"
            generalPractitionerIDLabel.text = staff.general_practional_id
            generlPracticeLabel.text = staff.email
            specialityLabel.text = staff.speciality
            
            if staff.image != "" {
                let URL = NSURL(string: staff.image)!
                staffImageView.hnk_setImageFromURL(URL)
            }else {
                staffImageView.image = UIImage(named: "defaultImage")
            }
        }
    }

    
    override func viewDidLayoutSubviews() {
        staffImageView.clipsToBounds = true
        staffImageView.layer.cornerRadius = staffImageView.frame.size.height/2
        updateStaffButton.layer.cornerRadius = 4
        viewHistoryButton.layer.cornerRadius = 4

    }
    
    
    @IBOutlet var viewHistoryButton: UIButton!
    
    @IBOutlet var updateStaffButton: UIButton!
    
    
    override func viewWillAppear(animated: Bool) {
        self.setScreeName("Staff Profile")
        UINavigationBar.appearance().barTintColor = sharedDataSingleton.theme
        viewHistoryButton.backgroundColor = sharedDataSingleton.theme
        updateStaffButton.backgroundColor = sharedDataSingleton.theme
//        lineView.backgroundColor = sharedDataSingleton.theme
    }
    @IBAction func updateStaff() {
        let addStaffViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddStaffViewController") as! AddStaffViewController
        addStaffViewController.isUpdatingStaff = true
        addStaffViewController.staff = self.staff
        if isMyProfile == true {
            sharedDataSingleton.isEditingProfile = true
            isMyProfile = false
            addStaffViewController.isEditingMyProfile = true
        }else {
           sharedDataSingleton.selectedStaff = self.staff 
        }
        
        self.navigationController?.pushViewController(addStaffViewController, animated: true)
        self.trackEvent("UX", action:"Update Staff" , label: "Staff update button", value: nil)
    }
    
    
    @IBAction func viewHistory(sender: UIButton) {
        let taskViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TaskViewController") as! ActivitiesViewController
        taskViewController.isPatientTask = false
        taskViewController.srcViewStaffID = staff.id
        self.navigationController?.pushViewController(taskViewController, animated: true)
        self.trackEvent("UX", action:"View Staff History" , label: "Staff history button", value: nil)
    }
}

extension StaffProfileViewController {
    
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
