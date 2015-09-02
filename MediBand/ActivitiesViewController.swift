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
    
    var deleteTaskIndexPath: NSIndexPath? = nil
    var isPatientTask:Bool?
    var patient:Patient?
    var tasks = [Task]()
    var srcViewStaffID : String = ""
    var patientID:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tasks = sharedDataSingleton.staffTask
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
                
                if sharedDataSingleton.patientTask.count == 0 {
                    SwiftSpinner.show("Loading Task", animated: true)
                }
                taskAPI.getTaskByPatient(patient_id, page: "1", callback: { (task:AnyObject?, error:NSError?) -> () in
                    if error != nil {
                        
                    }else {
//                       sharedDataSingleton.tasks = task as! [Task]
                    }
//                    self.tasks = sharedDataSingleton.tasks\
                    self.tasks = sharedDataSingleton.patientTask
                    self.tableView.reloadData()
                    SwiftSpinner.hide(completion: nil)
                })
                
            }
        }else {
            
            if sharedDataSingleton.staffTask.count == 0 {
                SwiftSpinner.show("Loading Task", animated: true)
            }
            var staffID :String
            
            if srcViewStaffID != "" {
            staffID = srcViewStaffID
            srcViewStaffID = ""
            }else{
             staffID = sharedDataSingleton.user.id
            }
            
            
            taskAPI.getTaskByStaff(staffID, page: "1", callback: { (task:AnyObject?, error:NSError?) -> () in
                if error != nil {
            
                }else {
//                    sharedDataSingleton.tasks = task as! [Task]
                }
                self.tasks = sharedDataSingleton.staffTask
//                self.tasks = sharedDataSingleton.tasks
                self.tableView.reloadData()
                SwiftSpinner.hide(completion: nil)
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
            cell.specialityLabel.hidden = false
            cell.careActivityLabel.hidden = false
            cell.resolutionLabel.hidden = false
            cell.dateLabel.hidden = false
            cell.activityTypeLabel.hidden = false
            cell.emptyLabel.hidden = true
            
            let constants = Contants()
            let task = self.tasks[indexPath.row]
            cell.specialityLabel.text = self.fetchStringValueFromArray(constants.specialist, atIndex: (task.specialist_id as String))
            cell.careActivityLabel.text = self.fetchStringValueFromArray(constants.care, atIndex: (task.care_activity_id as String))
            cell.activityTypeLabel.text = self.fetchStringValueFromArray(constants.careType, atIndex: (task.care_activity_type_id as String))
            cell.resolutionLabel.text = task.resolution
   
            cell.dateLabel.text = task.created
        } else {
            cell.specialityLabel.hidden = true
            cell.careActivityLabel.hidden = true
            cell.resolutionLabel.hidden = true
            cell.dateLabel.hidden = true
            cell.activityTypeLabel.hidden = true
            cell.emptyLabel.hidden = false
            if sharedDataSingleton.user.role == "Admin" {
                cell.emptyLabel.text = "NO TASK HAVE BEEN CREATED YET"
            }else {
                cell.emptyLabel.text = "NO TASK ASSIGNED TO YOU"
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let task = self.tasks[indexPath.row]
        self.performSegueWithIdentifier("viewActivity", sender: task)
        searchBar.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteTaskIndexPath = indexPath
            let taskToDelete = self.tasks[indexPath.row]
            confirmDelete(taskToDelete)
        }
    }
    
    func confirmDelete(task: Task) {
        let alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to permanently delete this task?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteTask)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeletePlanet)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeleteTask(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteTaskIndexPath {
            let task = self.tasks[indexPath.row]
            tableView.beginUpdates()
            
            self.tasks.removeAtIndex(indexPath.row)
            let taskAPI = TaskAPI()
            taskAPI.deleteTask(task.id, staff_id: sharedDataSingleton.user.id)
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            deleteTaskIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
        deleteTaskIndexPath = nil
    }
    
    
    func fetchStringValueFromArray(constantArray:[AnyObject], atIndex indexAsString:String)->String {
        var count:Int?
       let index = indexAsString.toInt()
        if let i = index {
            count = i - 1
        }
        println(constantArray)
        println(count)
        let stringValue: String = (constantArray[count!] as? String)!
        return stringValue
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
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle)
        -> UIViewController? {
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
