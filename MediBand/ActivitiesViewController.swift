//
//  ActivitiesViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/15/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftSpinner

class ActivitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, activityStatusTableViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet var navBar: UIBarButtonItem!

    @IBOutlet weak var tableView: UITableView!
    
    var isPatientTask:Bool?
    var patient:Patient?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        getTask()
        navBar.target = self.revealViewController()
        navBar.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        tableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        
        self.view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setScreeName("Task View")
    }
    
    func getTask() {
        let taskNetworkCall = TaskNetworkCall()
//        let task = Task()
//        taskNetworkCall.create(task, completionBlock: { (success) -> Void in
//            println(success)
//        })
        
        println("this is id \(patient?.patient_id)")
        if isPatientTask == true {
            isPatientTask = false
            if sharedDataSingleton.patientHistory.count > 0 {
                var patient_id:String = ""
                if let aPatient = patient {
                    patient_id = aPatient.patient_id
                }
                taskNetworkCall.getTaskByPatient(patient_id, lCare_activity_id: sharedDataSingleton.user.medical_facility, completionBlock: { (success) -> Void in
                    if success == true {
                        println("done")
                    }else {
                        println("failed")
                    }
                })
            }else {
                SwiftSpinner.show("Getting Patient History", animated: true)
                taskNetworkCall.getTaskByPatient(sharedDataSingleton.selectedPatient.patient_id, lCare_activity_id: sharedDataSingleton.user.medical_facility, completionBlock: { (success) -> Void in
                    if success == true {
                        SwiftSpinner.hide(completion: nil)
                        println("done")
                        
                    }else {
                        SwiftSpinner.hide(completion: nil)
                        println("failed")
                    }
                })
            }
        }else {
            if sharedDataSingleton.staffHistory.count > 0 {
                taskNetworkCall.getTaskByStaff(sharedDataSingleton.user.id, lCare_activity_id: sharedDataSingleton.user.medical_facility) { (success) -> Void in
                    if success == true {
                        println("done")
                    }else {
                        println("false")
                    }
                }
            }else {
                SwiftSpinner.show("Loading task", animated: true)
                taskNetworkCall.getTaskByStaff(sharedDataSingleton.user.id, lCare_activity_id: sharedDataSingleton.user.medical_facility) { (success) -> Void in
                    if success == true {
                        SwiftSpinner.hide(completion: nil)
                        println("done")
                    }else {
                        SwiftSpinner.hide(completion: nil)
                        println("false")
                    }
                }
            }
            
        }
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func segmentControlAction(sender: AnyObject) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            displayPopOver(sender )
        case 1:
            println("date")
        default:
            break
        
        }
        
        searchBar.resignFirstResponder()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        println(touches)
        self.view.endEditing(true)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as! ActivityTableViewCell
        cell.nameLabel.text = "JENNIFER KYARI"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("viewActivity", sender: nil)
        searchBar.resignFirstResponder()
    }
    
    func displayPopOver(sender: AnyObject){
        let storyboard : UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        var contentViewController : ActivityStatusTableViewController = storyboard.instantiateViewControllerWithIdentifier("ActivityStatusTableViewController") as! ActivityStatusTableViewController
        contentViewController.delegate = self
        contentViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        contentViewController.preferredContentSize = CGSizeMake(self.view.frame.size.width * 0.6, 220)
        
        var detailPopover: UIPopoverPresentationController = contentViewController.popoverPresentationController!
        detailPopover.sourceView = sender as! UIView
        detailPopover.sourceRect.origin.x = 50
        detailPopover.sourceRect.origin.y = sender.frame.size.height
        detailPopover.permittedArrowDirections = UIPopoverArrowDirection.Any
        detailPopover.delegate = self
        presentViewController(contentViewController, animated: true, completion: nil)
        
    }
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
       println("The search text is: '\(searchBar.text)'")
    }
    
    func activityStatusTableViewController(controller: ActivityStatusTableViewController, didSelectItem item: String) {
        println(item)
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

}

extension ActivitiesViewController {
    
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
