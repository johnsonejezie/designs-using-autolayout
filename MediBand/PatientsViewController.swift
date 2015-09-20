//
//  PatientsViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/15/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftSpinner


class PatientsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var isExistingPatient:Bool = false
    var patientID:String = ""
    var currentPageNumber:Int = 1
    var isRefreshing:Bool = false
    var isFirstLoad:Bool = true
    
    @IBOutlet var navBar: UIBarButtonItem!
    @IBAction func navBar(sender: UIBarButtonItem) {
        print("called")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //        toggleSideMenuView()
        
    }
    var patients = sharedDataSingleton.patients
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.target = self.revealViewController()
        navBar.action = Selector("revealToggle:")
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        let pageNoToString:String = String(currentPageNumber)
        getPatients(pageNoToString)
        tableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
    }
    
    func getPatients(pageNumber:String) {
        let patientAPI = PatientAPI()
        if sharedDataSingleton.patients.count <= 0 {
            SwiftSpinner.show("Loading Patients", animated: true)
            patientAPI.getAllPatients(sharedDataSingleton.user.id, fromMedicalFacility: sharedDataSingleton.user.medical_facility, withPageNumber:pageNumber) { (success) -> Void in
                if success == true {
                    self.patients = sharedDataSingleton.patients
                    self.tableView.reloadData()
                    SwiftSpinner.hide(nil)
                }else {
                    SwiftSpinner.hide(nil)
                    
                }
            }
        }else {
            patientAPI.getAllPatients(sharedDataSingleton.user.id, fromMedicalFacility: sharedDataSingleton.user.medical_facility, withPageNumber:pageNumber) { (success) -> Void in
                if success == true {
                    self.patients = sharedDataSingleton.patients
                    self.tableView.reloadData()
                }else {
                    
                }
            }
        }
    }
    
    //    func scrollViewDidScroll(scrollView: UIScrollView) {
    //        println("table scrolling")
    //        if isFirstLoad == true {
    //            isFirstLoad = false
    //            return
    //        }
    //        if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
    //            if isRefreshing == false {
    //                isRefreshing = true
    //                SwiftSpinner.show("loading more patient", animated: true)
    //                currentPageNumber = currentPageNumber + 1
    //                let pageNumber:String = String(currentPageNumber)
    //                let patientAPI = PatientAPI()
    //                patientAPI.getAllPatients(sharedDataSingleton.user.id, fromMedicalFacility: sharedDataSingleton.user.medical_facility, withPageNumber: pageNumber, completionHandler: { (success) -> Void in
    //                    if success == true {
    //                        self.tableView.reloadData()
    //                    }else {
    //                        self.isRefreshing = false
    //                        self.currentPageNumber--
    //                    }
    //                })
    //            }
    //        }
    //    }
    
    override func viewWillAppear(animated: Bool) {
        self.setScreeName("Patients List View")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if patients.count > 0 {
            count = patients.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("patientsCell") as! PatientsTableViewCell
        if patients.count > 0 {
            cell.emptyLabel.hidden = true
            cell.patientNameLabel.hidden = false
            cell.generalPhysicianLabel.hidden = false
            cell.patientImageView.hidden = false
            let patient = patients[indexPath.row]
            print(patient.occupation)
            cell.patientNameLabel.text = patient.forename + " " + patient.surname
            cell.generalPhysicianLabel.text = patient.gp
            
            if patient.image != "" {
                let URL = NSURL(string: patient.image)!
                
                cell.patientImageView.hnk_setImageFromURL(URL)
            }else {
                cell.patientImageView.image = UIImage(named: "defaultImage")
            }
            
        }else {
            cell.patientImageView.hidden = true
            cell.patientNameLabel.hidden = true
            cell.generalPhysicianLabel.hidden = true
            cell.emptyLabel.hidden = false
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedPatient: Patient = patients[indexPath.row]
        sharedDataSingleton.selectedPatient = patients[indexPath.row]
        if isExistingPatient {
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("PatientProfileViewController")
            self.navigationController?.pushViewController(viewController!, animated: true)
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
    
    func addPatientViewController(controller: NewPatientViewController, didFinishedAddingPatient patient: NSDictionary) {
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
                as! NewPatientViewController
            controller.patientID = patientID
            controller.isEditingPatient = true
        }else if segue.identifier == "ViewPatient" {
//            let navigationController = segue.destinationViewController as! UINavigationControllers
            let controller = segue.destinationViewController as! PatientProfileViewController
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
