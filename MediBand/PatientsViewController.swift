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
    var currentPageNumber:Int = 1
    var isRefreshing:Bool = false
    var isFirstLoad:Bool = true
    
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
        let pageNoToString:String = String(currentPageNumber)
        getPatients(pageNoToString)

        tableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)

    }
    
    func getPatients(pageNumber:String) {
        let patientNetworkCall = PersonNewtworkCall()
        if sharedDataSingleton.patients.count <= 0 {
            SwiftSpinner.show("Loading Patients", animated: true)
            patientNetworkCall.getAllPatients(sharedDataSingleton.user.id, fromMedicalFacility: sharedDataSingleton.user.medical_facility, withPageNumber:pageNumber) { (success) -> Void in
                if success == true {
//                    println("successfully fetched patient")
                    self.patients = sharedDataSingleton.patients
                    self.tableView.reloadData()
                    SwiftSpinner.hide(completion: nil)
                }else {
                    SwiftSpinner.hide(completion: nil)
                    var alertview = JSSAlertView().show(self, title: "Error", text: "Failed to get patients. Tap on Retry to try again or Cancel to dismiss this alert", buttonText: "Retry", cancelButtonText: "Cancel")
                    alertview.setTitleFont("ClearSans-Light")
                    alertview.setTextFont("ClearSans")
                    alertview.setButtonFont("ClearSans-Bold")
                    alertview.addAction(self.closeCallback)
                    alertview.addCancelAction(self.cancelCallback)
//                    println("failed")
                }
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("table scrolling")
        if isFirstLoad == true {
            isFirstLoad = false
            return
        }
        if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
            if isRefreshing == false {
                isRefreshing = true
                SwiftSpinner.show("loading more patient", animated: true)
                currentPageNumber = currentPageNumber + 1
                let pageNumber:String = String(currentPageNumber)
                let patientNetworkCall = PersonNewtworkCall()
                patientNetworkCall.getAllPatients(sharedDataSingleton.user.id, fromMedicalFacility: sharedDataSingleton.user.medical_facility, withPageNumber: pageNumber, completionHandler: { (success) -> Void in
                    if success == true {
                        self.tableView.reloadData()
                    }else {
                        self.isRefreshing = false
                        self.currentPageNumber--
                    }
                })
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setScreeName("Patients List View")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if patients.count > 0 {
            count = patients.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("patientsCell") as! PatientsTableViewCell
        if patients.count > 0 {
            let patient = patients[indexPath.row]
            println(patient.occupation)
            cell.patientNameLabel.text = patient.forename + " " + patient.surname
            cell.generalPhysicianLabel.text = patient.gp
        }else {
           cell.patientNameLabel.text = "No Patient assigned to you"
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
    
    
    func closeCallback() {
//        println("Close callback called")
    }
    
    func cancelCallback() {
//        println("Cancel callback called")
    }
    
    func addPatientViewController(controller: AddPatientViewController, didFinishedAddingPatient patient: NSDictionary) {
//        println(patient)
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
