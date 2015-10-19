//
//  ActivityDetailsViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/11/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class PatientProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var arrayOfKeys = []
    var arrayOfValues = []
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navBar: UIBarButtonItem!

    @IBOutlet weak var addCareButton: UIButton!
    @IBOutlet weak var viewHistoryButton: UIButton!
    @IBOutlet weak var UpdatePatientButton: UIButton!
    var patient: Patient!;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        sharedDataSingleton.selectedIDs = []
        let patientDict:NSDictionary = [
            "Patient id": patient.patient_id,
            "Title": patient.lkp_nametitle,
            "Marital Status": patient.maritalstatus,
            "Medical Insurance Provider": patient.medicalinsuranceprovider,
            "Forename": patient.forename,
            "Surname": patient.surname,
            "Middle Name": patient.middlename,
            "Phone": patient.addressphone,
            "Address": patient.address,
            "Other phone": patient.addressotherphone,
            "Post Code": patient.addresspostcode,
            "Occupation": patient.occupation,
            "Nationality": patient.nationality,
            "Date of birth": patient.dob,
            "gp": patient.gp,
            "gpsurgery": patient.gpsurgery,
            "Is patient a child?": patient.ischild,
            "Language": patient.language,
            "Next of Kin": patient.next_of_kin,
            "Next of kin contact": patient.next_of_kin_contact
        ]
        
        
        
        arrayOfKeys = patientDict.allKeys
        arrayOfValues = patientDict.allValues
        
        print(patientDict)
        print(arrayOfValues)
        
          UINavigationBar.appearance().barTintColor = sharedDataSingleton.theme
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        addCareButton.layer.cornerRadius = 4
        viewHistoryButton.layer.cornerRadius = 4
        UpdatePatientButton.layer.cornerRadius = 4
        addCareButton.backgroundColor = sharedDataSingleton.theme
        UpdatePatientButton.backgroundColor = sharedDataSingleton.theme
        viewHistoryButton.backgroundColor = sharedDataSingleton.theme

    }
    
    
    override func viewWillAppear(animated: Bool) {
        sharedDataSingleton.selectedPatient = patient
        self.setScreeName("Patient Profile View")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return arrayOfValues.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("PatientCellImage", forIndexPath: indexPath)
            tableView.rowHeight = 120
            let imageView: UIImageView = cell.viewWithTag(200) as! UIImageView
            imageView.layer.cornerRadius = 54
            imageView.clipsToBounds = true
            if patient.image != "" {
                let URL = NSURL(string: patient.image)!
                imageView.hnk_setImageFromURL(URL)
            }else {
                imageView.image = UIImage(named: "defaultImage")
            }
            return cell
            
        }else {
            tableView.rowHeight = 48
            let cell = tableView.dequeueReusableCellWithIdentifier("PatientCell", forIndexPath: indexPath)
            let keyLabel:UILabel = cell.viewWithTag(100) as! UILabel
            keyLabel.text = arrayOfKeys[indexPath.row] as? String
            let valueLabel : UILabel = cell.viewWithTag(101) as! UILabel
            if keyLabel.text == "Is patient a child?" {
                if arrayOfValues[indexPath.row] as! NSObject == false {
                    valueLabel.text = "false"
                }else {
                    valueLabel.text = "true"
                }
            }else {
                valueLabel.text = arrayOfValues[indexPath.row] as? String
            }
            
            
            
            
            
            
            return cell
        }
        
    }
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    override func viewDidLayoutSubviews() {
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = imageView.frame.size.height/2
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
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
        sharedDataSingleton.selectedPatient = patient
        let taskViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TaskViewController") as! ActivitiesViewController
        taskViewController.isPatientTask = true
        taskViewController.patient = patient
        taskViewController.patientID = patient.patient_id
        sharedDataSingleton.isCheckingNewPatientID = true
        self.navigationController?.pushViewController(taskViewController, animated: true)
        self.trackEvent("UX", action: "View Patient History", label: "view history button in patient profile", value: nil)
    }
    @IBAction func updatePatientActionButton() {
        sharedDataSingleton.selectedPatient = patient
        sharedDataSingleton.patientID = patient.patient_id
        self.performSegueWithIdentifier("EditPatient", sender: nil);
        
        self.trackEvent("UX", action: "Updating patient", label: "update patient button in patient profile view", value: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditPatient" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! NewPatientViewController
            controller.patientID = patient.patient_id
            controller.isEditingPatient = true
        }
    }
}

extension PatientProfileViewController {
    
    func setScreeName(name: String) {
//        self.title = name
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




