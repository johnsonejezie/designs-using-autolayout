//
//  PatientsViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/15/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class PatientsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, addPatientControllerDelegate, ENSideMenuDelegate {
    
    var isExistingPatient:Bool = false
    
    @IBAction func navBar(sender: UIBarButtonItem) {
        
        println("called")
        toggleSideMenuView()
        
    }
    var patients = [Patient]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.sideMenuController()?.sideMenu?.delegate = self
        
        let patientNetworkCall = PersonNewtworkCall()
        
        tableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)

        // Do any additional setup after loading the view.
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
            let list = patients[indexPath.row]
            cell.patientNameLabel.text = list.forename + list.surname
            cell.generalPhysicianLabel.text = list.gp
        }else {
           cell.patientNameLabel.text = "Mr FRED PATRICK"
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var selectedPatient: Patient = patients[indexPath.row]
        
        if isExistingPatient {
           performSegueWithIdentifier("EditPatient", sender: selectedPatient)
        }else{
             performSegueWithIdentifier("ViewPatient", sender: nil)
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
            controller.selectedPatient = sender as? Patient
            controller.isEditingPatient = true
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
