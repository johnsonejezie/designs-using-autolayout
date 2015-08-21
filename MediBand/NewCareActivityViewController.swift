//
//  NewCareActivityViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/12/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftSpinner


 class NewCareActivityViewController: UIViewController, UIPopoverPresentationControllerDelegate, popUpTableViewControllerDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet var navBar: UIBarButtonItem!
    var popCreated = false
    var dropdownloaded = false
    var dropDownFrame: CGRect!
    var pointY:CGFloat!
    
    var recognizer:UITapGestureRecognizer!

    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var addCaseNoteButton: UIButton!
    

    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func addCaseNoteAction() {
        self.performSegueWithIdentifier("addCaseNote", sender: nil)
    }
    @IBAction func saveActionButton() {
        self.trackEvent("UX", action: "New Task created", label: "Save button to create new task", value: nil)
        
        println(selectSpecialistButton.currentTitle!)
        println(selectCareButton.currentTitle!)
        println(selectTypeButton.currentTitle!)
        println(selectCategoriesButton.currentTitle!)
        println(selectStaff.currentTitle!)
    }
    
    
    
    @IBAction func slideMenuToggle(sender: UIBarButtonItem) {
        
    }
    
    @IBOutlet weak var selectSpecialistButton: UIButton!
    
    @IBOutlet weak var selectCareButton: UIButton!
    
    @IBOutlet weak var selectTypeButton: UIButton!
    
    @IBOutlet weak var selectCategoriesButton: UIButton!
    
    
    @IBOutlet weak var selectStaff: UIButton!
    
    
    var specialist = [
        "Anaesthetics",
        "Cardiology",
        "Clinical Haematology",
        "Clinical Immunology and Allergy",
        "Clinical Oncology",
        "Dermatology",
        "Emergency",
        "ENT",
        "Gastroenterology",
        "General Medicine",
        "General Surgery",
        "Geriatric Medicine",
        "Gynaecology",
        "Medical Oncology",
        "Nephrology",
        "Neurology",
        "Ophthalmology",
        "Oral & Maxillo Facial Surgery",
        "Oral Surgery",
        "Paediatrics",
        "Radiology",
        "Rehabilitation",
        "Respiratory Medicine",
        "Rheumatology",
        "Trauma & Orthopaedics",
        "Urology"
    ]
    
    var care = [
        "Admin EVENT Care Activity",
        
        "OP Attendance Care Activity",
        
        "IP Admission Care Activity",
        
        "Received Referral Care Activity",
        
        "A AND E Care Activity"
    ]
    
    var careType = [
        "Admin EVENT",
        
        "Administration Error",
        
        "Transfer of Care",
        
        "Outpatient - Follow Up",
        
        "Outpatient Clinic",
        
        "Inpatient",
        
        "Current Inpatient",
        
        "Admin EVENT",
        
        "Emergency Care Activity"
    ]
    
    var categories = ["elite category", "child category", "women category", "all category", "no category"]
    
    var staff = ["receptionist", "doctor", "nurse", "director", "cleaner" ]
    
    
    override func viewDidLoad() {
        getStaff()
        
        navBar.target = self.revealViewController()
        navBar.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        selectCareButton.layer.cornerRadius = 4
        selectCategoriesButton.layer.cornerRadius = 4
        selectSpecialistButton.layer.cornerRadius = 4
        selectStaff.layer.cornerRadius = 4
        selectTypeButton.layer.cornerRadius = 4
        
        addCaseNoteButton.layer.cornerRadius = 4
        saveButton.layer.cornerRadius = 3
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setScreeName("New Task View")
    }
    
    
    @IBAction func selectActionButton(sender: UIButton!) {
            displayPopOver(sender)
    }
    
    func displayPopOver(sender: UIButton){
        let storyboard : UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        var contentViewController : PopUpTableViewController = storyboard.instantiateViewControllerWithIdentifier("PopUpTableViewController") as! PopUpTableViewController
        let height:CGFloat?
        if sender.tag == 1000 {
            contentViewController.list = specialist
            height = 44 *  CGFloat(contentViewController.list.count)
        }else if sender.tag == 1001 {
            contentViewController.list = care
            height = 44 *  CGFloat(contentViewController.list.count)
        }else if sender.tag == 1002 {
            contentViewController.list = careType
            height = 44 *  CGFloat(contentViewController.list.count)
        }else if sender.tag == 1003 {
            contentViewController.list = categories
            height = 44 *  CGFloat(contentViewController.list.count)
        }else{
            contentViewController.isSelectingStaff = true
            height = 44 *  CGFloat(sharedDataSingleton.allStaffs.count)
        }
        contentViewController.delegate = self
        
        contentViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        contentViewController.preferredContentSize = CGSizeMake(self.view.frame.size.width * 0.6, height!)
        
        var detailPopover: UIPopoverPresentationController = contentViewController.popoverPresentationController!
        detailPopover.sourceView = sender
        detailPopover.sourceRect.origin.x = 50
        detailPopover.permittedArrowDirections = UIPopoverArrowDirection.Any
        detailPopover.delegate = self
        presentViewController(contentViewController, animated: true, completion: nil)
    
    }
    
    func popUpTableViewController(controller: PopUpTableViewController, didSelectItem item: String, fromArray: [String]) {
        
        if fromArray == specialist {
            selectSpecialistButton.setTitle(item.uppercaseString, forState: UIControlState.Normal)
        }else if fromArray == care {
            selectCareButton.setTitle(item.uppercaseString, forState: UIControlState.Normal)
        }else if fromArray == careType {
            selectTypeButton.setTitle(item.uppercaseString, forState: UIControlState.Normal)
        }else if fromArray == categories {
            selectCategoriesButton.setTitle(item.uppercaseString, forState: UIControlState.Normal)
        }else {
            selectStaff.setTitle(item.uppercaseString, forState: UIControlState.Normal)
        }
        
        println(item)
    }
    
    func getStaff(){
        var staffMethods = StaffNetworkCall()
        
        if sharedDataSingleton.allStaffs.count == 0 {
            SwiftSpinner.show("Loading Staff", animated: true)
            staffMethods.getStaffs(sharedDataSingleton.user.medical_facility, inPageNumber: "1", completionBlock: { (done) -> Void in
                if(done){
                    println("all staffs fetched and passed from staff table view controller")
                    SwiftSpinner.hide(completion: nil)
                }else{
                    println("error fetching and passing all staffs from staff table view controller")
                  SwiftSpinner.hide(completion: nil)  
                }
            })
        }
    }
    
    func popUpTableViewControllerDidCancel(controller: PopUpTableViewController) {
        println("cancelled")
    }
    

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
    }
    
    func presentationController(controller: UIPresentationController!, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle)
        -> UIViewController! {
        let navController = UINavigationController(rootViewController: controller.presentedViewController)
        return navController
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addCaseNote" {
            let toViewController = segue.destinationViewController as! CaseDetailViewController
            toViewController.transitioningDelegate = self
            toViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        var animationPresentationController = AnimationPresentationController()
        
        animationPresentationController.isPresenting = true
        
        return animationPresentationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var animationPresentationController = AnimationPresentationController()
        return animationPresentationController
    }
    
    
}

extension NewCareActivityViewController {
    
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

extension UINavigationController {
    public override func supportedInterfaceOrientations() -> Int {
        if visibleViewController is NewCareActivityViewController {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        }
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }
}



