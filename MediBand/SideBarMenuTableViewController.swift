//
//  SideBarMenuTableViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/16/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class SideBarMenuTableViewController: UITableViewController {
    
    var arrayOfViewControllerAdmin = [
        "MEDIBAND",
        "Patients",
        "Task",
        "Scan Patient",
        "Staff",
        "My Profile",
        "Logout"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return arrayOfViewControllerAdmin.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SideMenuCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = arrayOfViewControllerAdmin[indexPath.row]

        // Configure the cell...

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
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
    }

}
