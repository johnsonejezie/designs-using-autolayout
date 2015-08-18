//
//  SideBarMenuTableViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/16/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class SideBarMenuTableViewController: UITableViewController {
    
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
        if sharedDataSingleton.user.role == "Admin" {
            return sideMenuForAdmin.count
        }else {
            return sideMenuForUsers.count
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SideMenuCell", forIndexPath: indexPath) as! UITableViewCell
        let sideMenuContent:[AnyObject]
        if sharedDataSingleton.user.role == "Admin" {
            sideMenuContent = sideMenuForAdmin
        }else {
            sideMenuContent = sideMenuForUsers
        }
        cell.textLabel?.text = sideMenuContent[indexPath.row] as? String
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if sharedDataSingleton.user.role == "Admin" {
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
                performSegueWithIdentifier("GoToStaff", sender: nil)
                break
            case 5:
                performSegueWithIdentifier("GoToProfile", sender: nil)
                break
            case 6:
                println("log out")
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
                println("Log out")
                break
            default:
                break
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToProfile" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! StaffProfileViewController
            controller.isMyProfile = true
        }
    }
    

}
