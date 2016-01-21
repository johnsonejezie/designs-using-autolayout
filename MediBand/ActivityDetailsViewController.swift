//
//  ActivityDetailsViewController.swift
//  MediBand
//
//  Created by Kehinde Shittu on 7/25/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import Haneke
import SwiftSpinner
import JLToast
class ActivityDetailsViewController: UIViewController , UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate, menuViewControllerDelegate{
    
    
    @IBOutlet var taskPatientNameLabel: UILabel!

    
    @IBOutlet var taskCareActivityLabel: UILabel!

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var assignedByLabel: UILabel!
    @IBOutlet var careTypeLabel: UILabel!

    @IBOutlet var specialityLabel: UILabel!
    var currentCell : Int = 1;
    
    @IBOutlet var lineView: UIView!
    @IBOutlet var navBar: UIBarButtonItem!
    @IBOutlet var updateActivityButton: UIButton!
    @IBOutlet var viewCaseNoteButton: UIButton!
    @IBOutlet var viewPatientButton: UIButton!
    @IBOutlet var attendingProfCollectionView: UICollectionView!

    var task:Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStaff()

        self.updateActivityButton.layer.cornerRadius = 5.0;
        self.viewCaseNoteButton.layer.cornerRadius = 5.0;
        self.viewPatientButton.layer.cornerRadius = 5.0;
        self.attendingProfCollectionView.dataSource = self
        self.attendingProfCollectionView.delegate = self
        
        let constants = Contants()
        specialityLabel.text = self.fetchStringValueFromArray(constants.specialist, atIndex: (task.specialist_id as String))
        taskCareActivityLabel.text = self.fetchStringValueFromArray(constants.care, atIndex: (task.care_activity_id as String))
        careTypeLabel.text = self.fetchStringValueFromArray(constants.careType, atIndex: (task.care_activity_type_id as String))
        taskPatientNameLabel.text = task.task_patient_name
        let aStaff = task.attending_professionals[0]
        assignedByLabel.text = aStaff.name
        
        var dateString = ""
        let formatter : NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateFormat = "EEE, MMM d, yyyy"
        dateString = formatter.stringFromDate(task.created)
        dateLabel.text = dateString
        
        updateActivityButton.setTitle(task.resolution, forState: UIControlState.Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        setScreeName("Task Detail View")
        UINavigationBar.appearance().barTintColor = sharedDataSingleton.theme
        viewCaseNoteButton.backgroundColor = sharedDataSingleton.theme
        viewPatientButton.backgroundColor = sharedDataSingleton.theme
        updateActivityButton.setTitleColor(sharedDataSingleton.theme, forState: UIControlState.Normal)
        lineView.backgroundColor = sharedDataSingleton.theme
    }
    
    
    func getStaff(){
        let staffMethods = StaffNetworkCall()
        
        if sharedDataSingleton.allStaffs.count == 0 {
//            SwiftSpinner.show("Loading Staff", animated: true)
            staffMethods.getStaffs(sharedDataSingleton.user.medical_facility, inPageNumber: "1", completionBlock: { (done) -> Void in
                if(done){
                    print("all staffs fetched and passed from staff table view controller")
//                    SwiftSpinner.hide(completion: nil)
                }else{
                    print("error fetching and passing all staffs from staff table view controller")
//                    SwiftSpinner.hide(completion: nil)
                }
            })
        }
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         print(task.attending_professionals.count)
        return task.attending_professionals.count
       
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AnyObject = self.attendingProfCollectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let staff = task.attending_professionals[indexPath.row]
        let userImageView: UIImageView! = cell.viewWithTag(1001) as! UIImageView;
        let userLabel = cell.viewWithTag(1002 ) as! UILabel;
        if staff.image != "" {
            let URL = NSURL(string: staff.image)!
            userImageView.hnk_setImageFromURL(URL)
        }else {
            userImageView.image = UIImage(named: "defaultImage")
        }
        
        userImageView.layer.borderWidth = 1.0;
        userImageView.layer.borderColor = UIColor.blackColor().CGColor;
        userImageView.layer.cornerRadius = userImageView.layer.frame.width/2;
        userImageView.clipsToBounds = true
        userLabel.text = staff.name
        
        return cell as! UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let staffProfileController  = self.storyboard?.instantiateViewControllerWithIdentifier("StaffProfileViewController") as! StaffProfileViewController
        let staf: Staff = task.attending_professionals[indexPath.row]
        
        for staff in sharedDataSingleton.allStaffs {
            if staf.id == staff.id {
               staffProfileController.staff = staff
                self.navigationController?.pushViewController(staffProfileController, animated: true)
            }
        }
    }
    @IBAction func update(sender: UIButton) {
        
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let menuViewController: MenuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        menuViewController.delegate = self
        menuViewController.selectedCell = currentCell
        menuViewController.modalPresentationStyle = .Popover
        let height = CGFloat(44 * Contants().resolution.count)
        menuViewController.preferredContentSize = CGSizeMake(self.view.frame.height/2, height)
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = self.view
        popoverMenuViewController?.sourceRect = CGRect(
            x: self.updateActivityButton.layer.frame.origin.x+self.updateActivityButton.layer.frame.size.width/2-(self.view.frame.height/4)/2,
            y: self.updateActivityButton.layer.frame.origin.y+self.updateActivityButton.layer.frame.size.height/2,
            width: 1,
            height: 1)
        presentViewController(
            menuViewController,
            animated: true,
            completion: nil)
    }
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
    
