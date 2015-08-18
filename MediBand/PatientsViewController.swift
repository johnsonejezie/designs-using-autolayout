//
//  PatientsViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/15/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftSpinner

class PatientsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, addPatientControllerDelegate {
    
    var isExistingPatient:Bool = false
    var patientID:String = ""
    
    @IBOutlet var navBar: UIBarButtonItem!
    @IBAction func navBar(sender: UIBarButtonItem) {
        println("called")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        toggleSideMenuView()
        
    }
    var patients = sharedDataSingleton.patients

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.target = self.revealViewController()
        navBar.action = Selector("revealToggle:")
        
        let patientNetworkCall = PersonNewtworkCall()
        if sharedDataSingleton.patients.count > 0 {
            patientNetworkCall.getAllPatients(sharedDataSingleton.user.id, fromMedicalFacility: sharedDataSingleton.user.medical_facility) { (success) -> Void in
                if success == true {
                    println("successfully fetched patient")
                    self.patients = sharedDataSingleton.patients
                    self.tableView.reloadData()
                }else {
                    println("failed")

                }
            }
        }else {
            SwiftSpinner.show("Loading Patients", animated: true)
            patientNetworkCall.getAllPatients(sharedDataSingleton.user.id, fromMedicalFacility: sharedDataSingleton.user.medical_facility) { (success) -> Void in
                if success == true {
                    println("successfully fetched patient")
                    self.patients = sharedDataSingleton.patients
                    self.tableView.reloadData()
                    SwiftSpinner.hide(completion: nil)
                }else {
                    println("failed")
                }
            }
        }


//         self.sideMenuController()?.sideMenu?.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)

    }
    
    override func viewWillAppear(animated: Bool) {
        self.setScreeName("Patients List View")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if patients.count > 0 {
            return patients.count
        }else {
          return 1
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("patientsCell") as! PatientsTableViewCell
        
        if patients.count > 0 {
            let patient = patients[indexPath.row]
            println(patient.occupation)
            cell.patientNameLabel.text = patient.forename + " " + patient.surname
            cell.generalPhysicianLabel.text = patient.gp
        }else {
           cell.patientNameLabel.text = "Mr FRED PATRICK"
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var selectedPatient: Patient = patients[indexPath.row]
        sharedDataSingleton.selectedPatient = patients[indexPath.row]
        if isExistingPatient {
           performSegueWithIdentifier("EditPatient", sender: selectedPatient)
        }else{
             performSegueWithIdentifier("ViewPatient", sender: selectedPatient)
        }
    }
    
    func addPatientViewController(controller: AddPatientViewController, didFinishedAddingPatient patient: NSDictionary) {
        println(patient)
    }
    
    @IBAction func addPatientBarButton(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("AddPatient", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditPatient" {
            let navigationController = segue.destinationViewController
                as! UINavigationController
            let controller = navigationController.topViewController
                as! AddPatientViewController
            controller.patientID = patientID
            controller.isEditingPatient = true
        }else if segue.identifier == "ViewPatient" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! PatientProfileViewController
            controller.patient = sender as? Patient
        }
    }

}

extension PatientsViewController {
    
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
