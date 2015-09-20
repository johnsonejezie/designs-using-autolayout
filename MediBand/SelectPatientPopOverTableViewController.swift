//
//  SelectPatientPopOverTableViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/9/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class SelectPatientPopOverTableViewController: UITableViewController {
    
    
    var isExistingPatient:Bool!
    var options = [
        "Existing Patient",
        "New Patient"
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return options.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectPatientCell", forIndexPath: indexPath) 

        cell.textLabel?.text = options[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            isExistingPatient = true
        }else {
            isExistingPatient = false
        }
        self.dismissViewControllerAnimated(true, completion: nil)

        self.performSegueWithIdentifier("PatientSelection", sender: isExistingPatient)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PatientSelection" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ViewController
            controller.isExistingPatient = sender as! Bool
        }
    }
    
}
