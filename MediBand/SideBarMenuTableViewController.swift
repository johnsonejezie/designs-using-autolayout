//
//  SideBarMenuTableViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/16/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper


class SideBarMenuTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    var sideMenuForAdmin = [
        "MEDIBAND",
        "Patients",
        "Task",
        "Scan Patient",
        "Staff",
        "My Profile",
        "Logout"
    ]
    
    var sideMenuForUsers = [
        "MEDIBAND",
        "Patients",
        "Task",
        "Scan Patient",
        "My Profile",
        "Logout"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sharedDataSingleton.user.isAdmin == true {
            return sideMenuForAdmin.count
        }else {
            return sideMenuForUsers.count
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SideMenuCell", forIndexPath: indexPath) as! UITableViewCell
        let sideMenuContent:[AnyObject]
        if sharedDataSingleton.user.isAdmin == true {
            sideMenuContent = sideMenuForAdmin
        }else {
            sideMenuContent = sideMenuForUsers
        }
        cell.textLabel?.text = sideMenuContent[indexPath.row] as? String
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        println(sharedDataSingleton.user.isAdmin)
        if sharedDataSingleton.user.isAdmin == true {
            switch (indexPath.row) {
            case 0:
                break
            case 1:
                performSegueWithIdentifier("GoToPatients", sender: nil)
                break
            case 2:
                performSegueWithIdentifier("GoToTask", sender: nil)
                break
            case 3:
                self.displayPopOver(cell!)
                break
            case 4:
                performSegueWithIdentifier("GoToStaff", sender: nil)
                break
            case 5:
                performSegueWithIdentifier("GoToProfile", sender: nil)
                break
            case 6:
                logout()
                break
            default:
                break
            }
            
        }else {
            
            switch (indexPath.row) {
            case 0:
                break
            case 1:
                performSegueWithIdentifier("GoToPatients", sender: nil)
                break
            case 2:
                performSegueWithIdentifier("GoToTask", sender: nil)
                break
            case 3:
                performSegueWithIdentifier("GoToBarcode", sender: nil)
                break
            case 4:
                performSegueWithIdentifier("GoToProfile", sender: nil)
                break
            case 5:
                logout()
                break
            default:
                break
            }
        }
    }
    
    func logout(){
        let removeEmailSuccessful: Bool = KeychainWrapper.removeObjectForKey("email")
        let removePasswordSuccessful: Bool = KeychainWrapper.removeObjectForKey("password")
        destroy()
        println(removeEmailSuccessful)
        println(removePasswordSuccessful)
        performSegueWithIdentifier("LogOut", sender: nil)
    }
    
    func destroy() {
        sharedDataSingleton.allStaffs = []
        sharedDataSingleton.user = nil
        sharedDataSingleton.selectedPatient = nil
        sharedDataSingleton.selectedStaff = nil
        sharedDataSingleton.tasks = []
        sharedDataSingleton.patientHistory = []
        sharedDataSingleton.staffHistory = []
    }
    
    func displayPopOver(sender: AnyObject){
        let height = CGFloat(88)
        let storyboard : UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        var contentViewController : SelectPatientPopOverTableViewController = storyboard.instantiateViewControllerWithIdentifier("SelectPatientPopOverTableViewController") as! SelectPatientPopOverTableViewController
//        contentViewController.delegate = self
        contentViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        contentViewController.preferredContentSize = CGSizeMake(self.view.frame.size.width * 0.6, height)
        var detailPopover: UIPopoverPresentationController = contentViewController.popoverPresentationController!
        detailPopover.sourceView = sender as! UIView
        detailPopover.sourceRect.origin.x = 50
        detailPopover.permittedArrowDirections = UIPopoverArrowDirection.Any
        detailPopover.delegate = self
        presentViewController(contentViewController, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToProfile" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! StaffProfileViewController
            controller.isMyProfile = true
        }
    }
    

}
