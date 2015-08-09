//
//  NewCareActivityViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/12/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit


 class NewCareActivityViewController: UIViewController, UIPopoverPresentationControllerDelegate, popUpTableViewControllerDelegate, UIViewControllerTransitioningDelegate, ENSideMenuDelegate {
    
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
        println(selectSpecialistButton.currentTitle!)
        println(selectCareButton.currentTitle!)
        println(selectTypeButton.currentTitle!)
        println(selectCategoriesButton.currentTitle!)
        println(selectStaff.currentTitle!)
    }
    
    
    
    @IBAction func slideMenuToggle(sender: UIBarButtonItem) {
        
        toggleSideMenuView()
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
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
        "Urology"]
    
    var care = ["That care", "this care", "fake care", "real care", "another care", "final care"]
    
    var careType = ["Which type", "What type", "This type", "Best care", "worst care"]
    
    var categories = ["elite category", "child category", "women category", "all category", "no category"]
    
    var staff = ["receptionist", "doctor", "nurse", "director", "cleaner" ]
    
    
    override func viewDidLoad() {
        selectCareButton.layer.cornerRadius = 4
        selectCategoriesButton.layer.cornerRadius = 4
        selectSpecialistButton.layer.cornerRadius = 4
        selectStaff.layer.cornerRadius = 4
        selectTypeButton.layer.cornerRadius = 4
        
        addCaseNoteButton.layer.cornerRadius = 4
        saveButton.layer.cornerRadius = 3
        
         self.sideMenuController()?.sideMenu?.delegate = self
    }
    
    
    @IBAction func selectActionButton(sender: UIButton!) {
            displayPopOver(sender)
    }
    
    func displayPopOver(sender: UIButton){
        let storyboard : UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        var contentViewController : PopUpTableViewController = storyboard.instantiateViewControllerWithIdentifier("PopUpTableViewController") as! PopUpTableViewController
        
        if sender.tag == 1000 {
            contentViewController.list = specialist
        }else if sender.tag == 1001 {
            contentViewController.list = care
        }else if sender.tag == 1002 {
            contentViewController.list = careType
        }else if sender.tag == 1003 {
            contentViewController.list = categories
        }else{
            contentViewController.containImage = true
            contentViewController.list = staff
        }
        contentViewController.delegate = self
        let height:CGFloat = 44 *  CGFloat(contentViewController.list.count)
        contentViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        contentViewController.preferredContentSize = CGSizeMake(self.view.frame.size.width * 0.6, height)
        
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

extension UINavigationController {
    public override func supportedInterfaceOrientations() -> Int {
        if visibleViewController is NewCareActivityViewController {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        }
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }
}



