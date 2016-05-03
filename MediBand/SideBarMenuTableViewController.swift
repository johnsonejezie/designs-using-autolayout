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
        "Setting",
        "Outbox",
        "Logout"
    ]
    
    var sideMenuForUsers = [
        "MEDIBAND",
        "Patients",
        "Task",
        "Scan Patient",
        "My Profile",
        "Setting",
        "Outbox",
        "Logout"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sharedDataSingleton.user.isAdmin == true {
            return sideMenuForAdmin.count
        }else {
            return sideMenuForUsers.count
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SideMenuCell", forIndexPath: indexPath) 
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
        if sharedDataSingleton.user.isAdmin == true {
            switch (indexPath.row) {
            case 0:
                performSegueWithIdentifier("GoToHome", sender: nil)
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
                performSegueWithIdentifier("GoToStaff", sender: nil)
                break
            case 5:
                performSegueWithIdentifier("GoToProfile", sender: nil)
                break
            case 6:
                performSegueWithIdentifier("GoToSettings", sender: nil)
                break
            case 7:
                performSegueWithIdentifier("GoToOutbox", sender: nil)
            case 8:
                logout()
                break
            default:
                break
            }
            
        }else {
            
            switch (indexPath.row) {
            case 0:
                performSegueWithIdentifier("GoToHome", sender: nil)
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
                performSegueWithIdentifier("GoToSettings", sender: nil)
            case 6:
                performSegueWithIdentifier("GoToOutbox", sender: nil)
            case 7:
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
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToProfile" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! StaffProfileViewController
            controller.isMyProfile = true
        }else if segue.identifier == "GoToStaff" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! StaffTableViewController
            controller.sideMenuRequired = true
        }
    }
    

}