    func fetchStringValueFromArray(constantArray:[AnyObject], atIndex indexAsString:String)->String {
        var count:Int?
        let index = Int(indexAsString)
        if let i = index {
            count = i - 1
        }
        print(constantArray)
        print(count)
        if count >= constantArray.count {
            return ""
        }else {
            let stringValue: String = (constantArray[count!] as? String)!
            return stringValue
        }
    }
    
    
    
    @IBAction func viewPatientActionButton() {
        if !Reachability.connectedToNetwork() {
            JLToast.makeText("No Internet Connection").show()
            return
        }
        SwiftSpinner.show("Loading...", animated: true)
        trackEvent("UX", action: "View Patient", label: "view patient button from task detail view", value: nil)
        let patientAPI = PatientAPI()
        
        patientAPI.getPatient(task.patient_id, fromMedicalFacility: sharedDataSingleton.user.clinic_id) { (fetchedPatient:Patient?, error:NSError?) -> () in
            if error == nil {
                SwiftSpinner.hide(nil)
//               self.performSegueWithIdentifier("viewPatient", sender: fetchedPatient)
                let patientProfile = self.storyboard?.instantiateViewControllerWithIdentifier("PatientProfileViewController") as! PatientProfileViewController
                patientProfile.patient = fetchedPatient
                self.navigationController?.pushViewController(patientProfile, animated: true)
            }else {
                SwiftSpinner.hide(nil)
                let alertView = SCLAlertView()
                alertView.showError(self, title: "Error", subTitle: "Failed to get patient. Please try again later", closeButtonTitle: "Cancel", duration: 2000)
            }
        }
    }
    
    
    @IBAction func viewCaseNote() {
        trackEvent("UX", action: "View Case Note", label: "View case note from task detail  view", value: nil)
        let caseNoteTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CaseNoteTableViewController") as! CaseNoteTableViewController
        caseNoteTableViewController.task = self.task
        self.navigationController?.pushViewController(caseNoteTableViewController, animated: true)
    }
    
    func menuViewResponse(controller: MenuViewController,
        didDismissPopupView selectedCell: Int){
            currentCell = selectedCell;
            
            let resolution_id = String(currentCell + 1)
            updateActivityButton.setTitle(self.fetchStringValueFromArray(Contants().resolution, atIndex: resolution_id), forState: UIControlState.Normal)
            self.updateTaskStatus(resolution_id)
            print("choice is \(currentCell)")
    }
    
    func updateTaskStatus(resolution:String) {
        if !Reachability.connectedToNetwork() {
            let dictionary: Dictionary<String, Any> = ["requestType": "UpdateTaskStatus", "taskID": self.task.id, "staffID": sharedDataSingleton.user.id, "resolutionID": resolution, "description":"Update resolution for task with ID \(task.id)"]
            sharedDataSingleton.outbox.append(dictionary)
            JLToast.makeText("Saved to Outbox").show()
            return
        }
        SwiftSpinner.show("Updating resolution")
        let taskAPI = TaskAPI()
        taskAPI.updateTaskStatus(self.task.id, staff_id: sharedDataSingleton.user.id, resolution_id: resolution) { (updatedTask:AnyObject?, error:NSError?) -> () in
            if error != nil {
                SwiftSpinner.hide()
                let alertView = SCLAlertView()
                alertView.showError(self, title: "Error", subTitle: "Failed to update task status. Try again later", closeButtonTitle: "OK", duration: 20000)
            }else {
                SwiftSpinner.hide()
                let alertView = SCLAlertView()
                alertView.showEdit(self, title: "Success", subTitle: "Task Status Updated", closeButtonTitle: "OK", duration: 20000)
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewPatient"{
        let destinationController   = segue.destinationViewController as! PatientProfileViewController
        destinationController.patient = sharedDataSingleton.selectedPatient
        }
    }
}
extension ActivityDetailsViewController {
    
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

