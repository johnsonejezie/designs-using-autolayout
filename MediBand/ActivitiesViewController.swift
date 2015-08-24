//
//  ActivitiesViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/15/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftSpinner

class ActivitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, activityStatusTableViewControllerDelegate, UIPopoverPresentationControllerDelegate, NSURLConnectionDataDelegate {
    
    
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    
    @IBOutlet var navBar: UIBarButtonItem!

    @IBOutlet weak var tableView: UITableView!
    
    var isPatientTask:Bool?
    var patient:Patient?
    var tasks = [Task]()
    
    var patientID:String?

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
        let taskAPI = TaskAPI()
        if isPatientTask == true {
            if let patient_id = patientID {
                taskAPI.getTaskByPatient(patient_id, page: "1", callback: { (task:AnyObject?, error:NSError?) -> () in
                    if error != nil {
                        
                    }else {
                       sharedDataSingleton.tasks = task as! [Task]
                    }
                    self.tasks = sharedDataSingleton.tasks
                    self.tableView.reloadData()
                })
            }
        }else {
            taskAPI.getTaskByStaff(sharedDataSingleton.user.id, page: "1", callback: { (task:AnyObject?, error:NSError?) -> () in
                if error != nil {
                    
                }else {
                    sharedDataSingleton.tasks = task as! [Task]
                }
                self.tasks = sharedDataSingleton.tasks
                self.tableView.reloadData()
            })
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
        var count = 1
        if tasks.count > 0 {
            count = tasks.count
        }
        return count
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        println(touches)
        self.view.endEditing(true)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as! ActivityTableViewCell
        if tasks.count > 0 {
            let task = self.tasks[indexPath.row]
            cell.specialityLabel.text = task.specialist_id
            cell.careActivityLabel.text = task.care_activity_id
            cell.activityTypeLabel.text = task.care_activity_type_id
            cell.resolutionLabel.text = task.resolution
            cell.dateLabel.text = task.created
        } else {
            cell.specialityLabel.text = ""
            cell.careActivityLabel.text = ""
            cell.resolutionLabel.text = ""
            cell.dateLabel.text = ""
            cell.activityTypeLabel.text = "No Task"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let task = self.tasks[indexPath.row]
        
        self.performSegueWithIdentifier("viewActivity", sender: task)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewActivity" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ActivityDetailsViewController
            controller.task = sender as! Task
        }
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
