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
class ActivityDetailsViewController: UIViewController , UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate, menuViewControllerDelegate{
    
    
    @IBOutlet var taskPatientNameLabel: UILabel!

    
    @IBOutlet var taskCareActivityLabel: UILabel!
    @IBOutlet var assignedStaffLabel: UILabel!
    @IBOutlet var taskResolutionLabel: UILabel!
    @IBOutlet var taskSpecialistLabel: UILabel!
    @IBOutlet var taskPatientImageView: UIImageView!

    var currentCell : Int = 1;
    
    @IBOutlet var navBar: UIBarButtonItem!
    @IBOutlet var attendingProfButton: UIButton!
    @IBOutlet var updateActivityButton: UIButton!
    @IBOutlet var viewCaseNoteButton: UIButton!
    @IBOutlet var viewPatientButton: UIButton!
    @IBOutlet var patientProfilePic: UIImageView!
    @IBOutlet var attendingProfCollectionView: UICollectionView!

    var task:Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStaff()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.attendingProfButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.attendingProfButton.titleLabel?.numberOfLines = 1;
        self.attendingProfButton.layer.cornerRadius = 5.0;
        self.updateActivityButton.layer.cornerRadius = 5.0;
        self.viewCaseNoteButton.layer.cornerRadius = 5.0;
        self.viewPatientButton.layer.cornerRadius = 5.0;
        self.attendingProfCollectionView.dataSource = self
        self.attendingProfCollectionView.delegate = self
        
        let constants = Contants()
        taskSpecialistLabel.text = self.fetchStringValueFromArray(constants.specialist, atIndex: (task.specialist_id as String))
        taskCareActivityLabel.text = self.fetchStringValueFromArray(constants.care, atIndex: (task.care_activity_id as String))
        taskResolutionLabel.text = self.fetchStringValueFromArray(constants.resolution, atIndex: (task.specialist_id as String))
        taskPatientNameLabel.text = task.task_patient_name
        if task.task_patient_image != "" {
            let URL = NSURL(string: task.task_patient_image)!
            self.taskPatientImageView.hnk_setImageFromURL(URL)
        }else {
            self.taskPatientImageView.image = UIImage(named: "defaultImage")
        }
        let assignedStaff = task.attending_professionals[0]
        assignedStaffLabel.text = assignedStaff.name
        
    }
    
    override func viewWillAppear(animated: Bool) {
        setScreeName("Task Detail View")
    }
    
    
    func getStaff(){
        var staffMethods = StaffNetworkCall()
        
        if sharedDataSingleton.allStaffs.count == 0 {
//            SwiftSpinner.show("Loading Staff", animated: true)
            staffMethods.getStaffs(sharedDataSingleton.user.medical_facility, inPageNumber: "1", completionBlock: { (done) -> Void in
                if(done){
                    println("all staffs fetched and passed from staff table view controller")
//                    SwiftSpinner.hide(completion: nil)
                }else{
                    println("error fetching and passing all staffs from staff table view controller")
//                    SwiftSpinner.hide(completion: nil)
                }
            })
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.patientProfilePic.layer.borderWidth = 1.0;
        self.patientProfilePic.layer.borderColor = UIColor.blackColor().CGColor;
        self.patientProfilePic.layer.cornerRadius = self.patientProfilePic.layer.frame.height/2;
        //        userImageView.maskView = ;
        self.patientProfilePic.clipsToBounds = true
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         println(task.attending_professionals.count)
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
        var menuViewController: MenuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
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
        let index = indexAsString.toInt()
        if let i = index {
            count = i - 1
        }
        println(constantArray)
        println(count)
        if count >= constantArray.count {
            return ""
        }else {
            let stringValue: String = (constantArray[count!] as? String)!
            return stringValue
        }
    }
    
    
    
    @IBAction func viewPatientActionButton() {
        SwiftSpinner.show("Loading...", animated: true)
        trackEvent("UX", action: "View Patient", label: "view patient button from task detail view", value: nil)
        let patientAPI = PatientAPI()
        
        patientAPI.getPatient(task.patient_id, fromMedicalFacility: sharedDataSingleton.user.clinic_id) { (fetchedPatient:Patient?, error:NSError?) -> () in
            if error == nil {
                SwiftSpinner.hide(completion: nil)
               self.performSegueWithIdentifier("viewPatient", sender: fetchedPatient)
            }else {
                SwiftSpinner.hide(completion: nil)
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
            self.updateTaskStatus(resolution_id)
            println("choice is \(currentCell)")
    }
    
    func updateTaskStatus(resolution:String) {
        let taskAPI = TaskAPI()
        taskAPI.updateTaskStatus(self.task.id, staff_id: sharedDataSingleton.user.id, resolution_id: resolution) { (updatedTask:AnyObject?, error:NSError?) -> () in
            if error != nil {
                let alertView = SCLAlertView()
                alertView.showError(self, title: "Error", subTitle: "Failed to update task status. Try again later", closeButtonTitle: "Cancel", duration: 20000)
            }else {
                let alertView = SCLAlertView()
                alertView.showEdit(self, title: "Success", subTitle: "Task Status Updated", closeButtonTitle: "Cancel", duration: 20000)
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewPatient"{
        let destinationNavController = segue.destinationViewController as! UINavigationController
        let destinationController   = destinationNavController.topViewController as! PatientProfileViewController
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

