//
//  MyMenuTableViewController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 29.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit

class MyMenuTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    var selectedMenuItem : Int = 0
    
    var arrayOfViewControllerAdmin = [
        "Task",
        "Patients",
        "Scan Patient",
        "My Profile",
        "Staff",
        "Logout"
    ]
    
    var arrayViewController = [
        "My Task",
        "My Patients",
        "Scan Patient",
        "My Profile",
        "Logout"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 6
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.darkGrayColor()
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
//        if User().role == "Admin" {
            cell!.textLabel?.text = arrayOfViewControllerAdmin[indexPath.row]
//        }else {
//           cell!.textLabel?.text = arrayViewController[indexPath.row]
//        }
        
        
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var isPop = false
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        println("Selected row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
            return
        }
        
        selectedMenuItem = indexPath.row
        
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TaskViewController") as! ActivitiesViewController
            break
        case 1:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("PatientsViewController")as! PatientsViewController
            break
        case 2:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SelectPatientPopOverTableViewController") as! SelectPatientPopOverTableViewController
            let height:CGFloat = 44 *  CGFloat(2)
            destViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            destViewController.preferredContentSize = CGSizeMake(self.view.frame.size.width, height)
            var detailPopover: UIPopoverPresentationController = destViewController.popoverPresentationController!
            detailPopover.sourceView = cell
            detailPopover.sourceRect.origin.x = cell!.frame.size.width/2.2
            detailPopover.permittedArrowDirections = UIPopoverArrowDirection.Any
            detailPopover.delegate = self
            isPop = true
            presentViewController(destViewController, animated: true, completion: nil)
            break
        case 3:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("StaffProfileViewController") as! StaffProfileViewController
        case 4:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("StaffViewController") as! StaffTableViewController
        case 5:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        default:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController4") as! UIViewController
            break
        }
        if !isPop{
           sideMenuController()?.setContentViewController(destViewController)
        }
        
    }
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        println("I was called too")
        selectedMenuItem = 0
        tableView.reloadData()
        return true
    }
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }

}
