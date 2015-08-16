//
//  ActivitiesViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/15/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class ActivitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, activityStatusTableViewControllerDelegate, UIPopoverPresentationControllerDelegate, ENSideMenuDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    @IBAction func slideMenuToggle(sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        var taskActions = TaskNetworkCall()
        
//        taskActions.getTaskByStaff(32, lCare_activity_id: "Teaching Hospital");
//        taskActions.create(<#task: Task#>);
        var test = TaskNetworkCall()
            
        let task = Task()
        
        task.patient_id = "419"
        task.care_activity_category_id = "3"
        task.care_activity_id = "2"
        task.care_activity_type_id = "1"
        task.medical_facility_id = "Teaching Hospital"
        task.selected_staff_ids = ["32", "29"]
        task.speciality_id = "2"
        
    
        
        test.create(task)
        
//        test.getTaskByStaff(32, lCare_activity_id: "2")
        
        
         self.sideMenuController()?.sideMenu?.delegate = self
        tableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        
        self.view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)

    }
    
    override func viewWillAppear(animated: Bool) {
        self.setScreeName("Task View")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
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
