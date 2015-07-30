//
//  ActivitiesViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/15/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class ActivitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, activityStatusTableViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        
        self.view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)

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
